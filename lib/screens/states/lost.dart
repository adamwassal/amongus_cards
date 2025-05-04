import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Lost extends StatefulWidget {
  const Lost({super.key, this.killers});
  final List? killers;

  @override
  State<Lost> createState() => _LostState();
}

class _LostState extends State<Lost> {
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
                lang == "ar" ? "اوه لا: لقد خسرنا" : 'Oh no! We lost!',
                style: TextStyle(fontSize: 32,color: Colors.white),
              ),
              if (widget.killers != null)
                ...widget.killers!.map((killer) => Text(killer, style: TextStyle(color: Colors.white, fontSize: 30),)).toList(),
              const SizedBox(height: 20),
              Btn(
                text:
                    lang == "ar" ? "الرجوع الي الشاشة الرئيسة" : "Back to Home",
                function: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
                enabled: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
