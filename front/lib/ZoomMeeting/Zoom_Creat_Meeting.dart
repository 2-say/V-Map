import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

void main() {
  createZoomMeeting();
}

void createZoomMeeting() async {
  final apiKey = 'ru1ye_lgTMWHIiPiY6G7SQ';
  final apiSecret = 'c0hcgeYFsHjNNJ0DOG2EvbKOtQGOqxVrDHXN';
  final zoomUserId = 'bbq0322@naver.com';

  // JWT 토큰 생성
  final payload = {
    'iss': apiKey,
    'exp': DateTime.now().toUtc().add(Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
  };

  final base64UrlHeader = base64Url.encode(utf8.encode(json.encode({'alg': 'HS256', 'typ': 'JWT'})));
  final base64UrlPayload = base64Url.encode(utf8.encode(json.encode(payload)));
  final signingInput = '$base64UrlHeader.$base64UrlPayload';
  final hmacSha256 = Hmac(sha256, utf8.encode(apiSecret));
  final base64UrlSignature = base64Url.encode(hmacSha256.convert(utf8.encode(signingInput)).bytes);
  final token = '$signingInput.$base64UrlSignature';

  // Zoom API를 이용한 회의 생성
  final url = 'https://api.zoom.us/v2/users/$zoomUserId/meetings';

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final data = {
    'topic': 'Zoom Meeting',
    'type': 2,
    'start_time': '2023-05-03T13:00:00Z',
    'duration': 60,
    'timezone': 'Asia/Seoul',
    'agenda': 'This is a test meeting'
  };

  final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(data));

  if (response.statusCode == 201) {
    final responseData = json.decode(response.body);
    final startUrl = responseData['start_url'];
    final joinUrl = responseData['join_url'];
    final startTimeString = responseData['start_time'];
    final topic = responseData['topic'];
    final createdAt = responseData['created_at'];
    final password = responseData['password'];
    final startTime = DateTime.parse(startTimeString);

    final duration = int.parse(data['duration'].toString());
    final endTime = startTime.add(Duration(minutes: duration));

    print('Start URL: $startUrl');
    print('Join URL: $joinUrl');
    print('Start Time: $startTime');
    print('End Time: $endTime');
    print('Topic: $topic');
    print('Created At: $createdAt');
    print('Password: $password');

    // 회의 종료까지 기다림
    await Future.delayed(Duration(minutes: duration));

    final endUrl = 'https://api.zoom.us/v2/meetings/${responseData['id']}/status';
    final endResponse = await http.put(Uri.parse(endUrl), headers: headers, body: json.encode({'action': 'end'}));

    if (endResponse.statusCode == 204) {
      print('Meeting has ended at ${DateTime.now()}');
    } else {
      print('Failed to end Zoom meeting. Status code: ${endResponse.statusCode}');
    }

  } else {
    print('Failed to create Zoom meeting. Status code: ${response.statusCode}');
  }}