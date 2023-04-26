import 'dart:convert';
import 'package:front/testFeatures/debugMessage.dart';
import 'package:http/http.dart' as http;

class FeaturesMeeting {
  Future<String> openMeeting(
      String meetingName, List<String> meetingParticipants) async {
    DateTime dt = DateTime.now();
    // post 시 쓸 url 물어보고 여기에 입력해줘 'putInHere'!!!
    var url = Uri.parse('putInHere');
    //함수 사용시 쓸 data ( 인스턴스 참조 )
    //생각해보니 json 형태를 안정해놔서 임의로 작성함..
    Map<String, Object> data = {
      "meetingName": meetingName,
      //2023-04-27 06:42:07.601068 <- 과 같은 형태
      "time": dt.toString(),
      "meetingParticipants": meetingParticipants
    };
    // 최종 body 결과물
    // {meetingName: testMeeting, time: 2023-04-27 06:42:07.601068, meetingParticipants: [이세희, 임재경, 조원희]}
    DebugMessage(isItPostType: true, featureName: 'openMeeting', dataType: 'json', data: data).message();
    //더미데이터 ( 테스트용 )
    var body = json.encode(data);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final http.Response response =
        await http.post(url, body: body, headers: headers);
    print('post!');
    print(response.body);
    //response.body를 string 형변환 후 선언 부에 리턴
    return response.body.toString();
  }
}

void main() {
  const String dummyMeetingName = 'testMeeting';
  final List<String> dummyParticipants = ['이세희', '임재경', '조원희'];
  FeaturesMeeting()
      .openMeeting(dummyMeetingName, dummyParticipants)
      //만약 성공적으로 return 받는다면 value 출력
      .then((value) => print(value));
}
