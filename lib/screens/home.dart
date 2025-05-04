import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/screens/multi/choose.dart';
import 'package:amongus_cards/screens/rules.dart';
import 'package:amongus_cards/screens/setting.dart';
import 'package:amongus_cards/screens/local/start1.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final storage = FlutterSecureStorage();
  String? lang;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    String? storedLang = await storage.read(key: "lang");
    if (storedLang == null) {
      await storage.write(key: "lang", value: "en");
      storedLang = "en";
    }
    setState(() {
      lang = storedLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Logo(),
                      Btn(
                        text: lang == "ar" ? "بدء اللعبة" : "Start Game",
                        function: () {
                          CustomRoute.push(context, Start1());
                        },
                        enabled: true,
                      ),

                      Btn(
                        text: lang == "ar" ? "لعب متعدد اونلاين(لن يجرب بعد)" : "Online Multiplayer (Beta)",
                        function: () {
                          CustomRoute.push(context, Choose());
                        },
                        enabled: true,
                      ),
                      Btn(
                        text: lang == "ar" ? "القواعد" : "Rules",
                        function: () {
                          CustomRoute.push(context, Rules());
                        },
                        enabled: true,
                      ),

                      Btn(
                        text: lang == "ar" ? "الإعدادات" : "Settings",
                        function: () {
                          CustomRoute.push(context, Settings());
                        },
                        enabled: true,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          "Developed By Adam Wael",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          "Version 1.0.0",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
