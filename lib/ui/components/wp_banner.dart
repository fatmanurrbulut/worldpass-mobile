import 'package:flutter/material.dart';

class WpBanner extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? color; // Arka plan yerine 'tema rengi' mantığı daha modern durur
  final VoidCallback? onTap; // Belki tıklanabilir yapmak istersin

  const WpBanner({
    super.key,
    required this.text,
    this.icon = Icons.info_outline_rounded, // Daha yumuşak hatlı ikon
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Eğer renk verilmezse temanın ana rengini, verilirse o rengi baz alalım.
    // Turkuaz (WorldPass/Hepta stili) için buraya varsayılan renk de atayabilirsin.
    final themeColor = color ?? Theme.of(context).colorScheme.primary;

    // Arka plan rengi, ana rengin %8-%10 opak hali (iOS style)
    final backgroundColor = themeColor.withOpacity(0.08);
    
    // Kenarlık rengi biraz daha belirgin
    final borderColor = themeColor.withOpacity(0.2);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), // Tıklama efekti taşmasın
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1), // Premium hissiyat için ince çerçeve
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // İkon rengi, temanın kendisi
            Icon(
              icon, 
              size: 20, 
              color: themeColor
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, // Metin okunabilir olsun
                  fontSize: 14,
                  height: 1.4, // Satır arası boşluk (okunabilirlik için kritik)
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}