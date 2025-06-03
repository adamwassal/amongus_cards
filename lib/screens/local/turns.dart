import 'dart:math';

import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/screens/home.dart';
import 'package:amongus_cards/screens/local/game.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';

class Turns extends StatefulWidget {
  Turns({super.key, required this.players, required this.countkillers});
  final List<String>? players;
  final int? countkillers;

  @override
  State<Turns> createState() => _TurnsState();
}

class _TurnsState extends State<Turns> {
  int currentPage = 0;
  List<String> killers = [];
  List<String> friends = [];
  final storage = FlutterSecureStorage();
  final PageController pageController = PageController();

  String? lang;

  Future<void> _initializePreferences() async {
    String? storedLang = await storage.read(key: "lang");
    setState(() {
      lang = storedLang;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.players != null && widget.countkillers != null) {
      final shuffledPlayers = List<String>.from(widget.players!)..shuffle();
      final selectedKillers =
          shuffledPlayers.take(widget.countkillers!).toList();
      print(selectedKillers);

      setState(() {
        killers.addAll(selectedKillers);
        for (var i = 0; i < widget.players!.length; i++) {
          if (!selectedKillers.contains(widget.players![i])) {
            friends.add(widget.players![i]);
          }
        }
      });

      print(killers);
    }
    _initializePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,

        child: PageView.builder(
          itemCount: widget.players!.length + 1,
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.players!.length != index)
                          Text(
                            "${widget.players![index]}",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        SizedBox(height: 20),
                        if (widget.players!.length != index)
                          Btn(
                            text:
                                lang == "ar" ? "رؤية المعلومات" : "Show Details",
                            function: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Text(
                                      lang == "ar" ? "المعلومات" : "Details",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          killers.contains(widget.players![index])
                                              ? lang == "ar"
                                                  ? "مجرم"
                                                  : "Killer"
                                              : lang == "ar"
                                              ? "صديق"
                                              : "Friend",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Image.asset(
                                          killers.contains(widget.players![index])
                                              ? "assets/images/knife.png"
                                              : "assets/images/magnifying.png",
                                        ),
                                        if (killers.contains(
                                              widget.players![index],
                                            ) &&
                                            killers.length > 1)
                                          Text(
                                            "${killers.join(", ")}",
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                      ],
                                    ),
                    
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          lang == "ar" ? "حسناً" : "OK",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            enabled: true,
                          ),
                    
                        if (widget.players!.length == index)
                          Btn(
                            text:
                                lang == "ar"
                                    ? "الدخول الي اللعبة"
                                    : "Enter the game",
                            function: () async {
                              final player = AudioPlayer();
                              await player.setAsset("assets/audios/intro.wav");
                              player.play();
                    
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Column(
                                      children: [
                                        Image.asset("assets/images/intro.jpg"),
                                        Text(
                                          lang == "ar"
                                              ? "ششششششش!"
                                              : "shshshshshshsh!",
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              await Future.delayed(Duration(seconds: 2));
                              Navigator.of(context).pop();
                    
                              CustomRoute.pushReplacement(
                                context,
                                Game(
                                  players: widget.players!,
                                  killers: killers,
                                  friends: friends,
                                ),
                                transition: TransitionType.slideFade,
                              );
                            },
                            enabled: true,
                          ),
                        // make navigation bar to next and back
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: currentPage != 0,
                              child: TextButton(
                                onPressed: () {
                                  if (currentPage > 0) {
                                    setState(() {
                                      pageController.previousPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                      currentPage--;
                                    });
                                  }
                                },
                                
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      lang == "ar" ? "السابق" : "Previous",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ]
                                )
                              ),
                            ),
                            const SizedBox(width: 20),
                           
                            Text(
                              "${index + 1}/${widget.players!.length + 1}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 20),
                    
                            Visibility(
                              visible: currentPage != widget.players!.length,
                              child: TextButton(
                                onPressed: () {
                                  if (currentPage < widget.players!.length) {
                                    setState(() {
                                      pageController.nextPage(
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                      currentPage++;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      lang == "ar" ? "التالي" : "Next",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ],
                                )
                              ),
                            ),
                    
                            
                          ],
                        ),
                        SizedBox(height: 100),
                        Btn(
                          text:lang == "ar" ? "الذهاب للشاشة الرئيسية" : "Go to Home Screen",
                          function: () {
                            CustomRoute.pushReplacement(context, Home(), 
                              transition: TransitionType.scaleRotate);
                          },
                          enabled: true,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
