import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Win extends StatefulWidget {
  const Win({super.key});

  @override
  State<Win> createState() => _WinState();
}

class _WinState extends State<Win> {
  final storage = FlutterSecureStorage();
  String? lang;
  Future<void> _initializePreferences() async {
    String? storedLang = await storage.read(key: "lang");
    setState(() {
      lang = storedLang;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                lang == "ar" ? "ياي! نحن الفائزون" : 'yay! We are winners!',
                style: TextStyle(fontSize: 32,color: Colors.white),
              ),
              const SizedBox(height: 20),
              Btn(
                text:
                    lang == "ar" ? "الرجوع الي الشاشة الرئيسة" : "Back to Home",
                function: () {
                  Navigator.pushReplacementNamed(context, "/home");
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
