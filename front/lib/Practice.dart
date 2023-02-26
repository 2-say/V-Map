import 'package:flutter/material.dart';

void main() {
  runApp(const UIPractice());
}

class UIPractice extends StatelessWidget {
  const UIPractice({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              width: double.infinity, height: 40,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
              ),

              child: Text(
                  '노션연동 스테레오녹음 마이크녹음',
                style: TextStyle(fontSize: 12, color: Colors.green),
              )

            ),

            Container(
              width: double.infinity, height: 70,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
              ),

              child: Row(
                children: [
                  Icon(Icons.star),
                  Text(
                      "현재 V-MAP이 회의 내용을 노션에 기록 중 입니다.",
                      style: TextStyle(fontSize: 40),
                    ),
                ],
              )
              ),

            Container(
              width: double.infinity, height: 100,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: Text(
                "회의제목: 회의록 by V-MAP",
                style: TextStyle(fontSize: 50),
              )
            ),

            Container(
              width: double.infinity, height: 250,
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
                    "AI-MAP 구현 가능성 평가"
                  ),
                  Icon(Icons.error),

                  Text(
                      "AI-MAP에서 필요한 기능"
                  ),
                  Icon(Icons.error),

                  Text(
                      "AI-MAP의 정확도 향상 방법 평가"
                  ),
                  Icon(Icons.error),

                  Text(
                      "아이디어 경진대회 포스터 피드백"
                  ),
                  Icon(Icons.error),
                ],
              )
            ),

            Container(
              width: double.infinity, height: 80,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: Text(
                "회의내용: 회의 음성을 구분하여 텍스트화 한 내용입니다."
              )
            ),

            Container(
              width: double.infinity, height: 400,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.square, color: Colors.red,),
                  Text("발언자1", style: TextStyle(fontSize: 20,)),
                  Text("지금부터 회의 시작하겠습니다. 오늘 회의주제는 공학 설계 아이디어 조사 내용 발표이며, 발표 이후에는 교수님의 피드백이 있을 예정입니다."),

                  Icon(Icons.square, color: Colors.blue,),
                  Text("발언자2", style: TextStyle(fontSize: 20)),
                  Text("발표 시작하겠습니다.\n저희팀의 주제는 음성인식 기반 회의록 자동 생성 프로그램입니다."),

                  Icon(Icons.square, color: Colors.blue,),
                  Text("발언자2", style: TextStyle(fontSize: 20)),
                  Text("우선 아이디어 조사 내용을발표하기에 앞서 저희 팀의 주제에 대한 간단한 소개를 하겠습니다."),

                  Container(
                    width: 1000, height: 60, color: Colors.red,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  ),
                  Container(
                    width: 1000, height: 80, color: Colors.red,
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  )

                ],
              )

            ),

          ]

        ),
      )
    );
  }
}