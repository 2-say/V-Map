import 'package:flutter/material.dart';
import 'package:front/dataSets/dataSetColors.dart';

import '../dataSets/dataSetTextStyles.dart';

class PageFeatureMain extends StatefulWidget {
  const PageFeatureMain({Key? key}) : super(key: key);

  @override
  State<PageFeatureMain> createState() => _PageFeatureMainState();
}

class _PageFeatureMainState extends State<PageFeatureMain> {
  //dataSet
  final List<String> statusCheckTitle = ['노션 연동', '스테레오 녹음', '마이크 녹음'];
  late bool isRecordOn;
  late List<bool> statusCheck;
  late int time;

  @override
  void initState() {
    //현재 녹음 여부 기본 false로 선언
    isRecordOn = false;
    //연동 , 스테레오 녹음 , 마이크 녹음 등의 체크를 false로 기본 선언
    statusCheck = List.filled(3, false);
    //현재 녹음 시간 0으로 선언
    time = 0;
    //이 함수가 실행 되어야 위젯 변수들의 초기화가 완료됨.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //전체를 감싸는 컨테이너, 배경색을 담당
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ccKeyColorGreen, ccKeyColorCyan],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        height: double.infinity,
        //자식들을 담을 column
        child: Column(
            //세로 정렬 : start( 시작점 부터 )
            mainAxisAlignment: MainAxisAlignment.start,
            //가로 정렬 : start ( 시작점 부터 )
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //row:현재 회의 상태 표시
              Row(
                  children: List<Widget>.generate(statusCheck.length, (index) {
                return Container(
                    width: index == 1
                        ? 180
                        : index == 2
                            ? 160
                            : 150,
                    child: ListTile(
                      horizontalTitleGap: 0,
                      onTap: () {
                        print(statusCheck[index]);
                      },
                      title: Text(statusCheckTitle[index], style: b1white),
                      trailing: Icon(
                          statusCheck[index] == true
                              ? Icons.check_box
                              : Icons.close,
                          color: statusCheck[index] == true
                              ? Colors.green
                              : Colors.redAccent),
                    ));
              })),
              //container:회의 기록중 여부
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("현재 V-MAP이 회의 내용을 노션에 기록 중 입니다.", style: h1)),
              Container(
                  height: 100,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Text(
                    "회의제목: 회의록 by V-MAP",
                    style: TextStyle(fontSize: 50),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "주요안건: 회의내용을 바탕으로 자동요약된 안건입니다.",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "AI-MAP 구현 가능성 평가",
                      ),
                      Icon(Icons.error),
                      Text("AI-MAP에서 필요한 기능"),
                      Icon(Icons.error),
                      Text("AI-MAP의 정확도 향상 방법 평가"),
                      Icon(Icons.error),
                      Text("아이디어 경진대회 포스터 피드백"),
                      Icon(Icons.error),
                    ],
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Text("회의내용: 회의 음성을 구분하여 텍스트화 한 내용입니다.")),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.square,
                        color: Colors.red,
                      ),
                      Text("발언자1",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text(
                          "지금부터 회의 시작하겠습니다. 오늘 회의주제는 공학 설계 아이디어 조사 내용 발표이며, 발표 이후에는 교수님의 피드백이 있을 예정입니다."),
                      Icon(
                        Icons.square,
                        color: Colors.blue,
                      ),
                      Text("발언자2", style: TextStyle(fontSize: 20)),
                      Text("발표 시작하겠습니다.\n저희팀의 주제는 음성인식 기반 회의록 자동 생성 프로그램입니다."),
                      Icon(
                        Icons.square,
                        color: Colors.blue,
                      ),
                      Text("발언자2", style: TextStyle(fontSize: 20)),
                      Text(
                          "우선 아이디어 조사 내용을발표하기에 앞서 저희 팀의 주제에 대한 간단한 소개를 하겠습니다."),
                      Container(
                        width: 1000,
                        height: 60,
                        color: Colors.red,
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      ),
                      Container(
                        width: 1000,
                        height: 80,
                        color: Colors.red,
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      )
                    ],
                  )),
            ]),
      ),
    );
  }
}
