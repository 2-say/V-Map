import 'package:flutter/material.dart';

void main() {
  runApp(const UIPractice());
}

class UIPractice extends StatelessWidget {
  const UIPractice({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Center(
        child: Container(width: 50, height: 50, color: Colors.black)
      )
    );
  }
}