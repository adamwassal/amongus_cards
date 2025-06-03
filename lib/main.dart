import 'package:amongus_cards/screens/home.dart';
import 'package:amongus_cards/screens/rules.dart';
import 'package:amongus_cards/screens/setting.dart';
import 'package:amongus_cards/screens/local/game.dart';
import 'package:amongus_cards/screens/local/start1.dart';
import 'package:amongus_cards/screens/splash.dart';
import 'package:amongus_cards/screens/states/win.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffB0B0B0)),
      ),
      home: SplashScreen(),
      // Game(friends: ["1","2","3","5"],killers: ["4","6"], players: ["1","2","3","4","5","6"],),
    );
  }
}
