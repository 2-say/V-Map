import 'package:flutter/material.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';
import 'package:front/pageFetures/pageFeaturesInvitation.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/testFeatures/requsestOpenMeeting.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgetCommonAppbar.dart';

class PageFeatureInvite extends StatefulWidget {
  const PageFeatureInvite({Key? key,required this.myUserInfo,required this.meetingName,required this.meetingCode}) : super(key: key);
  final String meetingName;
  final Map<String, dynamic>? myUserInfo;
  final String meetingCode;


  @override
  State<PageFeatureInvite> createState() => _PageFeatureInviteState();
}

class _PageFeatureInviteState extends State<PageFeatureInvite> {
  final List<String> dummyUsers = ['이세희', '조원희', '임재경', '이상현'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetCommonAppbar(appBar: AppBar(), currentPage: 'meeting',loginState:true),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('반갑습니다. ${widget.myUserInfo!['userName']}님!',
                    style: TextStyle(fontSize: 48, fontFamily: 'apeb')),
                Text('회의명. ${widget.meetingName}',
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
                Container(
                  //크기 정의 먼저
                    width: double.infinity,
                    height: 124,
                    // 그 다음 정렬 여부 , padding or margin
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                    // 그 다음 deco
                    decoration: BoxDecoration(
                      //deco는 색 - 나머지 순으로
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    // 기초 정의가 끝나면 child 정의
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('회의방 url (서기용)',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 24, fontFamily: 'apeb')),
                        const Text('회의방 url (참여자용)',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 24, fontFamily: 'apeb')),
                        const Text('초대코드',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 24, fontFamily: 'apeb')),
                        Text(widget.meetingCode,
                            style: TextStyle(fontSize: 24, fontFamily: 'apm'))
                      ],
                    )),
                Container(
                    width: double.infinity,
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PageFeatureInvitation()));
                        },
                        child: const Text('이미 개설된 회의방 참가를 원하시나요?',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            )))),
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
                        FeaturesMeeting().postNotion(widget.myUserInfo!['id'], widget.meetingName, dummyUsers).then((value) => print(value));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => PageFeatureRecord()));
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
