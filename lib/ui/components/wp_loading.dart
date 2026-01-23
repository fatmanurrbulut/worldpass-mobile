import 'package:flutter/material.dart';

class WpLoading extends StatelessWidget {
  final String? text;
  final double size; // Boyutu dışarıdan yönetebilelim
  final Color? color; // Özel renk verme opsiyonu

  const WpLoading({
    super.key,
    this.text,
    this.size = 40.0, // Varsayılan boyut ideal
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loader Stack'i (Arka iz + Dönen halka)
          SizedBox(
            width: size,
            height: size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Arkadaki Sabit Halka (Track)
                CircularProgressIndicator(
                  value: 1.0, // Tam dolu
                  strokeWidth: 3, // İnce ve zarif
                  color: primaryColor.withOpacity(0.15), // Çok silik tema rengi
                ),
                // 2. Öndeki Dönen Halka
                CircularProgressIndicator(
                  strokeWidth: 3,
                  color: primaryColor,
                  strokeCap: StrokeCap.round, // Uçları yuvarlatılmış (Modern dokunuş)
                ),
              ],
            ),
          ),
          
          // Metin Alanı
          if (text != null) ...[
            const SizedBox(height: 16),
            Text(
              text!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant, // Göz yormayan gri tonu
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ]
        ],
      ),
    );
  }
}