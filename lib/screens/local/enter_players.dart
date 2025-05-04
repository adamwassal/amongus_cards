import 'package:amongus_cards/screens/local/turns.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/btn.dart';
import 'package:amongus_cards/widgets/field.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EnterPlayers extends StatefulWidget {
  const EnterPlayers({
    super.key,
    required this.playercount,
    required this.killercount,
  });
  final int playercount;
  final int killercount;

  @override
  State<EnterPlayers> createState() => _EnterPlayersState();
}

class _EnterPlayersState extends State<EnterPlayers> {
  int currentPage = 0;
  final PageController pageController = PageController();
  final storage = FlutterSecureStorage();
  String? lang;
  final List<TextEditingController> _controllers = [];
  final List<String> players = []; // List to store player names

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    // Initialize controllers for each player
    for (int i = 0; i < widget.playercount; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  Future<void> _initializePreferences() async {
    final storedLang = await storage.read(key: "lang");
    setState(() {
      lang = storedLang;
    });
  }

  void _handleNext() {
    // Get the current player's name and add to the list
    final currentName = _controllers[currentPage].text.trim();
    if (currentName.isNotEmpty) {
      players.add(currentName);
      print(players);
      if (currentPage < widget.playercount - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        // All players added, navigate to home with the list
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    Turns(players: players, countkillers: widget.killercount),
          ),
        );
      }
    } else {
      players.add("${currentPage + 1}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        starCount: 200,

        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentPage + 1) / widget.playercount,
            ),
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: widget.playercount,
                itemBuilder: (context, index) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Logo(),
                        Text(
                          "#${index + 1}",
                          style: const TextStyle(
                            fontSize: 30,
                            fontFamily: "Fredoka",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 400,
                          child: Field(
                            label: "${index + 1}",
                            controller: _controllers[index],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Btn(
                          text: lang == "ar" ? "التالي" : "Next",
                          function: _handleNext,
                          // Disable button if name is empty
                          enabled: _controllers[index].text.trim().isNotEmpty,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
