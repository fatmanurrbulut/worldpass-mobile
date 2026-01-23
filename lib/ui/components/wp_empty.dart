import 'package:flutter/material.dart';

class WpEmpty extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final Widget? action; // "Yeni Ekle" butonu koymak istersen diye
  
  const WpEmpty({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined, // Varsayılan ikon
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0), // Kenarlardan nefes alsın
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // İçerik kadar yer kaplasın
          children: [
            // 1. Soluk, Modern İkon Alanı
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                // Temanın primary renginin çok çok açık hali
                color: colorScheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                // İkon rengi çok baskın olmamalı, gri tonları iyidir
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Başlık (Title)
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),

            // 3. Alt Açıklama (Message) - Varsa göster
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant, // Daha silik yazı
                  height: 1.5,
                ),
              ),
            ],

            // 4. Aksiyon Butonu - Varsa göster
            if (action != null) ...[
              const SizedBox(height: 32),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}