import 'package:flutter/material.dart';

Route<T> wpRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    // Geçiş süresini hafif artırarak o "tok" hissi verelim (iOS standardı ~350-400ms)
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300), 
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, anim, secondaryAnim, child) {
      // Daha modern, "yay" gibi bir ivme eğrisi
      final curve = CurvedAnimation(
        parent: anim, 
        curve: Curves.fastLinearToSlowEaseIn, // Apple tarzı "hızlı başla yavaş dur"
        reverseCurve: Curves.easeInToLinear,
      );

      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0), // Hafif sağdan geliş
            end: Offset.zero,
          ).animate(curve),
          child: ScaleTransition(
            // Çok hafif bir büyüme efekti (%95'ten %100'e)
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curve),
            child: child,
          ),
        ),
      );
    },
  );
}