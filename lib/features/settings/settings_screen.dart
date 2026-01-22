import 'package:flutter/material.dart';
import '../../ui/components/wp_button.dart';
import '../issuer/issuer_login_screen.dart';
import '../../ui/components/nav_animate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text("Profile / 2FA later (Kişi 2)"),
            const SizedBox(height: 12),
            WpButton(
              text: "Go to Issuer Mode (demo)",
              onPressed: () {
                Navigator.push(
                  context,
                  wpRoute(const IssuerLoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
