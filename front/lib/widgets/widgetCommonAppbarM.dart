import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';

import '../PageFrame/PageFrameRanding.dart';
import '../PageFrame/PageFrameTeam.dart';
import '../dataSets/dataSetColors.dart';
import '../pageFetures/pageFeatursMains/pageFeaturesMain.dart';

class WidgetCommonAppbarM extends StatelessWidget
    implements PreferredSizeWidget {
  const WidgetCommonAppbarM(
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
      shape: Border(bottom: BorderSide(color: crKeyColorB1F, width: 0.4)),
      elevation: 0,
      backgroundColor: crKeyColorB1Menu,
      titleSpacing: 0,
      centerTitle: true,
      leadingWidth: 168,
      leading: Container(
        alignment: Alignment.center,
        width: 168,
        child: Text('V - MAP',
            style: TextStyle(
                color: crKeyColorB1F, fontFamily: 'seqbl', fontSize: 24)),
      ),
      title: Row(
        children: [],
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
