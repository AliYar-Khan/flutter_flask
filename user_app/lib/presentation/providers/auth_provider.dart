// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final GetUsers getUsers;

  String? _token;
  bool _isLoading = false;
  List<User>? _users;

  String? get token => _token;
  bool get isLoading => _isLoading;
  List<User>? get users => _users;

  AuthProvider({
    required this.loginUser,
    required this.registerUser,
    required this.getUsers,
  }) {
    getToken();
  }

  Future<void> getToken() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _token = sp.getString("access_token") ?? '';
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await loginUser(email, password);
    print("result --->  $result");
    result.fold(
      (failure) => print('Login Failed -> failure'),
      (token) async {
        print("token ---> $token");
        SharedPreferences sp = await SharedPreferences.getInstance();
        await sp.setString("access_token", token);
        _token = token;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password,
      String phone, String address) async {
    _isLoading = true;
    notifyListeners();

    final result = await registerUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address);
    result.fold(
      (failure) => print('Registration Failed'),
      (_) => print('Registration Successful'),
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    if (_token == null) {
      print('No token found');
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await getUsers(_token!);
    result.fold(
      (failure) => print('Failed to fetch users'),
      (userList) {
        print("userslist --->${userList.map((e) => e.toJson())}");
        _users = userList;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    SharedPreferences.getInstance().then((sp) {
      sp.remove('access_token');
      _token = '';
      _users?.clear();
    });
  }
}
