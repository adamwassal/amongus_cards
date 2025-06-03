import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/functions/warning.dart';
import 'package:amongus_cards/screens/home.dart';
import 'package:amongus_cards/screens/local/enter_players.dart';
import 'package:amongus_cards/screens/local/turns.dart';
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
  bool? malekAhmed = false;
  bool? adamWael = false;
  bool? sohybSalah = false;
  bool? allowGirls = false;
  bool? shuffleplayers = false;

  List<String> malekList = ["Malek", "Muslem"];
  List<String> sohybList = ["Sohyb", "Ali"];
  List<String> adamList = ["Adam", "Elias", "Salman"];
  List<String> girlslist = ["Maria", "Khadega"];

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

  void next() {
    // Try to parse the values
    int? playerCount = int.tryParse(count.text);
    int? killerCount = int.tryParse(countkillers.text);
    // First check if fields are empty
    if (count.text.isEmpty || countkillers.text.isEmpty) {
      Warning.showWarningDialog(
        context,
        "أدخل جميع الحقول",
        "Enter all Fields",
      );
      return;
    }
    // Check if parsing was successful
    else if (playerCount == null || killerCount == null) {
      Warning.showWarningDialog(
        context,
        "الرجاء إدخال أرقام صحيحة",
        "Please enter valid numbers",
      );
      return;
    }
    // Now proceed with your validations
    else if (playerCount <= 3) {
      Warning.showWarningDialog(
        context,
        "عدد اللاعبين يجب أن يكون أكبر من 3",
        "The number of players must be greater than 3",
      );
    } else if (playerCount <= killerCount) {
      Warning.showWarningDialog(
        context,
        "عدد المجرمين يجب أن يكون أقل من عدد اللاعبين",
        "The number of killers must be less than the number of players",
      );
    } else if (killerCount < 1) {
      Warning.showWarningDialog(
        context,
        "عدد المجرمين يجب أن يكون أكبر من 0",
        "The number of killers must be greater than 0",
      );
    } else if (killerCount > 3) {
      Warning.showWarningDialog(
        context,
        "عدد المجرمين يجب أن يكون اقل او يساوي من 3",
        "The number of killers must be less than or equal to 3",
      );
    } else if (playerCount - killerCount < killerCount) {
      Warning.showWarningDialog(
        context,
        "عدد المجرمين يجب أن يكون أقل من عدد الأصدقاء",
        "The number of killers must be less than the number of friends",
      );
    } else if (playerCount - killerCount == killerCount) {
      Warning.showWarningDialog(
        context,
        "عدد المجرمين يجب أن يكون أقل من نصف عدد اللاعبين",
        "The number of killers must be less than half the number of players",
      );
    } else {
      CustomRoute.pushReplacement(
        context,
        EnterPlayers(playercount: playerCount, killercount: killerCount),
        transition: TransitionType.scale,
      );
    }
  }

  void weNext() {
    List<String> players = [
      if (malekAhmed!) ...malekList,
      if (sohybSalah!) ...sohybList,
      if (adamWael!) ...adamList,
      if (allowGirls!) ...girlslist,
    ];
    if (shuffleplayers!) players.shuffle();

    int? killerscount = int.tryParse(countkillers.text);
    if (players.length > 4 &&
        killerscount != null &&
        killerscount > 0 &&
        killerscount != players.length / 2) {
      Navigator.of(context).pop();
      CustomRoute.pushReplacement(
        context,
        Turns(countkillers: killerscount, players: players),
        transition: TransitionType.scale,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Logo(),
                    Container(
                      width: 400,
                      child: Field(
                        label:
                            lang == "ar"
                                ? "أدخل عدد اللاعبين"
                                : "Enter the player count",
                        controller: count,
                        keyboardType: TextInputType.number,
                        function: (value) {
                          next();
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 400,
                      child: Field(
                        label:
                            lang == "ar"
                                ? "أدخل عدد القاتلين"
                                : "Enter the killer count",
                        controller: countkillers,
                        keyboardType: TextInputType.number,
                        function: (value) {
                          next();
                        },
                      ),
                    ),

                    Btn(
                      text: lang == "ar" ? "التالي" : "Next",
                      function: next,
                      enabled: true,
                    ),
                  ],
                ),
                Btn(
                  enabled: true,
                  function: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (
                            BuildContext context,
                            StateSetter setState,
                          ) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: Text(
                                "${lang == "ar" ? "شكلك من عيلة وصال" : "you Look from Wassal family"}",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          malekAhmed = !malekAhmed!;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: malekAhmed,
                                            onChanged: (value) {
                                              setState(() {
                                                malekAhmed = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            lang == "ar"
                                                ? "مالك أحمد"
                                                : "Malek Ahmed",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          sohybSalah = !sohybSalah!;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: sohybSalah,
                                            onChanged: (value) {
                                              setState(() {
                                                sohybSalah = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            lang == "ar"
                                                ? "صهيب صلاح"
                                                : "Sohyb Salah",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          adamWael = !adamWael!;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: adamWael,
                                            onChanged: (value) {
                                              setState(() {
                                                adamWael = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            lang == "ar"
                                                ? "ادم وائل"
                                                : "Adam Wael",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          allowGirls = !allowGirls!;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: allowGirls,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                allowGirls = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            lang == "ar"
                                                ? "السماح بالبنات"
                                                : "Allow Girls",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          shuffleplayers = !shuffleplayers!;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: shuffleplayers,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                shuffleplayers = value;
                                              });
                                            },
                                          ),
                                          Text(
                                            lang == "ar"
                                                ? "خلط ترتيب اللاعبين"
                                                : "Shuffle players",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20),
                                    Field(
                                      label:
                                          "${lang == "ar" ? "عدد القاتلين" : "Killer Count"}",
                                      controller: countkillers,
                                      color: Colors.white,
                                      keyboardType: TextInputType.number,
                                      function: (value) {
                                        weNext();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    weNext();
                                  },
                                  child: Text(
                                    lang == "ar" ? "بدء" : "Start",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    lang == "ar" ? "إلغاء" : "Cancel",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  text: lang == "ar" ? "نحن" : "We",
                ),
                Btn(
                  text: lang == "ar" ? "رجوع" : "Back",
                  function: () {
                    CustomRoute.pushReplacement(
                      context,
                      Home(),
                      transition: TransitionType.rotation,
                    );
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
