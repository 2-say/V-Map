import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:front/PageFrame/PageFrameLogin.dart';
import 'package:front/PageFrame/PageFrameRanding.dart';
import 'package:front/pageFetures/pageFeaturesInvite.dart';
import 'package:front/pageFetures/pageFeaturesMain.dart';

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
        title: 'V-Map',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),

        home: const PageFeatureMain());
  }
}
