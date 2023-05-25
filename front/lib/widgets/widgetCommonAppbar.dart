import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';

import '../PageFrame/PageFrameRanding.dart';
import '../PageFrame/PageFrameTeam.dart';
import '../dataSets/dataSetColors.dart';
import '../pageFetures/pageFeatursMains/pageFeaturesMain.dart';

class WidgetCommonAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const WidgetCommonAppbar(
      {Key? key,
      required this.appBar,
      required this.currentPage,
      required this.loginState})
      : super(key: key);

  final AppBar appBar;
  final String currentPage;
  final bool loginState;

  @override
  Widget build(BuildContext context) {
    TextStyle h1 =
        TextStyle(fontSize: 14, fontFamily: 'seqm', color: crKeyColorB1F);
    return AppBar(
      elevation: 0,
      backgroundColor: crKeyColorB1,
      titleSpacing: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('V - MAP',
              style: TextStyle(
                  color: crKeyColorB1F, fontFamily: 'seqbl', fontSize: 24)),
          const SizedBox(width: 160),
          WidgetButtonContainer(
              currentPage: currentPage,
              pageName: 'about',
              child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageFrameRanding()));
                  },
                  child: Text('About', style: h1))),
          WidgetButtonContainer(
              currentPage: currentPage,
              pageName: 'recording',
              child: TextButton(
                  onPressed: () {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(
                    //         builder: (context) => PageFrameTeam()));
                  },
                  child: Text('Recording', style: h1))),
          WidgetButtonContainer(
              currentPage: currentPage,
              pageName: 'team',
              child: TextButton(
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PageFrameTeam())),
                  child: Text('Team', style: h1))),
          const SizedBox(width: 160),
          WidgetButtonContainer(
              currentPage: currentPage,
              pageName: loginState == true ? 'sign out' : 'sign in',
              child: loginState == true
                  ? TextButton(
                      onPressed: () {}, child: Text('Sign Out', style: h1))
                  : TextButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageFrameLogin())),
                      child: Text('Sign In/Up', style: h1))),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class WidgetButtonContainer extends StatelessWidget {
  WidgetButtonContainer(
      {Key? key,
      required this.currentPage,
      required this.pageName,
      required this.child})
      : super(key: key);
  String currentPage;
  String pageName;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        height: 100,
        color: currentPage == pageName ? crKeyColorB1 : crKeyColorB1,
        child: (pageName == 'sign out' || pageName == 'sign in')
            ? Container(
                width: 100,
                height: 32,
                decoration: BoxDecoration(
                    border: Border.all(color: crKeyColorB1F, width: 1),
                    borderRadius: BorderRadius.circular(16)),
                child: child)
            : child);
  }
}
