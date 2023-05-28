import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front/firestore/firebaseController.dart';
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
      'exp': DateTime.now().toUtc().add(Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
    };

    final base64UrlHeader = base64Url.encode(utf8.encode(json.encode({'alg': 'HS256', 'typ': 'JWT'})));
    final base64UrlPayload = base64Url.encode(utf8.encode(json.encode(payload)));
    final signingInput = '$base64UrlHeader.$base64UrlPayload';
    final hmacSha256 = Hmac(sha256, utf8.encode(apiSecret));
    final base64UrlSignature = base64Url.encode(hmacSha256.convert(utf8.encode(signingInput)).bytes);
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

    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(data));

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
      print('Failed to create Zoom meeting. Status code: ${response.statusCode}');
      return {
        'startUrl': null,
        'joinUrl': null,
        'meetingId': null,
      };
    }
  }
}

class PageFeatureInviteCommon extends StatefulWidget {
  const PageFeatureInviteCommon({
    Key? key,
    required this.myUserInfo,
    required this.meetingInfo,
  }) : super(key: key);
  final Map<String, dynamic>? myUserInfo;
  final Map<String, dynamic>? meetingInfo;

  @override
  State<PageFeatureInviteCommon> createState() => _PageFeatureInviteCommonState();
}

class _PageFeatureInviteCommonState extends State<PageFeatureInviteCommon> {
  final List<String> dummyUsers = ['이세희', '조원희', '임재경', '이상현'];
  late int zoomInfo = 111;
  late String StartUrlInfo;
  late String JoinUrlInfo;
  bool ClickCheckOn = false;
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamConnectContents;

  @override
  void initState() {
    streamConnectContents = FirebaseFirestore.instance
        .collection('meetings')
        .where('password', isEqualTo: widget.meetingInfo!['password'])
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetCommonAppbar(appBar: AppBar(), currentPage: 'meeting', loginState: true),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [crKeyColorB1, crKeyColorB1L])),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: crKeyColorB1Menu,
                      borderRadius:
                          const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
                  child: Row(children: <Widget>[
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Text('${widget.meetingInfo!['meetingName']}', style: h1C),
                      Text(
                        '${widget.meetingInfo!['startTime']} · 참여자 ${widget.meetingInfo!['etc'].length}명',
                        style: const TextStyle(fontFamily: 'apb', color: Colors.grey),
                      )
                    ]),
                    Expanded(child: SizedBox()),
                    Text('초대코드 : ${widget.meetingInfo!['password']}', style: h1CM),
                  ]),
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: streamConnectContents,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            Map<String, dynamic>? docs = snapshot.data?.docs.first.data();
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List<Widget>.generate(
                                    docs?['etc'].length,
                                    (index) => WidgetCircleAvatar(
                                        userName: docs?['etc'][index]['userName'],
                                        isClerk: index == 0 ? true : false)));
                          } else if (snapshot.hasError) {
                            return const Text('Error');
                            // 기타 경우 ( 불러오는 중 )
                          } else {
                            return const CircularProgressIndicator();
                          }
                        })),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: 400,
                      decoration: BoxDecoration(
                          border: Border.all(color: crKeyColorB1L, width: 1),
                          color: crKeyColorB1,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: streamConnectContents,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data != null) {
                                    Map<String, dynamic>? docs = snapshot.data?.docs.first.data();
                                    return Column(children: <Widget>[
                                      Text('Zoom 회의방 바로가기 ( 참여자용 )',
                                          style: TextStyle(fontFamily: 'apeb', fontSize: 20, color: crKeyColorB1F)),
                                      docs!['zoomUrlClerk'] == ''
                                          ? const Text(
                                              '아직 개설되지 않았습니다.',
                                              style: TextStyle(color: Colors.white),
                                            )
                                          : TextButton(
                                              onPressed: () async {
                                                final url = Uri.parse(docs!['zoomUrlEtc']);
                                                if (await canLaunch(url.toString())) {
                                                  await launch(url.toString(), forceSafariVC: false);
                                                }
                                              },
                                              child: const Text('바로가기',
                                                  style: TextStyle(
                                                      fontFamily: 'apeb', fontSize: 16, color: Colors.blueAccent)))
                                    ]);
                                  } else if (snapshot.hasError) {
                                    return const Text('Error');
                                    // 기타 경우 ( 불러오는 중 )
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Colors.indigo, Colors.green])),
                                child: TextButton(
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => PageFeatureRecord(
                                                  meetingInfo: widget.meetingInfo,
                                                  userInfo: widget.myUserInfo,
                                                  meetingId: zoomInfo)));
                                    },
                                    child: const Text('Start Meeting!',
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ]),
        ));
  }
}

class WidgetCircleAvatar extends StatelessWidget {
  WidgetCircleAvatar({
    Key? key,
    required this.userName,
    required this.isClerk,
  }) : super(key: key);

  final String userName;
  final bool isClerk;

  @override
  Widget build(BuildContext context) {
    return isClerk == true
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4.0)),
                  height: 24,
                  width: 30,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: Text('서기', style: TextStyle(fontSize: 12, fontFamily: 'apeb', color: crKeyColorB1F)),
                  )),
              const SizedBox(width: 4.0),
              Text(
                userName,
                style: const TextStyle(fontFamily: 'apm', fontSize: 12, color: Colors.white),
              ),
              const SizedBox(width: 8.0)
            ],
          )
        : Row(
            children: <Widget>[
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blueAccent,
                child: Text(userName[0], style: const TextStyle(fontFamily: 'apeb', fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(width: 4.0),
              Text(
                userName,
                style: const TextStyle(fontFamily: 'apm', fontSize: 12, color: Colors.white),
              ),
              const SizedBox(width: 8.0)
            ],
          );
  }
}

class WidgetCardRedirectionCode extends StatelessWidget {
  const WidgetCardRedirectionCode({Key? key, required this.boardType, required this.code}) : super(key: key);
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
          Text(boardType, textAlign: TextAlign.start, style: TextStyle(fontSize: 16, fontFamily: 'apeb')),
          TextButton(
              onPressed: () async {
                final url = Uri.parse(code);
                if (await canLaunch(url.toString())) {
                  await launch(url.toString(), forceSafariVC: false);
                }
              },
              child: const Text('바로가기', style: TextStyle(fontFamily: 'apeb', fontSize: 16, color: Colors.blueAccent)))
        ]));
  }
}
