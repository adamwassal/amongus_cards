import 'package:amongus_cards/functions/route.dart';
import 'package:amongus_cards/screens/home.dart';
import 'package:amongus_cards/widgets/bg.dart';
import 'package:amongus_cards/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      CustomRoute.push(context, Home());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StarryBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(),
              // Lottie.asset('assets/loading/Animation-1747169260498.json',width: 200, height: 200, fit: BoxFit.fill, backgroundLoading: true),
            ],
          ),
        ),
      ),
    );
  }
}
