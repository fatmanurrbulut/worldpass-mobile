import 'package:flutter/material.dart';

class WpButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon; // Opsiyonel ikon desteği ekledim, şık durur
  final Color? color;

  const WpButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Tema renklerini alalım
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;

    return SizedBox(
      height: 52, // 48 biraz dar kalabiliyor, 52-56 ideal parmak boyutu
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor, // Yazı ve ikon rengi
          elevation: 0, // Modern "Flat" görünüm için gölgeyi kaldırdık
          disabledBackgroundColor: primaryColor.withOpacity(0.5), // Disabled iken soluk dursun
          disabledForegroundColor: onPrimaryColor.withOpacity(0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Apple vari yumuşak köşeler
          ),
          // Basılınca çıkan efektin rengini ayarlayalım
          overlayColor: onPrimaryColor.withOpacity(0.1), 
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  // Loader rengi her zaman buton metniyle aynı olsun
                  valueColor: AlwaysStoppedAnimation<Color>(onPrimaryColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // Daha tok bir yazı
                      letterSpacing: 0.5, // Harfleri hafif açtık, premium his verir
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}