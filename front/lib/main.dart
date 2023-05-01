import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/pageFetures/pageFeaturesInvitation.dart';
import 'package:front/pageFetures/pageFeatursMains/pageFeaturesMain.dart';
import 'package:front/pageFetures/pageFeaturesRecord.dart';

import 'firebase_options.dart';

void main() {
  initFirebase();
  runApp(const MyApp());
}

void initFirebase() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'V-Map(test)',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: PageFeatureMain());
  }
}
