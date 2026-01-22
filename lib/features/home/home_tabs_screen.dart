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
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.wallet), label: "Wallet"),
          NavigationDestination(icon: Icon(Icons.qr_code), label: "Present"),
          NavigationDestination(icon: Icon(Icons.verified), label: "Verify"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
