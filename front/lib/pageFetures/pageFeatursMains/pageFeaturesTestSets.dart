import 'package:flutter/material.dart';

import '../../firestore/firebaseController.dart';

class PageFeaturesTestSets extends StatefulWidget {
  const PageFeaturesTestSets({Key? key}) : super(key: key);

  @override
  State<PageFeaturesTestSets> createState() => _PageFeaturesTestSetsState();
}

class _PageFeaturesTestSetsState extends State<PageFeaturesTestSets> {
  TextEditingController controllerUserName = TextEditingController();
  String inputTextUserName = '';
  TextEditingController controllerEmail = TextEditingController();
  String inputTextEmail = '';
  TextEditingController controllerToken = TextEditingController();
  String inputTextToken = '';
  TextEditingController controllerDbId = TextEditingController();
  String inputTextDbId = '';
  TextEditingController controllerPageId = TextEditingController();
  String inputTextPageId = '';
  TextEditingController controllerEmail2 = TextEditingController();
  String inputTextEmail2 = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.grey),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        Container(
          padding: const EdgeInsets.all(12),
          width: 320,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              TextField(
                  decoration: const InputDecoration(labelText: 'userName'),
                  controller: controllerUserName,
                  onChanged: (text) {
                    setState(() {
                      inputTextUserName = text;
                    });
                  }),
              TextField(
                  decoration: const InputDecoration(labelText: 'email'),
                  controller: controllerEmail,
                  onChanged: (text) {
                    setState(() {
                      inputTextEmail = text;
                    });
                  }),
            ],
          ),
        ),
        TextButton(
            onPressed: () {
              FirebaseController().addUser(inputTextUserName, inputTextEmail);
            },
            child:
                const Text('학생 추가 테스트', style: TextStyle(color: Colors.white))),
        Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
                width: double.infinity,
                height: 1,
                decoration: const BoxDecoration(color: Colors.black))),
        Container(
          padding: const EdgeInsets.all(12),
          width: 320,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              TextField(
                  decoration: const InputDecoration(labelText: '대상 email'),
                  controller: controllerEmail2,
                  onChanged: (text) {
                    setState(() {
                      inputTextEmail2 = text;
                    });
                  }),
              TextField(
                  decoration: const InputDecoration(labelText: '토큰'),
                  controller: controllerToken,
                  onChanged: (text) {
                    setState(() {
                      inputTextToken = text;
                    });
                  }),
              TextField(
                  decoration: const InputDecoration(labelText: 'DbId'),
                  controller: controllerDbId,
                  onChanged: (text) {
                    setState(() {
                      inputTextDbId = text;
                    });
                  }),
              TextField(
                  decoration: const InputDecoration(labelText: 'pageId'),
                  controller: controllerPageId,
                  onChanged: (text) {
                    setState(() {
                      inputTextPageId = text;
                    });
                  }),
            ],
          ),
        ),
        TextButton(
            onPressed: () {
              FirebaseController().updateUser(inputTextEmail2,
                  inputTextToken, inputTextDbId, inputTextPageId);
            },
            child:
                const Text('학생 정보 업데이트', style: TextStyle(color: Colors.white)))
      ]),
    );
  }
}
