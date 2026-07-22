import 'package:basketapp/core/di/service_locator.dart';
import 'package:basketapp/core/theme/app_theme.dart';
import 'package:basketapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:basketapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:basketapp/features/auth/presentation/pages/login_page.dart';
import 'package:basketapp/features/auth/presentation/pages/register_page.dart';
import 'package:basketapp/features/auth/presentation/pages/splash_page.dart';
import 'package:basketapp/features/home/presentation/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => getIt<AuthBloc>(),
      child: MaterialApp(
        title: 'BasketApp',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomePage();
            } else if (state is AuthUnauthenticated) {
              return const LoginPage();
            }
            return const SplashPage();
          },
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterPage());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomePage());
            default:
              return null;
          }
        },
      ),
    );
  }
}
