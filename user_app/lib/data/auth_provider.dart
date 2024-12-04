import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  AuthProvider() {
    _loadFromSharedPreferences();
  }

  Future<void> _loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    // Simulate an API call
    await Future.delayed(const Duration(seconds: 2));

    // Assume successful login if email and password are correct
    if (email == "test@example.com" && password == "password") {
      _isLoggedIn = true;
      _token = "example_token_123"; // Replace with actual token from API
      notifyListeners();

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', _isLoggedIn);
      await prefs.setString('token', _token!);
    } else {
      throw Exception("Invalid credentials");
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _token = null;
    notifyListeners();

    // Remove from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('token');
  }
}
