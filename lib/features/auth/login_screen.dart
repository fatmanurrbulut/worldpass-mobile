import 'package:flutter/material.dart';

import '../../core/routes/routes.dart';
import '../../core/di/app_di.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/components/wp_form_input.dart';
import '../../ui/components/wp_banner.dart';
import '../../core/network/api_client.dart';
import '../../core/network/token_storage.dart';
import '../../core/network/auth_api.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final ApiClient _apiClient;
  late final AuthApi authApi;

  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  String? topError;
  bool loading = false;
  
  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    authApi = AuthApi(_apiClient);
  }

  @override
  void dispose() {
    email.dispose();
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

    try {
      final res = await authApi.login(
        email: email.text.trim(),
        password: pass.text,
      );

      debugPrint("login res: $res");

      // TODO: token parse edip sakla
      // final token = res["token"] ?? res["access_token"];
      // await tokenStore.setUserToken(token);
      // _apiClient.token = token;

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.homeTabs);
    } catch (e) {
      if (!mounted) return;
      setState(() => topError = "Login failed: $e");
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
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
                  label: "Email",
                  controller: email,
                  validator: (v) {
                    final s = (v ?? "").trim();
                    if (s.isEmpty) return "Email is required";
                    if (!s.contains("@")) return "Enter a valid email";
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
