import 'dart:async';
import 'package:slot_seek/loading_page.dart';
import 'app_colors.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // The splash screen redirects to the loading screen
    Timer(const Duration(seconds: 2), ((() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: ((context) => const LoadingPage())));
    })));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
          child: Text("Slot Seek",
              style: TextStyle(color: AppColors.textLightorange, fontSize: 40.0))),
    );
  }
}
