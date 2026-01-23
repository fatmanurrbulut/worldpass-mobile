import 'package:flutter/material.dart';
import '../../../core/models/credential.dart';
import '../../../ui/theme/app_tokens.dart';

class VcCardTile extends StatelessWidget {
  final Credential vc;
  final VoidCallback? onTap; // Tıklama özelliği eklenebilir

  const VcCardTile({super.key, required this.vc, this.onTap});

  // Karta özel renk belirleme
  Color _getColorForType(BuildContext context) {
    final t = vc.type.join(" ").toLowerCase();
    if (t.contains("student")) return Colors.blue.shade600;
    if (t.contains("member")) return Colors.purple.shade500;
    if (t.contains("ticket") || t.contains("event")) return Colors.orange.shade600;
    if (t.contains("admin") || t.contains("staff")) return Colors.red.shade600;
    return Theme.of(context).colorScheme.primary; // Varsayılan Turkuaz
  }

  // Karta özel ikon
  IconData _iconForType() {
    final t = vc.type.join(" ").toLowerCase();
    if (t.contains("student")) return Icons.school_rounded;
    if (t.contains("member")) return Icons.card_membership_rounded;
    if (t.contains("ticket") || t.contains("event")) return Icons.confirmation_number_rounded;
    if (t.contains("admin")) return Icons.admin_panel_settings_rounded;
    return Icons.badge_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColorForType(context);
    final isExpired = vc.expirationDate != null; // Basit mantık (Tarih kontrolü eklenebilir)

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            // 1. SOL İKON ALANI (Renkli & Modern)
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.md), // 12-16px
                color: color.withOpacity(0.1), // Rengin %10'u kadar opak arka plan
              ),
              child: Icon(
                _iconForType(),
                color: color, // İkonun kendisi tam renk
                size: 24,
              ),
            ),
            
            const SizedBox(width: AppSpacing.md),
            
            // 2. ORTA BİLGİ ALANI
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kart Tipi (Başlık)
                  Text(
                    vc.type.join(", "),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Veren Kurum (Alt Başlık)
                  Row(
                    children: [
                      // Küçük bir ikon ekleyerek kurumsallığı vurgulayalım
                      Icon(Icons.verified_rounded, 
                           size: 12, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          vc.issuer,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: AppSpacing.md),
            
            // 3. SAĞ DURUM ETİKETİ (Status Badge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.full), // Tam yuvarlak (hap)
                // Süreliyse turuncu, süresizse (ömür boyu) yeşil/mavi
                color: isExpired 
                    ? theme.colorScheme.surfaceContainerHighest 
                    : Colors.green.withOpacity(0.1),
                border: Border.all(
                  color: isExpired 
                      ? Colors.transparent 
                      : Colors.green.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                vc.expirationDate == null ? "Süresiz" : "Aktif", // Mantığı düzelttim
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isExpired 
                      ? theme.colorScheme.onSurfaceVariant 
                      : Colors.green.shade700,
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // İpucu Oku (Tıklanabilir hissi için)
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }
}