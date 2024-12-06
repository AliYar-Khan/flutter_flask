import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/launch_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/home_screen.dart';

import 'data/datasources/remote_data_source.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/register_user.dart';
import 'domain/usecases/get_users.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = RemoteDataSourceImpl(http.Client());
    final userRepository = UserRepositoryImpl(remoteDataSource);

    final loginUser = LoginUser(userRepository);
    final registerUser = RegisterUser(userRepository);
    final getUsers = GetUsers(userRepository);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUser: loginUser,
            registerUser: registerUser,
            getUsers: getUsers,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/launch': (context) => const LaunchScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/users': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
