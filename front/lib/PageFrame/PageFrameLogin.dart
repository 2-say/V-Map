import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/dataSets/dataSetColors.dart';
import '../dataSets/dataSetTextStyles.dart';

class PageFrameLogin extends StatefulWidget {
  const PageFrameLogin({Key? key}) : super(key: key);

  @override
  State<PageFrameLogin> createState() => _PageFrameLoginState();
}

class _PageFrameLoginState extends State<PageFrameLogin> {
  //dataSet


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
            TextButton(onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PageFrameRanding()));
            }, child: Text('about', style: TextStyle(fontSize: 20)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(200, 75)
                )),
            TextButton(onPressed: () {}, child: Text('Team', style: TextStyle(fontSize: 20)),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(200, 75)
                )),
            Expanded(child: Container()),
            Container(
              width: 300, height: 75,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.green]
                  )
              ),
              child: TextButton(onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => PageFrameLogin()));
              }, child: Text('Sign In/Sign Up', style: TextStyle(fontSize: 20)),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(300, 75),),
              ),
            )

          ],
        ),

        leading: IconButton(icon: Icon(Icons.computer), onPressed: () {}),


      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.green]
            )
        ),
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 450, height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), topLeft: Radius.circular(30)),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Text('Welcome!', style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold,),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 50),
                      Icon(Icons.emoji_emotions, size: 300,color: Colors.lightGreen,),

                    ],),),

                Container(
                  width: 450, height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text('Login', style: TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w900,),
                      ),
                      SizedBox(height: 50),

                      Text('USERNAME', style: TextStyle(
                        fontWeight: FontWeight.w500),
                      ),
                     TextField(decoration: InputDecoration(border: OutlineInputBorder(),)),
                      SizedBox(height: 30),
                      Text('PASSWORD', style: TextStyle(
                        fontWeight: FontWeight.w500),
                      ),
                      TextField(decoration: InputDecoration(border: OutlineInputBorder(),)),

                      SizedBox(height: 30),
                      Container(
                        width: 450, height: 75,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.lightGreen, Colors.green]
                            )
                        ),
                        child: TextButton(onPressed: () {}, child: Text('Lets Go!', style: TextStyle(fontSize: 30)),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            minimumSize: Size(300, 50),),
                        ),
                      ),
                      Text('Forgot your password', style: TextStyle(fontSize: 15)),
                      Text('Not a member yet?', style: TextStyle(fontSize: 15)),
                      TextButton(onPressed: () {}, child: Text('Sign uip with Google'), style: TextButton.styleFrom(
                        primary: Colors.grey,
                      ),)
                    ],),),
              ],
            )),
      ),







    );
  }
}
