import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/screens/home.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Rules extends StatefulWidget {
  const Rules({super.key});

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Logo(),
                Text(
                  lang == "ar" ? "القواعد" : "Rules",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Fredoka",
                    color: Colors.white,
                  ),
                ),
                Text(
                  lang == "ar"
                      ? "-عدم التحدث دون لضغط علي الزر"
                      : "-No belief without pressing the button",
            
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Text(
                  lang == "ar"
                      ? "-عدم الشك في اي شخص دون دليل"
                      : "-Do not suspect anyone without evidence.",
                  style: TextStyle(fontSize: 30,color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                
                Text(
                  lang == "ar"
                      ? "-عدم القتل اذ لم تكن انت المجرم"
                      : "-Don't kill if you're not the criminal.",
                  style: TextStyle(fontSize: 30,color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                
            
                Btn(
                  text: lang == "ar" ? "رجوع" : "Back",
                  function: () {
                    CustomRoute.push(context, Home());
                  },
                  enabled: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
