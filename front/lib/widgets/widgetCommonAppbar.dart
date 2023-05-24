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
      required this.loginState,
      this.center = false})
      : super(key: key);

  final AppBar appBar;
  final String currentPage;
  final bool loginState;
  final bool center;

  @override
  Widget build(BuildContext context) {
    TextStyle h1 =
        const TextStyle(fontSize: 16, fontFamily: 'apl', color: Colors.black);
    return AppBar(
      elevation: 0,
      backgroundColor: ccKeyColorGrey,
      leading: Container(
          width: 40,
          color:
              currentPage == 'meeting' ? ccKeyColorBackground : ccKeyColorGrey,
          child: IconButton(
            constraints: BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: Image.asset("assets/vmaplogo.png", width: 24, height: 24),
            onPressed: () {},
            // onPressed: () => Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const PageFeatureMain()))
          )),
      titleSpacing: 0,
      centerTitle: center,
      title: Row(
        children: <Widget>[
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
              pageName: 'team',
              child: TextButton(
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => PageFrameTeam())),
                  child: Text('Team', style: h1))),
          const Expanded(child: SizedBox()),
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
  Size get preferredSize => const Size.fromHeight(32);
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
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        height: 100,
        color: currentPage == pageName ? ccKeyColorBackground : ccKeyColorGrey,
        child: child);
  }
}
