import 'package:flutter/material.dart';
import '../../core/routes/routes.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/components/wp_form_input.dart';
import '../../ui/components/wp_banner.dart';
import '../../ui/theme/app_tokens.dart'; // Spacing ve Tokenlar

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final didController = TextEditingController();
  final passController = TextEditingController();
  
  String? topError;
  bool loading = false;

  @override
  void dispose() {
    didController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();
    
    setState(() => topError = null);
    
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) {
      // Form hatası varsa banner göstermeye gerek yok, inputlar kızarıyor zaten
      // Ama genel bir uyarı istersen:
      // setState(() => topError = "Lütfen hatalı alanları kontrol edin.");
      return;
    }

    setState(() => loading = true);
    
    // Simüle edilmiş backend isteği
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (!mounted) return;
    setState(() => loading = false);

    // Başarılı giriş
    Navigator.pushReplacementNamed(context, AppRoutes.homeTabs);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // AppBar'ı kaldırdık veya şeffaf yaptık, daha modern dursun
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Logo ve Başlık Alanı
                  Icon(
                    Icons.fingerprint_rounded, // WorldPass için uygun bir ikon
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  Text(
                    "WorldPass Giriş",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    "Dijital kimliğinizle güvenli erişim.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // 2. Hata Bannerı (Varsa görünür)
                  if (topError != null) ...[
                    WpBanner(
                      text: topError!, 
                      icon: Icons.error_outline_rounded,
                      color: theme.colorScheme.error, // Kırmızı tema
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // 3. Giriş Alanları
                  WpFormInput(
                    label: "Dijital Kimlik (DID)",
                    hint: "did:worldpass:...",
                    controller: didController,
                    prefixIcon: Icons.alternate_email_rounded, // @ veya kimlik ikonu
                    keyboardType: TextInputType.text,
                    validator: (v) {
                      final s = (v ?? "").trim();
                      if (s.isEmpty) return "DID adresi gereklidir.";
                      if (!s.startsWith("did:")) return "Geçersiz format ('did:' ile başlamalı)";
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  WpFormInput(
                    label: "Şifre",
                    controller: passController,
                    obscure: true, // Göz ikonu otomatik geliyor
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: (v) {
                      final s = (v ?? "");
                      if (s.length < 4) return "Şifre en az 4 karakter olmalı.";
                      return null;
                    },
                  ),
                  
                  // "Şifremi Unuttum" linki eklenebilir
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Yardım?",
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // 4. Aksiyon Butonu
                  WpButton(
                    text: "Giriş Yap",
                    loading: loading,
                    onPressed: _submit,
                    icon: Icons.login_rounded, // İkonlu buton daha şık
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // 5. Kayıt Ol (Alt Footer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hesabınız yok mu? ",
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Kayıt sayfasına git
                        },
                        child: Text(
                          "Kimlik Oluştur",
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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