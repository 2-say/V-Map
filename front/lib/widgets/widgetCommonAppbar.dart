import 'package:flutter/material.dart';

import '../PageFrame/PageFrameRanding.dart';
import '../dataSets/dataSetColors.dart';

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
        const TextStyle(fontSize: 20, fontFamily: 'apeb', color: Colors.black);
    return AppBar(
      elevation: 0,
      backgroundColor: ccKeyColorGrey,
      leading: Container(
        color: currentPage == 'meeting'
            ? ccKeyColorBackground
            : Colors.black.withOpacity(0.2),
        child: IconButton(
            icon: Image.asset("assets/vmaplogo.png", width: 32, height: 32),
            onPressed: () => Navigator.of(context).pop()),
      ),
      titleSpacing: 0,
      centerTitle: center,
      title: Row(
        children: <Widget>[
          WidgetButtonContainer(
              currentPage: currentPage,
              pageName: 'about',
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PageFrameRanding()));
                  },
                  child: Text('About', style: h1))),
          WidgetButtonContainer(
              currentPage: currentPage,
              pageName: 'team',
              child:
                  TextButton(onPressed: () {}, child: Text('Team', style: h1))),
          const Expanded(child: SizedBox()),
          WidgetButtonContainer(
              currentPage: currentPage,
              pageName: loginState == true ? 'my page' : 'sign in',
              child: loginState == true
                  ? TextButton(
                      onPressed: () {}, child: Text('My page', style: h1))
                  : TextButton(
                      onPressed: () {}, child: Text('Sign In/Up', style: h1))),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
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
      child: child,
    );
  }
}
