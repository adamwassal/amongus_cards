import 'package:amongus_cards/screens/local/enter_players.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:amongus_cards/widgets/field.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Start1 extends StatefulWidget {
  const Start1({super.key});

  @override
  State<Start1> createState() => _Start1State();
}

class _Start1State extends State<Start1> {
  final storage = FlutterSecureStorage();
  String? lang;

  final count = TextEditingController();
  final countkillers = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    String? storedLang = await storage.read(key: "lang");
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Logo(),
                  Container(
                    width: 400,
                    child: Field(label: lang == "ar"? "أدخل عدد اللاعبين":"Enter the player count", controller: count),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 400,
                    child: Field(label: lang == "ar"? "أدخل عدد القاتلين":"Enter the killer count", controller: countkillers),
                  ),

                  Btn(
                    text: lang == "ar" ? "التالي" : "Next",
                    function: () {
                      // Try to parse the values
                      int? playerCount = int.tryParse(count.text);
                      int? killerCount = int.tryParse(countkillers.text);
                      // First check if fields are empty
                      if (count.text.isEmpty || countkillers.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                lang == "ar"
                                    ? "الرجاء إدخال جميع الحقول"
                                    : "Please enter the required fields",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(lang == "ar" ? "حسنا" : "OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return; // Exit the function early
                      }
                      // Check if parsing was successful
                      else if (playerCount == null || killerCount == null) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                lang == "ar"
                                    ? "الرجاء إدخال أرقام صحيحة"
                                    : "Please enter valid numbers",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(lang == "ar" ? "حسنا" : "OK"),
                                ),
                              ],
                            );
                          },
                        );
                        return; // Exit the function early
                      }
                      // Now proceed with your validations
                      else if (playerCount <= 3) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                lang == "ar"
                                    ? "عدد اللاعبين يجب أن يكون أكبر من 3"
                                    : "The number of players must be greater than 3",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(lang == "ar" ? "حسنا" : "OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (playerCount <= killerCount) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                lang == "ar"
                                    ? "عدد المجرمين يجب أن يكون أقل من عدد اللاعبين"
                                    : "The number of killers must be less than the number of players",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(lang == "ar" ? "حسنا" : "OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (killerCount < 1) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                lang == "ar"
                                    ? "عدد المجرمين يجب أن يكون أكبر من 0"
                                    : "The number of killers must be greater than 0",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(lang == "ar" ? "حسنا" : "OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (killerCount > 3) {
                        // Changed from < 3 to > 3 based on Arabic message
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                lang == "ar"
                                    ? "عدد المجرمين يجب أن يكون اقل او يساوي من 3"
                                    : "The number of killers must be less than or equal to 3",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(lang == "ar" ? "حسنا" : "OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (playerCount - killerCount < killerCount) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                lang == "ar"
                                    ? "عدد المجرمين يجب أن يكون أقل من عدد الأصدقاء"
                                    : "The number of killers must be less than the number of friends",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(lang == "ar" ? "حسنا" : "OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (playerCount - killerCount == killerCount) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                lang == "ar"
                                    ? "عدد المجرمين يجب أن يكون أقل من نصف عدد اللاعبين"
                                    : "The number of killers must be less than half the number of players",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(lang == "ar" ? "حسنا" : "OK"),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EnterPlayers(
                                  playercount: playerCount,
                                  killercount: killerCount,
                                ),
                          ),
                        );
                      }
                    },
                    enabled: true,
                  ),
                ],
              ),
              Btn(
                text: lang == "ar" ? "رجوع" : "Back",
                function: () {
                  Navigator.pushReplacementNamed(context, '/home');
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
