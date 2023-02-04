import 'package:flutter/material.dart'; //이거는 근데 아이폰 전용 라이브러리야 이러면 어느화면이든 다 동작!

class WidgetTest extends StatefulWidget {
  const WidgetTest({Key? key}) : super(key: key);

  @override
  State<WidgetTest> createState() => _WidgetTestState();
}

class _WidgetTestState extends State<WidgetTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround, //해당 표의 main 방향 정렬
        crossAxisAlignment: CrossAxisAlignment.start, //해당 표의 cross 방향 정렬
        children: <Widget>[
          Container(width: 120, height: 56, child: TextField()),
          Container(
            margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Text(
              '원희 바보',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            color: Colors.black,
          ),
          Container(
            child: Text(
              '원희 바보',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            color: Colors.black,
          ),
          Container(
            child: Text(
              '원희 바보',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            color: Colors.black,
          ),
          Container(
            child: Text(
              '원희 바보',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            color: Colors.black,
          ),
          Container(
            child: Text(
              '원희 바보',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
