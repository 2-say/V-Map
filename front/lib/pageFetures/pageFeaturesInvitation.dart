import 'package:flutter/material.dart';
import 'package:front/pageFetures/pageFeaturesMain.dart';
import 'package:front/pageFetures/pageFeaturesInvite.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';

class PageFeatureInvitation extends StatelessWidget {
  const PageFeatureInvitation({Key? key}) : super(key: key);


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
                      child: Text('Join the Meeting',textAlign: TextAlign.start, style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold))),
                  SizedBox(height: 200),
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
                          Container(
                              width: 600,
                              decoration: BoxDecoration(color: Colors.white),
                              child: TextField( decoration:
                                InputDecoration( labelText: 'Input Code'), )),

                          ])),
                  Container(
                      width: double.maxFinite,
                      child: TextButton( onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => PageFeatureInvite()));
                      }, child: Text('you can made meeting!!', textAlign: TextAlign.end, style: TextStyle(fontSize: 20, color: Colors.green, ))  )
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
                    }, child: Text('Join', style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold))),
                  )

                ])
        ));
  }
}
