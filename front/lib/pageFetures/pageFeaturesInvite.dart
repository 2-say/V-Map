import 'package:flutter/material.dart';

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
          TextButton(onPressed: () {}, child: Text('about', style: TextStyle(fontSize: 20)),
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
          TextButton(onPressed: () {}, child: Text('Sign out', style: TextStyle(fontSize: 20)),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.green,
              minimumSize: Size(300, 75),
            ),
          )],
      ),

      leading: IconButton(icon: Icon(Icons.computer), onPressed: () {}),


    ));
  }
}
