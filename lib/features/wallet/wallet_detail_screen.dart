import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/credential.dart';
import '../../ui/components/wp_card.dart';
import '../../ui/theme/app_tokens.dart'; // Spacing & Radii

class WalletDetailScreen extends StatelessWidget {
  final Credential vc;
  const WalletDetailScreen({super.key, required this.vc});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // JSON'ı güzel formatla
    final prettyJson = const JsonEncoder.withIndent("  ").convert(vc.rawJson);
    
    // Kart rengini belirle
    final cardColor = _getCardColor(vc.type);
    final cardIcon = _getCardIcon(vc.type);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kimlik Detayı"),
        actions: [
          // Silme Butonu
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: theme.colorScheme.error,
            onPressed: () {
              // Silme diyaloğu açılabilir
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.lg),
        children: [
          // 1. DİJİTAL KART GÖRÜNÜMÜ (Hero Section)
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cardColor, cardColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20), // Kredi kartı kavisleri
              boxShadow: [
                BoxShadow(
                  color: cardColor.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Üst: Tip ve İkon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      vc.type.first.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 14,
                      ),
                    ),
                    Icon(cardIcon, color: Colors.white, size: 32),
                  ],
                ),
                // Orta: WorldPass Logosu (Watermark gibi)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.fingerprint, 
                    color: Colors.white12, 
                    size: 80,
                  ),
                ),
                // Alt: Veren Kurum ve Tarih
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vc.issuer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Issued: ${vc.issuanceDate}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // 2. KİMLİK BİLGİLERİ (Claims)
          _SectionHeader(title: "KİMLİK VERİLERİ"),
          WpCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ...vc.rawJson.entries.map((e) {
                  return _DetailRow(
                    label: _formatKey(e.key),
                    value: e.value.toString(),
                  );
                }),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // 3. METADATA (Süre ve Durum)
          _SectionHeader(title: "DURUM & GEÇERLİLİK"),
          WpCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _StatusRow(
                  icon: Icons.check_circle_rounded,
                  color: Colors.green,
                  label: "Durum",
                  value: "Aktif / Geçerli",
                ),
                const Divider(height: 24, thickness: 0.5),
                _StatusRow(
                  icon: Icons.calendar_today_rounded,
                  color: theme.colorScheme.primary,
                  label: "Son Geçerlilik",
                  value: vc.expirationDate ?? "Süresiz",
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // 4. TEKNİK DETAYLAR (DID ve JSON)
          _SectionHeader(title: "TEKNİK DETAYLAR"),
          WpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DID Alanı
                const Text(
                  "Subject DID",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          vc.subjectDid,
                          style: TextStyle(
                            fontFamily: 'RobotoMono',
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: vc.subjectDid));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("DID kopyalandı")),
                          );
                        },
                        child: Icon(Icons.copy_rounded, size: 16, color: theme.colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Ham JSON Alanı (Expandable yapılabilir ama şimdilik açık kalsın)
                const Text(
                  "Raw Credential Data",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    prettyJson,
                    style: const TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 11,
                      color: Color(0xFFCE9178), // VS Code string rengi
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- Helper Methods ---

  Color _getCardColor(List<String> types) {
    if (types.contains("StudentCard")) return const Color(0xFF0D47A1); // Koyu Mavi
    if (types.contains("Membership")) return const Color(0xFF7B1FA2); // Mor
    if (types.contains("EventTicket")) return const Color(0xFFC62828); // Kırmızı
    return const Color(0xFF00695C); // Varsayılan Teal
  }

  IconData _getCardIcon(List<String> types) {
    if (types.contains("StudentCard")) return Icons.school;
    if (types.contains("Membership")) return Icons.card_membership;
    return Icons.badge;
  }

  String _formatKey(String key) {
    // "studentNo" -> "Student No" yapalım basitçe
    if (key == "studentNo") return "Öğrenci No";
    if (key == "org") return "Organizasyon";
    return key[0].toUpperCase() + key.substring(1);
  }
}

// --- Alt Widgetlar ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatusRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        )
      ],
    );
  }
}