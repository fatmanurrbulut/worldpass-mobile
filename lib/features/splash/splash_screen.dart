import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/routes/routes.dart';
import '../../ui/theme/app_tokens.dart'; // Spacing ve Font ayarları için

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    // 1. Animasyon Ayarları (2 saniye sürsün, keyifli bir giriş olsun)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Fade In (Görünürlük)
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Scale Up (Hafif büyüme efekti)
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Animasyonu başlat
    _controller.forward();

    // 2. Yönlendirme Mantığı
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Animasyon süresi + biraz bekleme payı (Kullanıcı logoyu görsün)
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (!mounted) return;
    
    // Login ekranına geçiş
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Arka plan rengi tema ile uyumlu olsun
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // MERKEZDEKİ LOGO VE İSİM
          Center(
            child: FadeTransition(
              opacity: _opacityAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 1. Logo Alanı
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.fingerprint_rounded, // WorldPass imzası
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.xl),
                    
                    // 2. Uygulama Adı
                    Text(
                      "WorldPass",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    
                    SizedBox(height: AppSpacing.xs),
                    
                    // 3. Slogan
                    Text(
                      "Global Digital Identity",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 2, // Harfleri açarak premium hava veriyoruz
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ALTTAKİ İMZA (Footer)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _opacityAnim,
              child: Column(
                children: [
                  Text(
                    "Powered by",
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hub_rounded, // Heptapus'u simgeleyen bir ağ ikonu
                        size: 14,
                        color: theme.colorScheme.primary.withOpacity(0.8),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Heptapus Group",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}