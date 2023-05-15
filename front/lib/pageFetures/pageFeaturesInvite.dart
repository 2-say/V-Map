import 'package:flutter/material.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/testFeatures/requsestOpenMeeting.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/widgetCommonAppbar.dart';

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
                Container(
                    //크기 정의 먼저
                    width: double.infinity,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('초대코드',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16, fontFamily: 'apeb')),
                        Text(widget.meetingInfo!['zoomUrlClerk'],
                            style: TextStyle(fontSize: 16, fontFamily: 'apm'))
                      ],
                    )),
                Container(
                    //크기 정의 먼저
                    width: double.infinity,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('초대코드',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16, fontFamily: 'apeb')),
                        Text(widget.meetingInfo!['zoomUrlEtc'],
                            style: TextStyle(fontSize: 16, fontFamily: 'apm'))
                      ],
                    )),
                Container(
                    //크기 정의 먼저
                    width: double.infinity,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('초대코드',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16, fontFamily: 'apeb')),
                        Text(widget.meetingInfo!['password'],
                            style: TextStyle(fontSize: 16, fontFamily: 'apm'))
                      ],
                    )),
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
                        FeaturesMeeting()
                            .postNotion(widget.myUserInfo!['id'],
                                widget.meetingInfo!['meetingName'], dummyUsers)
                            .then((value) => print(value));
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
