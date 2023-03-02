import 'package:flutter/material.dart';
import 'package:front/pageFetures/pageFeaturesMain.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'V-Map',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const PageFeatureMain());
  }
}
