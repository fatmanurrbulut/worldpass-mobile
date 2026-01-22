import 'package:flutter/material.dart';
import 'core/routes/routes.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_tabs_screen.dart';
import 'ui/theme/app_theme.dart';

void main() {
  runApp(const WorldPassApp());
}

class WorldPassApp extends StatelessWidget {
  const WorldPassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      theme: AppTheme.light(),
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.homeTabs: (_) => const HomeTabsScreen(),
      },
    );
  }
}
