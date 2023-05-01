import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/dataSets/dataSetColors.dart';
import 'package:front/pageFetures/pageFeaturesMain.dart';
import '../dataSets/dataSetTextStyles.dart';
import '../widgets/widgetCommonAppbar.dart';

class PageFrameRanding extends StatefulWidget {
  const PageFrameRanding({Key? key}) : super(key: key);

  @override
  State<PageFrameRanding> createState() => _PageFrameRandingState();
}

class _PageFrameRandingState extends State<PageFrameRanding> {
  //dataSet
  final scrollController = ScrollController();

  @override
  void initState() {
    //이 함수가 실행 되어야 위젯 변수들의 초기화가 완료됨.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //전체를 감싸는 컨테이너, 배경색을 담당
        appBar: WidgetCommonAppbar(
            appBar: AppBar(), currentPage: 'about', loginState: true),
        body: Container(
          width: double.infinity,
          height: 1000,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Do Not Recode Alone',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                child: Text("Go to Main"),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PageFeatureMain()));
                },
              ),
            ],
          ),
        ));
  }
}
