import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front/dataSets/dataSetColors.dart';

import '../../firestore/firebaseController.dart';

class PageFeaturesMainForm extends StatefulWidget {
  const PageFeaturesMainForm({Key? key, required this.myUserInfo}) : super(key: key);
  final Map<String, dynamic>? myUserInfo;

  @override
  State<PageFeaturesMainForm> createState() => _PageFeaturesMainFormState();
}

class _PageFeaturesMainFormState extends State<PageFeaturesMainForm> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamMeetingPrev;
  late Stream<QuerySnapshot<Map<String, dynamic>>> streamMeetings;

  @override
  void initState() {
    streamMeetingPrev = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: widget.myUserInfo!['email'])
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: streamMeetingPrev,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic>? docs = snapshot.data?.docs.first.data();
            if(docs!['prevMeeting'].length!=0){
              return Column(children: List<Widget>.generate(docs!['prevMeeting'].length, (index) {
                streamMeetings = FirebaseFirestore.instance
                    .collection('meetings')
                    .where('password', isEqualTo: widget.myUserInfo!['id'])
                    .snapshots();
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: streamMeetingPrev,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        Map<String, dynamic>? docs = snapshot.data?.docs.first.data();
                        if(docs!['prevMeeting'].length!=0){
                          return Column(children: List<Widget>.generate(docs!['prevMeeting'].length, (index) {
                            return Container();
                          }));
                        }
                        else {
                          return Text('error');
                        }
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                        // 기타 경우 ( 불러오는 중 )
                      } else {
                        return const CircularProgressIndicator();
                      }
                    });
              }));
            }
            else {
              return Text('error');
            }
          } else if (snapshot.hasError) {
            return const Text('Error');
            // 기타 경우 ( 불러오는 중 )
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
