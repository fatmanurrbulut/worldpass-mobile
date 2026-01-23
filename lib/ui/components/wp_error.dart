import 'package:flutter/material.dart';
import 'wp_button.dart';

class WpError extends StatelessWidget {
  final String text; // Teknik hata mesajı
  final String title; // Kullanıcı dostu başlık
  final VoidCallback? onRetry;
  final String retryText; // Buton metni özelleştirilebilir olsun

  const WpError({
    super.key,
    required this.text,
    this.title = "Bir Hata Oluştu", // Varsayılan başlık
    this.onRetry,
    this.retryText = "Tekrar Dene",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Hata İkonu (Kırmızımsı, yumuşak arkaplanlı)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // Hata renginin %10 opak hali (çok soft kırmızı)
                color: colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: colorScheme.error, // İkonun kendisi belirgin kırmızı
              ),
            ),
            const SizedBox(height: 24),

            // 2. Ana Başlık
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            // 3. Detaylı Hata Mesajı (Daha silik)
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),

            // 4. Aksiyon Butonu
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              SizedBox(
                width: 200, // Buton çok yayılmasın, şık dursun
                child: WpButton(
                  text: retryText,
                  onPressed: onRetry,
                  // İstersen butonun rengini de hata rengi yapabilirsin
                  // ama genelde primary kalması daha sakin hissettirir.
                  // icon: Icons.refresh_rounded, // İkon desteği eklemiştik, kullanabilirsin
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}