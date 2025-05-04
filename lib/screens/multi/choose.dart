import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/screens/home.dart';
import 'package:amongus_cards/screens/multi/host.dart';
import 'package:amongus_cards/screens/multi/join.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';

class Choose extends StatefulWidget {
  const Choose({super.key});

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,
        child: Center(
          child: Column(
            children: [
              Logo(),
              Btn(text: "Host Room", function: () {CustomRoute.push(context, HostRoom());}, enabled: true),
              Btn(text: "Join Room", function: () {CustomRoute.push(context, JoinRoom());}, enabled: true),
              Btn(text: "Back", function: () {CustomRoute.push(context, Home());}, enabled: true),
            ],
          ),
        ),
      ),
    );
  }
}
