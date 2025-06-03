import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../viewmodels/splash_viewmodel.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _viewModel = SplashViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.init(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/animations/splash1.json',
            width: 200, height: 200),
      ),
    );
  }
}
