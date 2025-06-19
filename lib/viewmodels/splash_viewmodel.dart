import 'dart:async';
import 'package:flutter/material.dart';
import '../views/home_screen.dart';

class SplashViewModel {
  void init(BuildContext context) {
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }
}
