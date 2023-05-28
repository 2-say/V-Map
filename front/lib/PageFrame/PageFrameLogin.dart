import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/dataSets/dataSetColors.dart';
import 'package:front/firestore/firebaseController.dart';
import '../dataSets/dataSetTextStyles.dart';
import '../pageFetures/pageFeatursMains/pageFeaturesMain.dart';
import '../widgets/widgetCommonAppbar.dart';

class PageFrameLogin extends StatefulWidget {
  const PageFrameLogin({Key? key}) : super(key: key);

  @override
  State<PageFrameLogin> createState() => _PageFrameLoginState();
}

class _PageFrameLoginState extends State<PageFrameLogin> {
  bool pwLook = true;
  String inputEmail = '';
  String inputPw = '';

  //dataSet

  @override
  void initState() {
    //이 함수가 실행 되어야 위젯 변수들의 초기화가 완료됨.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle title = TextStyle(fontFamily: 'apeb', fontSize: 24, color: crKeyColorB1F);
    TextStyle button = TextStyle(fontFamily: 'apeb', fontSize: 24, color: Colors.white);
    TextStyle b1 = TextStyle(fontFamily: 'apl', fontSize: 16, color: crKeyColorB1F);
    TextStyle b2 = TextStyle(fontFamily: 'apl', fontSize: 14, color: crKeyColorB1F);
    return Scaffold(
      //전체를 감싸는 컨테이너, 배경색을 담당
      appBar: WidgetCommonAppbar(appBar: AppBar(), currentPage: 'about', loginState: false),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [crKeyColorB1, crKeyColorB1L])),
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 400,
              decoration: BoxDecoration(
                  border: Border.all(color: crKeyColorB1L, width: 1),
                  color: crKeyColorB1,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text('환영합니다.', style: title),
                    const SizedBox(height: 32),
                    Text('아이디', style: b1),
                    const SizedBox(height: 4),
                    TextField(
                        autofocus: true,
                        style: TextStyle(color: crKeyColorB1F, fontFamily: 'seqm'),
                        onChanged: (val) {
                          setState(() {
                            inputEmail = val;
                          });
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: crKeyColorB1F, width: 1)),
                            focusedBorder:
                                const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)))),
                    const SizedBox(height: 24),
                    Text('비밀번호', style: b1),
                    const SizedBox(height: 4),
                    TextField(
                        onSubmitted: (val) async {
                          await FirebaseController().loginUser(inputEmail, inputPw).then((value) {
                            if (value == null) {
                            } else {
                              print(value);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) => PageFeatureMain(myUserInfo: value)));
                            }
                          });
                        },
                        style: TextStyle(color: crKeyColorB1F, fontFamily: 'seqm'),
                        onChanged: (val) {
                          setState(() {
                            inputPw = val;
                          });
                        },
                        obscureText: pwLook,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: crKeyColorB1F, width: 1)),
                          focusedBorder:
                              const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pwLook = !pwLook;
                                });
                              },
                              icon: Icon(pwLook == true ? Icons.visibility_off : Icons.visibility)),
                          border: OutlineInputBorder(),
                        )),
                    const SizedBox(height: 24),
                    Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(color: ccKeyColorGreen, borderRadius: BorderRadius.circular(8)),
                        child: TextButton(
                            onPressed: () async {
                              await FirebaseController().loginUser(inputEmail, inputPw).then((value) {
                                if (value == null) {
                                } else {
                                  print(value);
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (_) => PageFeatureMain(myUserInfo: value)));
                                }
                              });
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              minimumSize: Size(300, 50),
                            ),
                            child: Text('로그인', style: button))),
                    const SizedBox(height: 16),
                    TextButton(
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () {},
                      child: Text('아직 회원이 아니신가요?', style: b2),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
