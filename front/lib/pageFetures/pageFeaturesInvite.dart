import 'dart:io';

import 'package:flutter/material.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/testFeatures/requsestOpenMeeting.dart';
import 'package:url_launcher/url_launcher.dart';
import '../dataSets/dataSetColors.dart';
import '../dataSets/dataSetTextStyles.dart';
import '../testFeatures/NoCheckCertificateHttpOverrides.dart';
import '../widgets/widgetCommonAppbar.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class ZoomMeetingCreator {
  final apiKey = 'ru1ye_lgTMWHIiPiY6G7SQ';
  final apiSecret = 'c0hcgeYFsHjNNJ0DOG2EvbKOtQGOqxVrDHXN';
  String? startUrl;
  String? joinUrl;
  late int meetingId = 0;

  Future<Map<String, dynamic?>> createZoomMeeting() async {
    final payload = {
      'iss': apiKey,
      'exp': DateTime.now()
              .toUtc()
              .add(Duration(hours: 2))
              .millisecondsSinceEpoch ~/
          1000,
    };

    final base64UrlHeader = base64Url
        .encode(utf8.encode(json.encode({'alg': 'HS256', 'typ': 'JWT'})));
    final base64UrlPayload =
        base64Url.encode(utf8.encode(json.encode(payload)));
    final signingInput = '$base64UrlHeader.$base64UrlPayload';
    final hmacSha256 = Hmac(sha256, utf8.encode(apiSecret));
    final base64UrlSignature =
        base64Url.encode(hmacSha256.convert(utf8.encode(signingInput)).bytes);
    final token = '$signingInput.$base64UrlSignature';

    final url = 'https://api.zoom.us/v2/users/me/meetings';
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

    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(data));

    if (response.statusCode == 201) {
      print("******************successe**********************");
      final responseData = await json.decode(response.body);
      startUrl = responseData['start_url'];
      joinUrl = responseData['join_url'];
      meetingId = responseData['id'];

      final startTimeString = responseData['start_time'];
      final startTime = DateTime.parse(startTimeString);
      // final duration = int.parse(data['duration'].toString());

      print('Start URL: $startUrl');
      print('Join URL: $joinUrl');
      print('Start Time: $startTime');
      print('meeting ID: $meetingId');

      return {
        'startUrl': startUrl,
        'joinUrl': joinUrl,
        'meetingId': meetingId,
      };
    } else {
      print(
          'Failed to create Zoom meeting. Status code: ${response.statusCode}');
      return {
        'startUrl': null,
        'joinUrl': null,
        'meetingId': null,
      };
    }
  }
}

class PageFeatureInvite extends StatefulWidget {
  const PageFeatureInvite({
    Key? key,
    required this.myUserInfo,
    required this.meetingInfo,
  }) : super(key: key);
  final Map<String, dynamic>? myUserInfo;
  final Map<String, dynamic>? meetingInfo;

  @override
  State<PageFeatureInvite> createState() => _PageFeatureInviteState();
}

class _PageFeatureInviteState extends State<PageFeatureInvite> {
  final List<String> dummyUsers = ['이세희', '조원희', '임재경', '이상현'];
  late int zoomInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetCommonAppbar(
            appBar: AppBar(), currentPage: 'meeting', loginState: true),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('반갑습니다. ${widget.myUserInfo!['userName']}님!',
                    style: TextStyle(fontSize: 48, fontFamily: 'apeb')),
                Text('회의명. ${widget.meetingInfo!['meetingName']}',
                    style: TextStyle(fontSize: 48, fontFamily: 'apeb')),
                const SizedBox(height: 8),
                const Expanded(child: SizedBox()),
                Column(children: [
                  const Text('접속 목록',
                      style: TextStyle(fontSize: 20, fontFamily: 'apeb')),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List<Widget>.generate(
                          4,
                          (index) =>
                              WidgetCircleAvatar(userName: dummyUsers[index]))),
                ]),
                const SizedBox(height: 8),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    height: 68,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await ZoomMeetingCreator()
                            .createZoomMeeting()
                            .then((value) => zoomInfo = value['meetingId']);
                        print('meeting ID: ${zoomInfo}');
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Text(
                        'Zoom 회의 방 개설',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: WidgetCardRedirectionCode(
                            code: widget.meetingInfo!['zoomUrlClerk'],
                            boardType: '줌 바로가기 ( 서기용 )'),
                      ),
                      Expanded(
                        child: WidgetCardRedirectionCode(
                            code: widget.meetingInfo!['zoomUrlEtc'],
                            boardType: '줌 바로가기 ( 일반 참가자 )'),
                      )
                    ]),
                WidgetCardRedirectionCode(
                    code: widget.meetingInfo!['password'],
                    boardType: '회의 초대코드'),
                SizedBox(height: 24),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 75,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.indigo, Colors.green])),
                  child: TextButton(
                      onPressed: () {
                        print('check :zoomInfo-$zoomInfo');
                        HttpOverrides.global =
                            NoCheckCertificateHttpOverrides();
                        FeaturesMeeting()
                            .postNotion(widget.myUserInfo!['id'],
                                widget.meetingInfo!['meetingName'], dummyUsers)
                            .then((value) => print(value));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PageFeatureRecord(
                                    meetingInfo: widget.meetingInfo,
                                    userInfo: widget.myUserInfo,
                                    meetingId:
                                        zoomInfo)));
                      },
                      child: const Text('Start Meeting!',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))),
                )
              ]),
        ));
  }
}

class WidgetCircleAvatar extends StatelessWidget {
  WidgetCircleAvatar({
    Key? key,
    required this.userName,
  }) : super(key: key);
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(userName[0],
              style: const TextStyle(
                  fontFamily: 'apeb', fontSize: 16, color: Colors.white)),
        ),
        Text(
          userName,
          style: const TextStyle(fontFamily: 'apm', fontSize: 24),
        )
      ],
    );
  }
}

class WidgetCardRedirectionCode extends StatelessWidget {
  const WidgetCardRedirectionCode(
      {Key? key, required this.boardType, required this.code})
      : super(key: key);
  final String boardType;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
        //크기 정의 먼저
        height: 68,
        // 그 다음 정렬 여부 , padding or margin
        alignment: Alignment.center,
        // 그 다음 deco
        decoration: BoxDecoration(
          //deco는 색 - 나머지 순으로
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(24),
        ),
        // 기초 정의가 끝나면 child 정의
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(boardType,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontFamily: 'apeb')),
          TextButton(
              onPressed: () async {
                final url = Uri.parse(code);
                if (await canLaunch(url.toString())) {
                  await launch(url.toString(), forceSafariVC: false);
                }
              },
              child: const Text('바로가기',
                  style: TextStyle(
                      fontFamily: 'apeb',
                      fontSize: 16,
                      color: Colors.blueAccent)))
        ]));
  }
}
