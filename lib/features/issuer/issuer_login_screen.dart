import 'package:flutter/material.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/components/wp_form_input.dart'; // WpInput yerine daha yetenekli olanı kullandık
import '../../ui/theme/app_tokens.dart'; // Spacing
import 'issuer_home_screen.dart';

class IssuerLoginScreen extends StatefulWidget {
  const IssuerLoginScreen({super.key});

  @override
  State<IssuerLoginScreen> createState() => _IssuerLoginScreenState();
}

class _IssuerLoginScreenState extends State<IssuerLoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  
  // GlobalKey form validasyonu için (Gerekirse)
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();

    setState(() => loading = true);
    
    // Simüle edilmiş ağ gecikmesi
    await Future.delayed(const Duration(milliseconds: 800));

    if (!context.mounted) return;
    setState(() => loading = false);

    // Standart geçiş
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const IssuerHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // AppBar koymadık, temiz bir tam ekran deneyimi olsun.
      // Geri dönmek gerekirse sol üstte küçük bir buton koyulabilir.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true, 
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400), // Geniş ekranlarda yayılmasın
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header / Logo Alanı
                  Icon(
                    Icons.business_center_rounded, // Kurumsal hissi veren ikon
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  
                  Text(
                    "Issuer Portal",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "Kurumsal kimlik yönetim paneline hoş geldiniz.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.xxl), // 32px boşluk

                  // 2. Form Alanları
                  AutofillGroup( // Otomatik doldurma desteği
                    child: Column(
                      children: [
                        WpFormInput(
                          label: "E-posta Adresi",
                          hint: "admin@kurum.com",
                          controller: emailController,
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          // Klavye "İleri" desin
                          // textInputAction: TextInputAction.next, 
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        WpFormInput(
                          label: "Şifre",
                          controller: passController,
                          obscure: true, // Şifre gizleme/gösterme özelliği içinde var
                          prefixIcon: Icons.lock_outline_rounded,
                          // Klavye "Tamam" desin
                          // textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 3. Giriş Butonu
                  WpButton(
                    text: "Giriş Yap",
                    loading: loading,
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 4. Alt Linkler (Şifremi Unuttum vs.)
                  TextButton(
                    onPressed: () {
                      // Şifre sıfırlama akışı
                    },
                    child: Text(
                      "Şifrenizi mi unuttunuz?",
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}