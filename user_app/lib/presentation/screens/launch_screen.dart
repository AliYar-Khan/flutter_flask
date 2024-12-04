// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/auth_provider.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    Future.delayed(Duration.zero, () {
      if (authProvider.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your image path
              height: 150,
              width: 150,
            ),
            const SizedBox(
              height: 10,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
