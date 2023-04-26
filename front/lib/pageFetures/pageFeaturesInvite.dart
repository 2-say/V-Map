import 'package:flutter/material.dart';
import 'package:front/pageFetures/pageFeaturesMain.dart';
import 'package:front/pageFetures/pageFeaturesInvitation.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';

class PageFeatureInvite extends StatelessWidget {
  const PageFeatureInvite({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
       child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [

              Container(
                  width: double.maxFinite,
                  child: Text('WelCome OOO!', textAlign: TextAlign.start, style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold))),
              SizedBox(height: 200),
              Container(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Container( //하나의 참여자 동그라미 형태
                         child: Column( children: [
                           Container(//동그라미
                             height: 200, width: 200,
                             alignment: Alignment.center,
                             decoration: BoxDecoration( color: Colors.grey, shape: BoxShape.circle),
                             child: Text('SH', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
                           ),
                           Container(//밑의 이름
                               child: Container(
                                 height: 50, width: 200,
                                 alignment: Alignment.center,
                                 child: Text('이세희', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                               )),
                         ],)
                       ),
                    Container( //하나의 참여자 동그라미 형태
                        child: Column( children: [
                          Container(//동그라미
                            height: 200, width: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration( color: Colors.grey, shape: BoxShape.circle),
                            child: Text('WH', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
                          ),
                          Container(//밑의 이름
                              child: Container(
                                height: 50, width: 200,
                                alignment: Alignment.center,
                                child: Text('조원희', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                              )),
                        ],)
                    ),
                      Container( //하나의 참여자 동그라미 형태
                          child: Column( children: [
                            Container(//동그라미
                              height: 200, width: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration( color: Colors.grey, shape: BoxShape.circle),
                              child: Text('JK', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
                            ),
                            Container(//밑의 이름
                                child: Container(
                                  height: 50, width: 200,
                                  alignment: Alignment.center,
                                  child: Text('임재경', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                                )),
                          ],)
                      ),
                      Container( //하나의 참여자 동그라미 형태
                          child: Column( children: [
                            Container(//동그라미
                              height: 200, width: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration( color: Colors.grey, shape: BoxShape.circle),
                              child: Text('SH', style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
                            ),
                            Container(//밑의 이름
                                child: Container(
                                  height: 50, width: 200,
                                  alignment: Alignment.center,
                                  child: Text('이상현', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                                )),
                          ],)
                      ),


                  ],)
              ),
            SizedBox(height: 100),
            Container(
              decoration: BoxDecoration(
                 color: Colors.grey,borderRadius: BorderRadius.circular(50),
              ),
              width: 1000, height: 350,
              child: Column (
                children: [
                  SizedBox(height: 15),
                  Container(
                    width: 900,
                    child: Text('Invite Code',textAlign: TextAlign.start, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 100),
                  Text('23rjkewhfjkh2349fwefk', style: TextStyle(fontSize: 50 ))
                ],)),
            Container(
              width: double.maxFinite,
              child: TextButton( onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => PageFeatureInvitation()));
              }, child: Text('Has another team member already set up a meeting?', textAlign: TextAlign.end, style: TextStyle(fontSize: 20, color: Colors.green, ))  )
            ),
            SizedBox(height: 40),
            Container(
              width: 600, height: 75,
              decoration: BoxDecoration(
                   color: Colors.grey,borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.indigo, Colors.green]
                  )
              ),
              child: TextButton(onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => PageFeatureMain()));
              }, child: Text('Start Meeting', style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold))),
            )

          ])
    ));
  }
}
