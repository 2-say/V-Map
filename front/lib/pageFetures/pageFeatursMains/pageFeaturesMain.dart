import 'package:flutter/material.dart';
import 'package:front/dataSets/dataSetColors.dart';
import 'package:front/dataSets/dataSetTextStyles.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';
import 'package:front/pageFetures/pageFeaturesInvitation.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/widgetCommonAppbar.dart';
import '../pageFeaturesInvite.dart';

class PageFeatureMain extends StatefulWidget {
  const PageFeatureMain({Key? key}) : super(key: key);

  @override
  State<PageFeatureMain> createState() => _PageFeatureMainState();
}

class _PageFeatureMainState extends State<PageFeatureMain> {
  final List<String> dummyUsers = ['이세희', '조원희', '임재경', '이상현'];

  setterGoPageFeatureInvite() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const PageFeatureInvite()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: WidgetCommonAppbar(
            appBar: AppBar(), currentPage: 'meeting', loginState: true),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            WidgetFloatingButton(
                buttonTitle: '회의 참가', buttonIcon: Icons.compare_arrows),
            const SizedBox(height: 8),
            WidgetFloatingButton(
                buttonTitle: '회의 개설',
                buttonIcon: Icons.edit,
                setter: setterGoPageFeatureInvite)
          ],
        ),
        body: Row(
          children: <Widget>[
            const WidgetMenuBar(),
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(color: Colors.grey),
              ),
            )
          ],
        ));
  }
}

//플로팅 버튼
class WidgetFloatingButton extends StatelessWidget {
  WidgetFloatingButton(
      {Key? key,
      required this.buttonTitle,
      required this.buttonIcon,
      this.setter})
      : super(key: key);
  String buttonTitle;
  IconData buttonIcon;
  final setter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(buttonTitle, style: b1b),
        const SizedBox(width: 8),
        FloatingActionButton(
            onPressed: () {
              setter!();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [ccKeyColorGreen, ccKeyColorCyan])),
              child: Icon(buttonIcon, color: Colors.white),
            )),
      ],
    );
  }
}

class WidgetMenuBar extends StatefulWidget {
  const WidgetMenuBar({Key? key}) : super(key: key);

  @override
  State<WidgetMenuBar> createState() => _WidgetMenuBarState();
}

class _WidgetMenuBarState extends State<WidgetMenuBar> {
  TextStyle h1 =
      const TextStyle(fontFamily: 'apeb', fontSize: 18, color: Colors.black);
  TextStyle h2 =
      const TextStyle(fontFamily: 'apeb', fontSize: 16, color: Colors.grey);
  TextStyle h3 =
      const TextStyle(fontFamily: 'apm', fontSize: 14, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 196,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('내 워크스페이스', style: h1)),
              SizedBox(height: 12),
              Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(children: [
                    const CircleAvatar(backgroundColor: Colors.blueAccent),
                    Text('이세희', style: h3)
                  ])),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('계정', style: h2),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      backgroundColor: ccKeyColorBackground,
                      shadowColor: Colors.transparent),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('마이 페이지', style: h3),
                      const Expanded(child: SizedBox())
                    ],
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      backgroundColor: ccKeyColorBackground,
                      shadowColor: Colors.transparent),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('설정', style: h3),
                      const Expanded(child: SizedBox())
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  color: Colors.grey,
                  width: double.infinity,
                  height: 0.5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('회의', style: h2),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      backgroundColor: ccKeyColorBackground,
                      shadowColor: Colors.transparent),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('회의록', style: h3),
                      const Expanded(child: SizedBox())
                    ],
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      backgroundColor: ccKeyColorBackground,
                      shadowColor: Colors.transparent),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('공유된 회의록', style: h3),
                      const Expanded(child: SizedBox())
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  color: Colors.grey,
                  width: double.infinity,
                  height: 0.5),
              const Expanded(child: SizedBox()),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  color: Colors.grey,
                  width: double.infinity,
                  height: 0.5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('연동 상태', style: h2),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      backgroundColor: ccKeyColorBackground,
                      shadowColor: Colors.transparent),
                  onPressed: () {},
                  child: Row(
                    children: <Widget>[
                      Text('Zoom 연동', style: h3),
                      const SizedBox(width: 4),
                      const Icon(Icons.circle, size: 12, color: Colors.green),
                      const Expanded(child: SizedBox()),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16)
                    ],
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                      backgroundColor: ccKeyColorBackground,
                      shadowColor: Colors.transparent),
                  onPressed: () {},
                  child: Row(
                    children: <Widget>[
                      Text('Notion 연동', style: h3),
                      const SizedBox(width: 4),
                      const Icon(Icons.circle, size: 12, color: Colors.green),
                      const Expanded(child: SizedBox()),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16)
                    ],
                  )),
              SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8)),
                width: double.infinity,
                height: 24,
                alignment: Alignment.center,
                child: Text(
                  '녹음 가능합니다.',
                  style: h3,
                ),
              )
            ]),
      ),
    );
  }
}
