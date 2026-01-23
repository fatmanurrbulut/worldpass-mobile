import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Status Bar ayarı için gerekli
import 'core/routes/routes.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_tabs_screen.dart';
import 'ui/theme/app_theme.dart';

void main() {
  // Flutter motorunu başlat
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Status Bar (Üst Çubuk) Ayarı
  // Uygulamayı "Edge-to-Edge" (Tam ekran) hissettirmek için çubuğu şeffaf yapıyoruz.
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Arka plan şeffaf
    statusBarIconBrightness: Brightness.dark, // İkonlar koyu (açılış için)
    systemNavigationBarColor: Colors.transparent, // Android alt çubuk (opsiyonel)
  ));

  // 2. Sadece Dikey Mod (Opsiyonel ama genelde mobil cüzdanlar dikey olur)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const WorldPassApp());
}

class WorldPassApp extends StatelessWidget {
  const WorldPassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Uygulama Başlığı (Task Manager'da görünür)
      title: 'WorldPass',
      
      // Debug bandını kaldır
      debugShowCheckedModeBanner: false,
      
      // 3. TEMA AYARLARI (Kritik Nokta)
      // Aydınlık Mod
      theme: AppTheme.light(),
      // Karanlık Mod (Bunu eklemezsek gece modu çalışmaz)
      darkTheme: AppTheme.dark(),
      // Sistemin ayarına göre otomatik geçiş yap (Auto / Light / Dark)
      themeMode: ThemeMode.system,
      
      // Başlangıç Rotası
      initialRoute: AppRoutes.splash,
      
      // Rotalar
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.homeTabs: (_) => const HomeTabsScreen(),
      },
      
      // Font Ölçekleme (Erişilebilirlik)
      // Kullanıcı telefonun fontunu devasa yapsa bile tasarımın patlamaması için sınır koyabilirsin
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}