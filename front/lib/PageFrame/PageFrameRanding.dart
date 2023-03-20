import 'package:flutter/material.dart';
import 'package:front/dataSets/dataSetColors.dart';
import '../dataSets/dataSetTextStyles.dart';

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
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('V-MAP', style: TextStyle(fontSize: 30)),
            SizedBox(width: 80),
            Container(
              width: 200, height: 75,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.green]
                  )
              ),
              child: TextButton(onPressed: () {}, child: Text('About', style: TextStyle(fontSize: 20)),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(300, 75),),
              ),
            ),
            TextButton(onPressed: () {}, child: Text('Team', style: TextStyle(fontSize: 20)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(200, 75)
                )),
            Expanded(child: Container()),
            TextButton(onPressed: () {}, child: Text('Sign In/Sign Up', style: TextStyle(fontSize: 20)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(300, 75)
                )),

          ],
        ),

        leading: IconButton(icon: Icon(Icons.computer), onPressed: () {}),


      ),



    );
  }
}
