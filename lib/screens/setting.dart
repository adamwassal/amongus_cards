import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/screens/home.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
          child: Column(
            children: [
              Logo(),
              Text(
                lang == "ar" ? "الإعدادات" : "Settings",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Fredoka",
                  color: Colors.white
                ),
              ),
              Btn(
                text: lang == "ar" ? "العربية" : "Arabic",
                function: () {
                  setState(() {
                    storage.write(key: "lang", value: "ar");
                    lang = "ar";
                  });
                },
                enabled: true,
              ),
              Btn(
                text: lang == "ar" ? "الإنجليزية" : "English",
                function: () {
                  setState(() {
                    storage.write(key: "lang", value: "en");
                    lang = "en";
                  });
                },
                enabled: true,
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
    );
  }
}
