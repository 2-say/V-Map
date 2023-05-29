import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/dataSets/dataSetColors.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';
import '../dataSets/dataSetTextStyles.dart';
import '../widgets/widgetCommonAppbar.dart';

class PageFrameRanding extends StatelessWidget {
  PageFrameRanding({Key? key}) : super(key: key);

  //dataSet
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //dateset-------------------------------------------------------------------
    String intro1 = 'Do not record alone.';
    String intro2 =
        '이제 회의 내용을 작성하기 위해 힘쓸 필요가 없습니다. V-MAP을 이용해 자동으로 기록하고, 확인하세요.';
    String intro3 =
        '빌드버전 v1.1.15';
    TextStyle eh1 =
        const TextStyle(fontFamily: 'seqbl', fontSize: 48, color: Colors.black);
    TextStyle b1 =
        const TextStyle(fontFamily: 'apm', fontSize: 16, color: Colors.grey);
    TextStyle b2 =
    const TextStyle(fontFamily: 'apm', fontSize: 12, color: Colors.grey);
    //declare ui----------------------------------------------------------------
    return Scaffold(
        appBar: WidgetCommonAppbar(
            appBar: AppBar(), currentPage: 'about', loginState: false),
        body: Center(
            child: Column(children: <Widget>[
          Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 560,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(intro1, style: eh1),
                    const SizedBox(height: 24),
                    Text(intro2, style: b1),
                    Text(intro3, style: b2)
                  ])),
        ])));
  }
}
