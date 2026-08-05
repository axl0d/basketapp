import 'package:basketapp/core/di/service_locator.dart';
import 'package:basketapp/core/notifications/bloc/notification_bloc.dart';
import 'package:basketapp/core/theme/app_theme.dart';
import 'package:basketapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:basketapp/features/auth/presentation/pages/login_page.dart';
import 'package:basketapp/features/auth/presentation/pages/register_page.dart';
import 'package:basketapp/features/auth/presentation/pages/splash_page.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:basketapp/features/home/presentation/pages/home_page.dart';
import 'package:basketapp/features/products/presentation/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
        BlocProvider<CartBloc>(create: (context) => getIt<CartBloc>()),
        BlocProvider<NotificationBloc>(
          create: (context) => getIt<NotificationBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'BasketApp',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginPage());
            case '/register':
              return MaterialPageRoute(builder: (_) => const RegisterPage());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomePage());
            case '/product':
              final productId = settings.arguments as String?;
              return MaterialPageRoute(
                builder: (_) =>
                    ProductDetailScreen(productId: productId ?? '1'),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
