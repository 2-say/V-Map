import 'dart:convert';
import 'dart:io';
import 'package:front/testFeatures/debugMessage.dart';
import 'package:http/http.dart' as http;
import 'NoCheckCertificateHttpOverrides.dart';

class FeaturesMeeting {
  Future<String> openMeeting(String meetingName,
      List<String> meetingParticipants) async {
    DateTime dt = DateTime.now();
    var url = Uri.parse('https://218.150.182.202:32929/start');
    Map<String, Object> data = {
      "meetingName": meetingName,
      "time": dt.toString(),
      "meetingParticipants": meetingParticipants
    };
    DebugMessage(
        isItPostType: true,
        featureName: 'openMeeting',
        dataType: 'json',
        data: data)
        .messagePost();
    var body = json.encode(data);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final http.Response response =
    await http.post(url, body: body, headers: headers);
    print('post!');
    print(response.body);
    return response.body.toString();
  }

  Future<String> postNotion(String conetents,
      List<String> meetingParticipants) async {
    DateTime dt = DateTime.now();
    var url = Uri.parse('https://218.150.182.202:32929/postNotion');
    Map<String, Object> data = {
      "contents": conetents,
      "time": dt.toString(),
      "meetingParticipants": meetingParticipants
    };
    DebugMessage(
        isItPostType: true,
        featureName: 'postNotion',
        dataType: 'json',
        data: data)
        .messagePost();
    var body = json.encode(data);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final http.Response response =
    await http.post(url, body: body, headers: headers);
    print('post!');
    print(response.body);
    return response.body.toString();
  }

  Future<String> patchNotion(String meetingName,
      String meetingParticipants) async {
    DateTime dt = DateTime.now();
    var url = Uri.parse('https://218.150.182.202:32929/patchNotion');
    Map<String, Object> data = {
      "contents": meetingName,
      "time": dt.toString(),
      "user": meetingParticipants
    };
    DebugMessage(
        isItPostType: true,
        featureName: 'patchNotion',
        dataType: 'json',
        data: data)
        .messagePost();
    var body = json.encode(data);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final http.Response response =
    await http.post(url, body: body, headers: headers);
    print('post!');
    print(response.body);
    return response.body.toString();
  }

  Future<String> authNotion() async {
    DateTime dt = DateTime.now();
    var url = Uri.parse('https://218.150.182.202:32929/notionAuth');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final http.Response response = await http.get(url);
    final token = Uri
        .parse(response.body)
        .queryParameters['token'];
    print(token);
    print('post!');
    print(response.body);
    return response.body.toString();
  }

  void authNotion2() async {


    String url = 'https://218.150.182.202:32929/notionApiTest?code=123123';

    http.Response response = await http.get(Uri.parse(url));
    String responseBody = response.body;
    print(responseBody);
  }
}


void main() {
  HttpOverrides.global = NoCheckCertificateHttpOverrides(); //안전하지 않아도 연결하도록

  // const String dummyMeetingName = 'testMeeting';
  // final List<String> dummyParticipants = ['이세희', '임재경', '조원희'];
  // const String dummyParticipant = '이세희';
  // const String dummyContents = '이세희는 신이고 이는 증명 가능하다.';
  // FeaturesMeeting()
  //     .postNotion(dummyMeetingName, dummyParticipants)
  //     //만약 성공적으로 return 받는다면 value 출력
  //     .then((value) => print(value));
  //
  // FeaturesMeeting()
  //     .patchNotion(dummyContents, dummyParticipant)
  //     //만약 성공적으로 return 받는다면 value 출력
  //     .then((value) => print(value));

  FeaturesMeeting().authNotion2();
}
