import 'package:flutter/material.dart';
import '../../ui/components/wp_card.dart';
import '../../ui/components/wp_empty.dart'; // Boş durum için
import '../../ui/components/wp_banner.dart'; // Bilgi bannerı için
import '../../ui/theme/app_tokens.dart'; // Boşluklar için

class IssuerHomeScreen extends StatelessWidget {
  const IssuerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Veri Modeli (Gerçek uygulamada burası API'den gelir)
    final issued = [
      {
        "type": "StudentCard", 
        "subject": "did:worldpass:111...8f2a", 
        "date": "2026-01-01",
        "status": "Active"
      },
      {
        "type": "Membership", 
        "subject": "did:worldpass:222...b1c4", 
        "date": "2026-01-10",
        "status": "Pending"
      },
      {
        "type": "EventTicket", 
        "subject": "did:worldpass:333...9d12", 
        "date": "2026-01-22",
        "status": "Expired"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text("İhraç Edilenler"),
            Text(
              "Kurum Paneli",
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.logout_rounded),
            tooltip: "Çıkış Yap",
          )
        ],
      ),
      // Yeni Ekleme Butonu (Issuer için kritik)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_card_rounded),
        label: const Text("Yeni Belge"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: issued.isEmpty
          ? const WpEmpty(
              title: "Henüz Belge Yok",
              message: "Kurumunuz tarafından ihraç edilmiş herhangi bir kimlik veya belge bulunmuyor.",
              icon: Icons.dashboard_customize_outlined,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg), // 16px boşluk
              itemCount: issued.length + 1, // +1 Banner için
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) {
                // 0. indexe bir özet bannerı koyalım, şık durur
                if (i == 0) {
                  return const WpBanner(
                    text: "Son 30 günde 12 yeni kimlik ihraç edildi.",
                    icon: Icons.insights_rounded,
                  );
                }

                final item = issued[i - 1]; // Banner yüzünden index kaydı
                return _buildCredentialCard(context, item);
              },
            ),
    );
  }

  Widget _buildCredentialCard(BuildContext context, Map<String, String> item) {
    final theme = Theme.of(context);
    
    // Tipe göre ikon ve renk belirleme (Helper mantığı)
    IconData iconData;
    Color color;
    
    switch (item["type"]) {
      case "StudentCard":
        iconData = Icons.school_rounded;
        color = Colors.orange;
        break;
      case "Membership":
        iconData = Icons.card_membership_rounded;
        color = Colors.blue;
        break;
      case "EventTicket":
        iconData = Icons.confirmation_number_rounded;
        color = Colors.purple;
        break;
      default:
        iconData = Icons.description_rounded;
        color = Colors.grey;
    }

    return WpCard(
      onTap: () {
        // Detay sayfasına gitme aksiyonu
      },
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // 1. Sol İkon Alanı (Renkli Kutu)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1), // Hafif arka plan
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(iconData, color: color, size: 24),
          ),
          
          const SizedBox(width: AppSpacing.md),
          
          // 2. Orta Bilgi Alanı
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["type"]!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // DID (Kimlik No) için Monospace font teknik durur
                Text(
                  item["subject"]!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'RobotoMono', // Veya sistemin mono fontu
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis, // Uzarsa ... koy
                ),
                const SizedBox(height: 4),
                // Tarih ve Durum
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, 
                         size: 12, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      item["date"]!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 3. Sağ Ok İkonu (Detaya gitmek için ipucu)
          Icon(
            Icons.chevron_right_rounded,
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}