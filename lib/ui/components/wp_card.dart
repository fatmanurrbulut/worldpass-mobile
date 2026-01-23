import 'package:flutter/material.dart';
import '../theme/app_tokens.dart'; // Token'larını korudum

class WpCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin; // Dış boşluk ihtiyacı olabilir
  final VoidCallback? onTap; // Kart tıklanabilir olabilir
  final Color? customBgColor; // Özel renk verme ihtimaline karşı

  const WpCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.customBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Arka plan rengi: Eğer verilmediyse ve Dark mode ise daha "surface" bir renk,
    // Light mode ise bembeyaz.
    final bgColor = customBgColor ?? theme.colorScheme.surface;

    // Border Rengi:
    // Dark Mode'da: Çok hafif beyaz (%10) - Bu "cam" etkisi yaratır.
    // Light Mode'da: Çok silik gri (%5) veya hiç yok (sadece gölge).
    final borderColor = isDark 
        ? Colors.white.withOpacity(0.08) 
        : theme.colorScheme.outlineVariant.withOpacity(0.4);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadii.md), // Senin token
        border: Border.all(
          color: borderColor,
          width: 1, // İnce ve zarif
        ),
        boxShadow: [
          // Katmanlı Gölge (Layered Shadow) Tekniği
          // 1. Ortam Gölgesi (Ambient): Geniş ve çok silik
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          // 2. Doğrudan Gölge (Direct): Daha keskin ve yakın
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      // Clip.antiAlias: İçine resim veya taşan bir şey koyarsan köşeleri yuvarlar
      clipBehavior: Clip.antiAlias, 
      child: Material(
        color: Colors.transparent, // Efektin arkasındaki renk
        child: InkWell(
          // Eğer onTap varsa tıklama efekti (ripple) çalışır, yoksa çalışmaz
          onTap: onTap,
          splashColor: theme.colorScheme.primary.withOpacity(0.05),
          highlightColor: theme.colorScheme.primary.withOpacity(0.02),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg), // Senin token
            child: child,
          ),
        ),
      ),
    );
  }
}