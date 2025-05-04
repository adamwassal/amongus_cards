import 'dart:async';
import 'package:amongus_cards/screens/states/lost.dart';
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
    if (widget.killers.isEmpty || widget.killers.length == 0) {
      Navigator.pushReplacementNamed(context, "/win");
    } else if (widget.killers.length >= widget.friends.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Lost(killers: widget.killers)),
      );
    }
  }

  void _callEmergencyMeeting() async {
    await player.setAsset("assets/audios/emergency.mp3");
    player.play();
    print("emergency");
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            title: Column(
              children: [
                Image.asset("assets/images/emergency.jpeg"),
                Text(lang == "ar" ? "اجتماع الطوارئ" : "Emergency Meeting")
              ],
            ),
            content: Text(
              lang == "ar"
                  ? "جاري تنفيذ الاجتماع ..."
                  : "You have called an emergency meeting!",
                  textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  startTimer();
                  _checkGameOver();
                },
                child: Text(lang == "ar" ? "انهاء الإجتماع" : "Finish Meeting"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showFirePlayerDialog();
                  _checkGameOver();
                },
                child: Text(lang == "ar" ? "طرد لاعب" : "Fire Player"),
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
          (context) => AlertDialog(
            title: Text(lang == "ar" ? "طرد لاعب" : "Fire Player"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang == "ar"
                      ? "اختر اللاعب الذي سيطرد"
                      : "Select a player to fire:",
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedPlayerToFire,
                  items:
                      widget.players.map((String player) {
                        return DropdownMenuItem<String>(
                          value: player,
                          child: Text(player),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() => _selectedPlayerToFire = newValue);
                  },
                  hint: Text(_selectedPlayerToFire ?? "Select player"),
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
                        widget.killers.remove(_selectedPlayerToFire!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              lang == "ar"
                                  ? "$_selectedPlayerToFire هو القاتل!"
                                  : "$_selectedPlayerToFire was a killer!",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      } else {
                        widget.friends.remove(_selectedPlayerToFire!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              lang == "ar"
                                  ? "$_selectedPlayerToFire كان صديق!!"
                                  : "$_selectedPlayerToFire was a friend!",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
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
                child: Text(lang == "ar" ? "حسناً" : "OK"),
              ),
            ],
          ),
    );
  }

  void _showBodyDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            title: Column(
              children: [
                Image.asset("assets/images/body.jpeg"),
                Text(lang == "ar" ? "من الميت" : "Who died?"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(lang == "ar" ? "اختر الجثة" : "Select the body:"),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedBody,
                  items:
                      widget.players.map((String player) {
                        return DropdownMenuItem<String>(
                          value: player,
                          child: Text(player),
                        );
                      }).toList(),

                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBody = newValue;
                    });
                  },

                  hint: Text(_selectedBody ?? "Select player"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (widget.killers.contains(_selectedBody)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lang == "ar"
                              ? "كيف؟ لا يمكن ان يُقتل القاتل"
                              : "How? the killer was killed!",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    );
                    startTimer();
                  } else if (_selectedBody != null) {
                    await player.setAsset("assets/audios/body.mp3");
                    player.play();
                    print("body");
                    setState(() async {
                      Navigator.pop(context);
                      widget.friends.remove(_selectedBody!);
                      widget.players.remove(_selectedBody!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            lang == "ar"
                                ? "$_selectedBody لقد قتل"
                                : "$_selectedBody was killed!",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      );
                      _selectedBody = null;
                      await Future.delayed(Duration(seconds: 2));

                      _callEmergencyMeeting();
                    });
                  }
                  _checkGameOver();
                },
                child: Text(lang == "ar" ? "حسناً" : "OK"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  startTimer();
                  _checkGameOver();
                },
                child: Text(lang == "ar" ? "الغاء" : "Cancel"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/home");
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
                    ? "المجرمين: ${widget.killers.length}"
                    : "Killers: ${widget.killers.length}",
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
                    ? "الأصدقاء: ${widget.friends.length}"
                    : "Friends: ${widget.friends.length}",
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
