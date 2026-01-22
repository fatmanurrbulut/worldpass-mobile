import 'package:flutter/material.dart';
import '../../core/routes/routes.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/components/wp_form_input.dart';
import '../../ui/components/wp_banner.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final did = TextEditingController();
  final pass = TextEditingController();
  String? topError;
  bool loading = false;

  @override
  void dispose() {
    did.dispose();
    pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => topError = null);
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) {
      setState(() => topError = "Please fix the highlighted fields.");
      return;
    }

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => loading = false);

    Navigator.pushReplacementNamed(context, AppRoutes.homeTabs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (topError != null) ...[
            WpBanner(text: topError!, icon: Icons.error_outline),
            const SizedBox(height: 10),
          ],
          Form(
            key: formKey,
            child: Column(
              children: [
                WpFormInput(
                  label: "DID (demo)",
                  controller: did,
                  validator: (v) {
                    final s = (v ?? "").trim();
                    if (s.isEmpty) return "DID is required";
                    if (!s.startsWith("did:")) return "DID should start with 'did:'";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                WpFormInput(
                  label: "Password (demo)",
                  controller: pass,
                  obscure: true,
                  validator: (v) {
                    final s = (v ?? "");
                    if (s.length < 4) return "Min 4 chars";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                WpButton(
                  text: "Login",
                  loading: loading,
                  onPressed: loading ? null : _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
