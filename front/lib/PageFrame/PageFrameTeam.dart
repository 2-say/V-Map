import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/dataSets/dataSetColors.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';
import '../dataSets/dataSetTextStyles.dart';
import '../widgets/widgetCommonAppbar.dart';

class PageFrameTeam extends StatelessWidget {
  PageFrameTeam({Key? key}) : super(key: key);

  //dataSet
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //dateset-------------------------------------------------------------------
    String intro1 = 'Lab329';
    String intro2 = '한국기술교육대학교 컴퓨터공학부';
    String intro3 = '4명의 18학번 컴퓨터공학부원이 모여 제작된 프로젝트입니다.';
    TextStyle eh1 =
        const TextStyle(fontFamily: 'seqbl', fontSize: 48, color: Colors.white);
    TextStyle b1 =
        const TextStyle(fontFamily: 'apm', fontSize: 16, color: Colors.black);
    TextStyle b2 =
    const TextStyle(fontFamily: 'apm', fontSize: 13, color: Colors.black);
    //declare ui----------------------------------------------------------------
    return Scaffold(
        appBar: WidgetCommonAppbar(
            appBar: AppBar(), currentPage: 'team', loginState: true),
        body: Center(
            child: Column(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [ccKeyColorGreen, ccKeyColorCyan],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight)),
              alignment: Alignment.center,
              width: double.infinity,
              height: 280,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(intro1, style: eh1),
                    Text(intro2, style: b2),
                    const SizedBox(height: 16),
                    Text(intro3, style: b1)
                  ])),
        ])));
  }
}
