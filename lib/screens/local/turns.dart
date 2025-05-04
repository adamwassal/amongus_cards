import 'dart:math';

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
          itemCount: widget.players!.length,
          controller: PageController(initialPage: currentPage),
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.players![index]}",
                    style: TextStyle(fontSize: 30,color: Colors.white),
                  ),
                  SizedBox(height: 20),

                  Btn(
                    text: lang == "ar" ? "رؤية المعلومات" : "Show Details",
                    function: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(lang == "ar" ? "المعلومات" : "Details"),
                            content: Column(
                              children: [
                                Text(
                                  killers.contains(widget.players![index])
                                      ? lang == "ar"
                                          ? "مجرم"
                                          : "Killer"
                                      : lang == "ar"
                                      ? "صديق"
                                      : "Friend",
                                  style: TextStyle(fontSize: 30),
                                ),
                                Image.asset(
                                  killers.contains(widget.players![index])
                                      ? "assets/images/knife.png"
                                      : "assets/images/magnifying.png",
                                ),
                                if (killers.contains(widget.players![index]))
                                  Text(
                                    "${killers.join(", ")}",
                                    style: TextStyle(fontSize: 30),
                                  ),
                              ],
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(lang == "ar" ? "حسناً" : "OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    enabled: true,
                  ),
                  if (widget.players![index] ==
                      widget.players![widget.players!.length - 1])
                    Btn(
                      text:
                          lang == "ar" ? "الدخول الي اللعبة" : "Enter the game",
                      function: () async {
                        final player = AudioPlayer(); await player.setAsset("assets/audios/intro.wav");
                        player.play();

                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Column(
                              children: [
                                Image.asset("assets/images/intro.jpg"),
                                Text(lang == "ar" ? "شششششششششششششششش!" : "shshshshshshsh!"),
                              ],
                            ),
                            
                          );
                        });
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.of(context).pop();

                        await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Game(
                                  players: widget.players!,
                                  killers: killers,
                                  friends: friends,
                                ),
                          ),
                        );
                        
                      },
                      enabled: true,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
