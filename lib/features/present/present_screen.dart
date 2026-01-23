import 'package:flutter/material.dart';
import '../../core/models/credential.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/components/wp_card.dart';
import '../../ui/components/wp_banner.dart'; // Bilgilendirme için
import '../../ui/components/nav_animate.dart'; // Geçiş animasyonu
import '../../ui/theme/app_tokens.dart'; // Spacing
import 'present_qr_screen.dart';

class PresentScreen extends StatefulWidget {
  const PresentScreen({super.key});

  @override
  State<PresentScreen> createState() => _PresentScreenState();
}

class _PresentScreenState extends State<PresentScreen> {
  // Demo Veriler
  final vcs = <Credential>[
    Credential(
      id: "vc_001",
      type: ["StudentCard"],
      issuer: "WorldPass Issuer",
      issuanceDate: "2026-01-01",
      expirationDate: null,
      subjectDid: "did:worldpass:123",
      rawJson: {"name": "Mathis", "school": "IKÇÜ", "studentNo": "2020xxxx"},
    ),
    Credential(
      id: "vc_002",
      type: ["Membership"],
      issuer: "IEEE IKÇÜ",
      issuanceDate: "2026-01-10",
      expirationDate: "2027-01-10",
      subjectDid: "did:worldpass:123",
      rawJson: {"org": "IEEE", "role": "Member", "since": "2024"},
    ),
  ];

  int selectedIndex = 0;
  Map<String, bool> selectedFields = {};

  @override
  void initState() {
    super.initState();
    _syncFieldsForSelectedVc();
  }

  void _syncFieldsForSelectedVc() {
    final vc = vcs[selectedIndex];
    final keys = vc.rawJson.keys.toList()..sort();

    final next = <String, bool>{};
    for (final k in keys) {
      // Daha önce bir tercih varsa koru, yoksa varsayılan olarak seçili yap
      next[k] = selectedFields[k] ?? true;
    }

    setState(() => selectedFields = next);
  }

  // Helper: Kimlik tipine göre ikon
  IconData _getIconForType(List<String> types) {
    if (types.contains("StudentCard")) return Icons.school_rounded;
    if (types.contains("Membership")) return Icons.card_membership_rounded;
    return Icons.badge_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vc = vcs[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kimlik Sunumu"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // 1. GÜVENLİK UYARISI
          const WpBanner(
            text: "Seçici İfşa (Selective Disclosure) aktiftir. Karşı tarafla paylaşmak istemediğiniz bilgilerin işaretini kaldırabilirsiniz.",
            icon: Icons.privacy_tip_rounded,
            // color: Colors.teal, // Varsayılan turkuaz kalsın
          ),
          
          SizedBox(height: AppSpacing.xl),

          // 2. KİMLİK SEÇİMİ
          Text(
            "KİMLİK KAYNAĞI",
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          
          WpCard(
            padding: EdgeInsets.zero,
            child: DropdownButtonFormField<int>(
              value: selectedIndex,
              isDense: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                prefixIcon: Icon(
                  _getIconForType(vc.type),
                  color: theme.colorScheme.primary,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              isExpanded: true,
              
              // ÇÖZÜM BURADA: selectedItemBuilder
              // Bu fonksiyon, kutu KAPALIYKEN ne görüneceğini belirler.
              // Biz burada Column yerine tek satır (Row) kullanarak 24px yüksekliğe sığıyoruz.
              selectedItemBuilder: (BuildContext context) {
                return vcs.map<Widget>((Credential x) {
                  return Row(
                    children: [
                      Text(
                        x.type.first,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      // Issuer bilgisini yanına silik bir şekilde ekliyoruz
                      Expanded(
                        child: Text(
                          "• ${x.issuer}",
                          overflow: TextOverflow.ellipsis, // Sığmazsa ... koy
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList();
              },

              // Liste AÇIKKEN görünecek öğeler (Burada 2 satır kalabilir, yerimiz bol)
              items: List.generate(vcs.length, (i) {
                final x = vcs[i];
                return DropdownMenuItem(
                  value: i,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // Sıkıştır
                    children: [
                      Text(
                        x.type.first,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        x.issuer,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              onChanged: (v) {
                if (v == null) return;
                setState(() => selectedIndex = v);
                _syncFieldsForSelectedVc();
              },
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 3. VERİ SEÇİMİ (Toggle List)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "PAYLAŞILACAK VERİLER",
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1,
                ),
              ),
              // Opsiyonel: Tümünü seç/kaldır butonu eklenebilir
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          WpCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                if (selectedFields.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Bu kimlikte paylaşılabilir veri bulunamadı.",
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ...selectedFields.entries.map((e) {
                  return CheckboxListTile(
                    title: Text(
                      e.key.toUpperCase(), // "NAME", "SCHOOL"
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      vc.rawJson[e.key]?.toString() ?? "",
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    value: e.value,
                    activeColor: theme.colorScheme.primary,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    // Checkbox şeklini biraz modernize edelim
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (v) => setState(() => selectedFields[e.key] = v ?? false),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),

          // 4. AKSİYON BUTONU
          WpButton(
            text: "QR Kodu Oluştur",
            icon: Icons.qr_code_2_rounded,
            // Hiçbir şey seçilmediyse butonu pasife alabiliriz
            onPressed: selectedFields.values.contains(true) 
                ? () {
                    final disclosed = <String, dynamic>{};
                    for (final e in selectedFields.entries) {
                      if (e.value && vc.rawJson.containsKey(e.key)) {
                        disclosed[e.key] = vc.rawJson[e.key];
                      }
                    }

                    final payload = <String, dynamic>{
                      "vcId": vc.id,
                      "type": vc.type,
                      "issuer": vc.issuer,
                      "subjectDid": vc.subjectDid,
                      "disclosed": disclosed,
                      "timestamp": DateTime.now().toIso8601String(), // Zaman damgası ekledim
                    };

                    Navigator.push(
                      context,
                      wpRoute(PresentQrScreen(payload: payload)),
                    );
                  }
                : null, // Hiçbir veri seçilmediyse buton disabled
          ),
          
          // Yardımcı metin
          if (!selectedFields.values.contains(true))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Devam etmek için en az bir veri alanı seçmelisiniz.",
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}