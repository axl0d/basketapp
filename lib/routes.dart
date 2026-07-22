import 'package:flutter/material.dart';
import 'package:basketapp/features/auth/presentation/pages/login_page.dart';
import 'package:basketapp/features/auth/presentation/pages/register_page.dart';
import 'package:basketapp/features/auth/presentation/pages/splash_page.dart';
import 'package:basketapp/features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashPage(),
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      home: (context) => const HomePage(),
    };
  }
}
