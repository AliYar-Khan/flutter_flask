import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/launch');
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Replace with your image path
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
