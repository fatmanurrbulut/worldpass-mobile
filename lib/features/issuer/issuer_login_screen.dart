import 'package:flutter/material.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/components/wp_input.dart';
import 'issuer_home_screen.dart';

class IssuerLoginScreen extends StatefulWidget {
  const IssuerLoginScreen({super.key});

  @override
  State<IssuerLoginScreen> createState() => _IssuerLoginScreenState();
}

class _IssuerLoginScreenState extends State<IssuerLoginScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Issuer Login")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          WpInput(label: "Email", controller: email),
          const SizedBox(height: 10),
          WpInput(label: "Password", controller: pass, obscure: true),
          const SizedBox(height: 12),
          WpButton(
            text: loading ? "Signing in..." : "Login (demo)",
            loading: loading,
            onPressed: () async {
              setState(() => loading = true);
              await Future.delayed(const Duration(milliseconds: 600));
              if (!context.mounted) return;
              setState(() => loading = false);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const IssuerHomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
