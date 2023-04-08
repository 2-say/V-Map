import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:http/src/client.dart';

Future<String?> getAccessToken() async {
  final client = http.Client();
  final response = await client.post(
      Uri.parse('https://openapi.vito.ai/v1/authenticate'),
      body: {'client_id': 'jp4X0g-b-gPYQBlqrh8v', 'client_secret': 'q2cjhxRgsHpRMnUWJr8EhGP02xQAhOpd6irMEwpA'});

  final Map<String, dynamic> data = json.decode(response.body);
  return data['access_token'];
}

Future<void> main() async {
  final client = http.Client();
  final token = await getAccessToken();

  final httpBuilder = Uri.parse('https://openapi.vito.ai/v1/transcribe:streaming')
      .resolveUri(Uri(queryParameters: {
    'sample_rate': '8000',
    'encoding': 'LINEAR16',
    'use_itn': 'true',
    'use_disfluency_filter': 'true',
    'use_profanity_filter': 'true',
  }))
      .replace(scheme: 'wss');

  final request = http.Request('GET', httpBuilder);
  request.headers['Authorization'] = 'Bearer $token';

  final channel = IOWebSocketChannel.connect(Uri.parse(httpBuilder.toString()));
  final file = File('C:/Download/Android/i_practice_vito/lib/sample.wav');
  final inStream = file.openRead();

  await for (var data in inStream) {
    if (data is List<int>) {
      channel.sink.add(Uint8List.fromList(data));
    }
  }

  await channel.sink.close();
  client.close();
}

class VitoWebSocketListener {
  Future<void> onOpen() async {
    print('Open');
  }

  Future<void> onMessage(dynamic message) async {
    if (message is String) {
      print(message);
    } else if (message is Uint8List) {
      print(message.buffer.asByteData().buffer.asInt16List());
    }
  }

  Future<void> onClose(int code, String reason) async {
    print('Closing');
  }

  Future<void> onError(Object error, StackTrace stackTrace) async {
    print('Error: $error');
  }
}