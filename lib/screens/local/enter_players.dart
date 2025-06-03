import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/functions/warning.dart';
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
  final List<String> players = [];
  String? vall;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    // Initialize controllers with default empty values
    _controllers.addAll(
      List.generate(widget.playercount, (index) => TextEditingController()),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  Future<void> _initializePreferences() async {
    final storedLang = await storage.read(key: "lang");
    setState(() => lang = storedLang);
  }

  void _handleNext() {
    final currentName = _controllers[currentPage].text.trim();

    if (currentName.isEmpty) {
      Warning.showWarningDialog(
        context,
        "الرجاء إدخال الإسم",
        "Please enter the name",
      );
      return;
    }

    setState(() {
      if (currentPage >= players.length) {
        players.add(currentName);

      } else {
        players[currentPage] = currentName;
      }
    });

    if (currentPage < widget.playercount - 1) {

      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() {
        vall = "";
        print(vall);
      });
    } else {
      _navigateToTurnsScreen();
    }
  }

  void _navigateToTurnsScreen() {
    CustomRoute.pushReplacement(
      context,
      Turns(players: players, countkillers: widget.killercount),
      transition: TransitionType.scale
    );
  }

  Widget _buildPlayerListPreview() {
    if (players.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < players.length; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                  );
                  pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn,
                  );
                  currentPage = i;
                  vall = _controllers[currentPage].text;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Chip(
                  label: Text(
                    players[i],
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue.withOpacity(0.5),
                ),
              ),
            ),
        ],
      ),
    );
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
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (index) => setState(() => currentPage = index),
                itemCount: widget.playercount,
                itemBuilder: (context, index) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Logo(),
                              const SizedBox(height: 20),

                              // Player number indicator
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

                              // Preview of entered players
                              _buildPlayerListPreview(),
                              const SizedBox(height: 20),

                              // Name input field
                              SizedBox(
                                width: 400,
                                child: Field(
                                  label: "Player ${index + 1}",
                                  controller: _controllers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      vall = value;
                                    });
                                  },
                                  function: (value) {
                                    _handleNext();
                                  },
                                  focus: index != 0 ? true : false,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Next button
                              Btn(
                                text: lang == "ar" ? "التالي" : "Next",
                                function: _handleNext,
                                enabled: vall != null && vall != "" ? true : false,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
