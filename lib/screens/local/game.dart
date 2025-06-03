import 'dart:async';
import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/functions/warning.dart';
import 'package:amongus_cards/screens/home.dart';
import 'package:amongus_cards/screens/states/lost.dart';
import 'package:amongus_cards/screens/states/win.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';

class Game extends StatefulWidget {
  final List<String> players;
  final List<String> killers;
  final List<String> friends;

  const Game({
    super.key,
    required this.players,
    required this.killers,
    required this.friends,
  });

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  String? _selectedPlayerToFire;
  String? _selectedBody;
  Timer? _timer;
  int _timerSeconds = 30;
  bool _isMeetingActive = true;
  final storage = FlutterSecureStorage();
  final player = AudioPlayer();
  int killerscount = 0;
  int friendscount = 0;

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
    setState(() {
      killerscount = widget.killers.length;
      friendscount = widget.friends.length;
    });
    _initializePreferences();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _checkGameOver();
    setState(() {
      _isMeetingActive = false;
      _timerSeconds = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
        setState(() {
          _isMeetingActive = true;
        });
      } else {
        setState(() => _timerSeconds--);
      }
    });
  }

  void _checkGameOver() {
    if (killerscount == 0) {
      CustomRoute.pushReplacement(
        context,
        Win(
          killerscount: widget.killers.length,
          players: [...widget.killers, ...widget.friends],
        ),
        transition: TransitionType.rotation
      );
    } else if (killerscount! >= friendscount) {
      CustomRoute.pushReplacement(
        context,
        Lost(
          killers: widget.killers,
          killerscount: widget.killers.length,
          players: [...widget.killers, ...widget.friends],
        ),
        transition: TransitionType.rotation
      );
    }
  }

  void _callEmergencyMeeting() async {
    _checkGameOver();
    await player.setAsset("assets/audios/emergency.mp3");
    player.play();
    print("emergency");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.black,

            title: Column(
              children: [
                Image.asset("assets/images/emergency.jpeg"),
                Text(
                  lang == "ar" ? "اجتماع الطوارئ" : "Emergency Meeting",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            content: Text(
              lang == "ar"
                  ? "جاري تنفيذ الاجتماع ..."
                  : "You have called an emergency meeting!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  startTimer();
                  _checkGameOver();
                },
                child: Text(lang == "ar" ? "انهاء الإجتماع" : "Finish Meeting", 
                    style: TextStyle(color: Colors.green, fontSize: 20)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showFirePlayerDialog();
                  _checkGameOver();
                },
                child: Text(lang == "ar" ? "طرد لاعب" : "Fire Player",style: TextStyle(color: Colors.red, fontSize: 20)),
              ),
            ],
          ),
    );
  }

  void _showFirePlayerDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: Colors.black,

                title: Text(
                  lang == "ar" ? "طرد لاعب" : "Fire Player",
                  style: TextStyle(color: Colors.white),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang == "ar"
                          ? "اختر اللاعب الذي سيطرد"
                          : "Select a player to fire:",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      dropdownColor: Colors.black,

                      value: _selectedPlayerToFire,
                      items:
                          widget.players.map((String player) {
                            return DropdownMenuItem<String>(
                              value: player,
                              child: Text(
                                player,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        setState(() => _selectedPlayerToFire = newValue);
                      },
                      hint: Text(
                        _selectedPlayerToFire ?? "Select player",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (_selectedPlayerToFire != null) {
                        await player.setAsset("assets/audios/bye.mp3");
                        player.play();
                        print("emergency");
                        setState(() {
                          if (widget.killers.contains(_selectedPlayerToFire!)) {
                            setState(() {
                              killerscount--;
                            });
                            Warning.showWarningDialog(
                              context,
                              "$_selectedPlayerToFire هو القاتل!",
                              "$_selectedPlayerToFire was a killer!",
                            );
                          } else {
                            friendscount--;
                            Warning.showWarningDialog(
                              context,
                              "$_selectedPlayerToFire كان صديق!!",
                              "$_selectedPlayerToFire was a friend!",
                            );
                          }
                          widget.players.remove(_selectedPlayerToFire!);
                          _selectedPlayerToFire = null;
                          _checkGameOver();
                          startTimer();
                        });
                      }
                      Navigator.pop(context);
                      _checkGameOver();
                    },
                    child: Text(
                      lang == "ar" ? "حسناً" : "OK",
                      style: TextStyle(color: Colors.green, fontSize: 30),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  void _showBodyDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: Colors.black,
                title: Column(
                  children: [
                    Image.asset("assets/images/body.jpeg"),
                    Text(
                      lang == "ar" ? "من الميت" : "Who died?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      lang == "ar" ? "اختر الجثة" : "Select the body:",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<String>(
                      dropdownColor: Colors.black,
                      value: _selectedBody,
                      items:
                          widget.players.map((String player) {
                            return DropdownMenuItem<String>(
                              value: player,
                              child: Text(
                                player,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),

                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBody = newValue;
                        });
                      },

                      hint: Text(
                        _selectedBody ?? "Select player",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (widget.killers.contains(_selectedBody)) {
                        Navigator.pop(context);
                        Warning.showWarningDialog(
                          context,
                          "كيف؟ لا يمكن ان يُقتل القاتل",
                          "How? the killer was killed!",
                        );

                        startTimer();
                        return;
                      } else if (_selectedBody != null) {
                        await player.setAsset("assets/audios/body.mp3");
                        player.play();
                        print("body");
                        setState(() async {
                          Navigator.pop(context);
                          friendscount--;
                          widget.players.remove(_selectedBody!);
                          Warning.showWarningDialog(
                            context,
                            "$_selectedBody لقد قتل",
                            "$_selectedBody was killed!",
                            () async {
                              _selectedBody = null;

                              _callEmergencyMeeting();
                            },
                          );
                        });
                      }
                      _checkGameOver();
                    },
                    child: Text(lang == "ar" ? "حسناً" : "OK",
                        style: TextStyle(color: Colors.green, fontSize: 30)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      startTimer();
                      _checkGameOver();
                    },
                    child: Text(
                      lang == "ar" ? "الغاء" : "Cancel",
                      style: TextStyle(color: Colors.red, fontSize: 30),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CustomRoute.pushReplacement(context, const Home(),transition: TransitionType.rotation);
        },
        child: const Icon(Icons.home),
      ),
      body: StarryBackground(
        starCount: 200,

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(),
              const SizedBox(height: 20),
              Text(
                lang == "ar"
                    ? "المجرمين: ${killerscount}"
                    : "Killers: ${killerscount}",
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.red,
                  fontFamily: "Fredoka",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                lang == "ar"
                    ? "الأصدقاء: ${friendscount}"
                    : "Friends: ${friendscount}",
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                  fontFamily: "Fredoka",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Btn(
                text:
                    _isMeetingActive
                        ? lang == "ar"
                            ? "الطوارئ"
                            : "Emergency"
                        : "$_timerSeconds",
                function: () async {
                  if (_isMeetingActive) {
                    _callEmergencyMeeting();
                  }
                },

                enabled: _isMeetingActive,
              ),
              const SizedBox(height: 20),
              Btn(
                text: lang == "ar" ? "الإبلاغ عن جثة" : "Report Body",
                function: () async {
                  if (_timer != null) {
                    _timer!.cancel();
                  }
                  setState(() {
                    _isMeetingActive = false;
                    _timerSeconds = 30;
                  });
                  _showBodyDialog();
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
