// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
//
// class ZoomMeetingCreator{
//
//   final apiKey = 'ru1ye_lgTMWHIiPiY6G7SQ';
//   final apiSecret = 'c0hcgeYFsHjNNJ0DOG2EvbKOtQGOqxVrDHXN';
//   String? startUrl;
//   String? joinUrl;
//   int? meetingId;
//
//   Future<void> createZoomMeeting() async {
//
//     // JWT 토큰 생성
//     final payload = {
//       'iss': apiKey,
//       'exp': DateTime.now().toUtc().add(Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
//     };
// aaaaaaaaaaaaaa
//     final base64UrlHeader = base64Url.encode(utf8.encode(json.encode({'alg': 'HS256', 'typ': 'JWT'})));
//     final base64UrlPayload = base64Url.encode(utf8.encode(json.encode(payload)));
//     final signingInput = '$base64UrlHeader.$base64UrlPayload';
//     final hmacSha256 = Hmac(sha256, utf8.encode(apiSecret));
//     final base64UrlSignature = base64Url.encode(hmacSha256.convert(utf8.encode(signingInput)).bytes);
//     final token = '$signingInput.$base64UrlSignature';
//
//     // Zoom API를 이용한 회의 생성
//     final url = 'https://api.zoom.us/v2/users/me/meetings';
//
//     final headers = {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     };
//
//     final data = {
//       'topic': 'Zoom Meeting',
//       'type': 2,
//       'start_time': '2023-05-03T13:00:00Z',
//       'duration': 60,
//       'timezone': 'Asia/Seoul',
//       'agenda': 'This is a test meeting'
//     };
//
//     final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(data));
//
//     if (response.statusCode == 201) {
//       final responseData = json.decode(response.body);
//       startUrl = responseData['start_url'];
//       joinUrl = responseData['join_url'];
//       meetingId = responseData['id'];
//
//       final startTimeString = responseData['start_time'];
//       final startTime = DateTime.parse(startTimeString);
//       final duration = int.parse(data['duration'].toString());
//
//
//       print('Start URL: $startUrl');
//       print('Join URL: $joinUrl');
//       print('Start Time: $startTime');
//     } else {
//       print('Failed to create Zoom meeting. Status code: ${response.statusCode}');
//     }
//
//     // Return empty list if meeting creation or end fails
//   }
//
//
//
//   Future<void> endZoomMeeting(int FullmeetingId) async {
//     var url = Uri.parse('https://api.zoom.us/v2/meetings/$FullmeetingId/status');
//
//     var headers = {
//       'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6InJ1MXllX2xnVE1XSElpUGlZNkc3U1EiLCJleHAiOjE3MDM4NjE5NDAsImlhdCI6MTY4NDk0MTU1Nn0.M03nmML-4E_UVC1AYPWX2e3gYIuzL7RlVTAjzF2vaa4',
//       'Content-Type': 'application/json'
//     };
//
//     var body = jsonEncode({
//       'action': 'end'
//     });
//
//     var response = await http.put(url, headers: headers, body: body);
//
//     if (response.statusCode == 204) {
//       print('Zoom meeting ended successfully.');
//     } else {
//       print('Failed to end Zoom meeting. Status code: ${response.statusCode}');
//     }
//   }
// }
//
//
//
