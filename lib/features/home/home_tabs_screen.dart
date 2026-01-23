import 'package:flutter/material.dart';
import '../wallet/wallet_screen.dart';
import '../present/present_screen.dart';
import '../verify/verify_screen.dart';
import '../settings/settings_screen.dart';

class HomeTabsScreen extends StatefulWidget {
  const HomeTabsScreen({super.key});

  @override
  State<HomeTabsScreen> createState() => _HomeTabsScreenState();
}

class _HomeTabsScreenState extends State<HomeTabsScreen> {
  int index = 0;

  final pages = const [
    WalletScreen(),
    PresentScreen(),
    VerifyScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Sayfa Geçiş Animasyonu
      // Bu widget, içindeki child değiştiğinde otomatik animasyon yapar.
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350), // 350ms
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        // Geçiş efekti: Sadece Fade değil, hafif de zoom/scale ekleyebilirsin
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: KeyedSubtree(
          // Her sayfanın unique bir key'i olmalı ki animasyon çalışsın
          key: ValueKey<int>(index), 
          child: pages[index],
        ),
      ),
      
      bottomNavigationBar: Container(
        // Üst tarafa ince bir çizgi (Border) ekleyerek ayrımı netleştirelim
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => setState(() => index = i),
          
          // Arka plan rengi (Hafif saydamlık modern durur ama performance cost olabilir, düz renk güvenlidir)
          backgroundColor: theme.colorScheme.surface, 
          
          // Seçili öğenin arkasındaki balonun rengi
          indicatorColor: theme.colorScheme.primary.withOpacity(0.15),
          
          // Material 3 yüksekliğini biraz daha kompakt yapabiliriz (Opsiyonel)
          height: 70, 
          
          // İkonların tıklanma animasyonunu biraz yumuşatalım
          animationDuration: const Duration(milliseconds: 350),
          
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined), // Seçili Değilken
              selectedIcon: Icon(Icons.account_balance_wallet),  // Seçiliyken (Dolu)
              label: "Cüzdan",
            ),
            NavigationDestination(
              icon: Icon(Icons.qr_code_2_outlined),
              selectedIcon: Icon(Icons.qr_code_2),
              label: "Sunum",
            ),
            NavigationDestination(
              icon: Icon(Icons.verified_user_outlined),
              selectedIcon: Icon(Icons.verified_user),
              label: "Doğrula",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: "Ayarlar",
            ),
          ],
        ),
      ),
    );
  }
}