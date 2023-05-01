import 'dart:convert';
import 'dart:io';
import 'package:front/testFeatures/debugMessage.dart';
import 'package:http/http.dart' as http;
import 'NoCheckCertificateHttpOverrides.dart';

class FeaturesMeeting {
  Future<String> openMeeting(
      String meetingName, List<String> meetingParticipants) async {
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
        .message();
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
}

void main() {
  HttpOverrides.global = NoCheckCertificateHttpOverrides(); //안전하지 않아도 연결하도록

  const String dummyMeetingName = 'testMeeting';
  final List<String> dummyParticipants = ['이세희', '임재경', '조원희'];
  FeaturesMeeting()
      .openMeeting(dummyMeetingName, dummyParticipants)
      //만약 성공적으로 return 받는다면 value 출력
      .then((value) => print(value));
}
