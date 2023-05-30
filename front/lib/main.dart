import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/dataSets/dataSetColors.dart';
import 'package:front/pageFetures/pageFeatursMains/pageFeaturesMain.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

void initFirebase() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print('initFirebase Successfully.');
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'V-Map ; Do Not Record Alone.',
        theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData().copyWith(
            thumbColor: MaterialStateProperty.all(crKeyColorB1ScrollBar),
          ),
          primarySwatch: Colors.grey,
        ),
        home: PageFrameRanding());
  }
}
