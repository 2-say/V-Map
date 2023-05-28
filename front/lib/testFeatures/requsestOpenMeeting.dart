import 'dart:convert';
import 'dart:io';
import 'package:front/firestore/firebaseController.dart';
import 'package:front/testFeatures/debugMessage.dart';
import 'package:http/http.dart' as http;
import 'NoCheckCertificateHttpOverrides.dart';

class FeaturesMeeting {
  Future<String> postNotion(String id, String meetingName, List<String> meetingParticipants) async {
    final url = Uri.parse('https://vmap.me/postNotion?documentId=' + id);
    DateTime dt = DateTime.now();
    // JSON body
    final body = {
      "meetingName": meetingName,
      "meetingParticipants": meetingParticipants,
      "startTime": dt.toIso8601String()
    };
    HttpOverrides.global = NoCheckCertificateHttpOverrides();
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // 요청이 성공적으로 완료됨
      print('Post request successful');
      print('Response body: ${response.body}');
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return jsonData['pageId'];
    } else {
      // 요청이 실패함
      print('GET request failed with status: ${response.statusCode}');
      throw Exception('GET request failed');
    }
  }

  Future<String> patchNotion(String dt, String id, String user, String content) async {
    var url = Uri.parse('https://vmap.me/patchNotion?documentId=' + id);
    Map<String, Object> data = {
      "user": user,
      "time": dt,
      "contents": content,
    };
    DebugMessage(
      isItPostType: true,
      featureName: 'patchNotion',
      dataType: 'json',
      data: data,
    ).messagePost();
    var body = json.encode(data);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*'
    };
    final http.Response response = await http.post(url, body: body, headers: headers);
    print('post!');
    print(response.body);
    return response.body.toString();
  }

  Future<String> authNotion() async {
    var url = Uri.parse('https://vmap.me/notionAuth');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*'
    };
    final http.Response response = await http.get(url,headers: headers);
    final token = Uri.parse(response.body).queryParameters['token'];
    print(token);
    print('post!');
    print(response.body);
    return response.body.toString();
  }

  Future<String> editNotion(String time, String id, String content) async {
    var url = Uri.parse('https://vmap.me/editNotion?documentId=' + id);
    Map<String, Object> data = {
      "time": time,
      "contents": content,
    };
    DebugMessage(
      isItPostType: true,
      featureName: 'patchNotion',
      dataType: 'json',
      data: data,
    ).messagePost();
    var body = json.encode(data);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': '*'
    };
    final http.Response response = await http.post(url, body: body, headers: headers);
    print('post!');
    print(response.body);
    return response.body.toString();
  }

  Future<String> createMeeting(String id) async {
    var url = Uri.parse('https://vmap.me/createMeeting?documentId=' + id);
    DebugMessage(
      isItPostType: true,
      featureName: 'patchNotion',
      dataType: 'json',
      data: '줌 회의 시작.',
    ).messagePost();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final http.Response response = await http.get(url);
    print('get!');
    print(response.body);
    return response.body.toString();
  }
}

//
// void main() {
//   HttpOverrides.global = NoCheckCertificateHttpOverrides(); //안전하지 않아도 연결하도록
//   // FirebaseController().updateMeetingContents('7de0a808ff14', 'test', '00:00', '00:00', 'ㅋㅋㅋㅋㅋ 테스트!');
// }
