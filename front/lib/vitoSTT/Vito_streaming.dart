import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<String> getToken(String clientId, String clientSecret) async {
  final response = await http.post(
    Uri.parse("https://openapi.vito.ai/v1/authenticate"),
    body: {
      "client_id": clientId,
      "client_secret": clientSecret,
    },
  );

  final token = json.decode(response.body)["access_token"];
  return token;
}

Future<void> streamingTranscribe(String clientId, String clientSecret, {Map<String, String>? config}) async {
  final apiBase = "https://openapi.vito.ai";
  final token = await getToken(clientId, clientSecret);
  final authHeader = {"Authorization": "bearer " + token};

  config ??= {
    "sample_rate": "48000",
    "encoding": "LINEAR16",
    "use_itn": "true",
    "use_disfluency_filter": "true",
    "use_profanity_filter": "false",
  };

  final streamingEndpoint = Uri.parse(
      "wss://${apiBase.split("://")[1]}/v1/transcribe:streaming?" +
          config.entries.map((entry) => "${entry.key}=${entry.value}").join("&"));

  print("start");

  Process? process;

  try {
    final socket = await WebSocket.connect(streamingEndpoint.toString(), headers: authHeader);
    final recorder = await startRecorderFFMpeg(); // 수정된 함수 사용
    socket.addStream(recorder).then((_) => socket.add("EOS"));

    socket.listen((dynamic data) {
      final msg = json.decode(data.toString());
      if (msg["final"]) {
        //stdout.write("${msg["alternatives"][0]["text"]}/");
        print(msg["alternatives"][0]["text"]);
      }
    }).onDone(() {
      print("\nDone.");
      process?.kill(ProcessSignal.sigterm);
      exit(0);
    });
  } catch (e) {
    print("Error: $e");
  }
}

Future<Stream<List<int>>> startRecorderFFMpeg() async { // 수정된 함수
  final stream = StreamController<List<int>>();
  final ffmpegPath = "C:/Program Files/ffmpeg-6.0-essentials_build/bin/ffmpeg.exe"; // ffmpeg.exe 파일 경로
  final process = await Process.start(
    ffmpegPath,
    [
      "-f", "dshow", // DirectShow input format 사용
      "-i", "audio=마이크(Realtek(R) Audio)", // 사용하는 마이크 이름 입력
      "-ac", "1",
      "-ar", "48000",
      "-f", "s16le",
      "-"
    ],
    runInShell: false,
  );

  process.stderr.listen((data) {
    print(utf8.decode(data));
  });

  process.stdout.listen((data) {
    stream.add(data);
  });

  return stream.stream;
}

void main() async {
  final clientId = "jp4X0g-b-gPYQBlqrh8v";
  final clientSecret = "q2cjhxRgsHpRMnUWJr8EhGP02xQAhOpd6irMEwpA";

  await streamingTranscribe(clientId, clientSecret);
}