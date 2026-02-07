import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safe_space/controller/auth_gate.dart';
import 'package:safe_space/model/colors.dart';
import 'package:safe_space/view/widgets/cLogo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    starttime();
  }

  starttime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, nextScreen);
  }

  nextScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => AuthGate()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brown,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: SvgPicture.asset(
                'assets/wave_background.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(child: cLogo(fontSize: 60)),
        ],
      ),
    );
  }
}
