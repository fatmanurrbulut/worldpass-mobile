import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../ui/components/wp_card.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/theme/app_tokens.dart'; // Spacing değerleri

class PresentQrScreen extends StatelessWidget {
  final Map<String, dynamic> payload;
  const PresentQrScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final payloadStr = jsonEncode(payload);
    final pretty = const JsonEncoder.withIndent("  ").convert(payload);

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Sunumu"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              // Paylaşım özelliği eklenebilir
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // 1. QR KART ALANI
            WpCard(
              padding: const EdgeInsets.all(24), // QR etrafında geniş boşluk
              child: Column(
                children: [
                  // QR Kodu (Her zaman beyaz zemin üzerinde olmalı)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: QrImageView(
                      data: payloadStr,
                      size: 240,
                      // QR noktaları koyu renk, zemin şeffaf (zaten beyaz kutudayız)
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.xl),
                  
                  // Bilgilendirme Metni
                  Text(
                    "Doğrulama İçin Okutun",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    "Bu kodu doğrulayıcı cihaza gösterin.",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: AppSpacing.lg),

            // 2. AKSİYON BUTONLARI
            Row(
              children: [
                Expanded(
                  child: WpButton(
                    text: "Tam Ekran",
                    icon: Icons.fullscreen_rounded,
                    // İkincil aksiyon olduğu için belki farklı renk? 
                    // Şimdilik primary kalsın, çok şık duruyor.
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _QrFullscreen(payloadStr: payloadStr),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: WpButton(
                    text: "Kopyala",
                    icon: Icons.copy_rounded,
                    // Kopyalama butonu biraz daha farklı dursun (Opsiyonel)
                    color: theme.colorScheme.secondary, 
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: payloadStr));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: const [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 10),
                                Text("Veri panoya kopyalandı"),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xl),

            // 3. TEKNİK DETAY (JSON GÖRÜNÜMÜ)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    "VERİ İÇERİĞİ",
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // Kod bloğu rengi (Dark/Light uyumlu)
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                    ),
                  ),
                  child: SelectableText(
                    pretty,
                    style: TextStyle(
                      fontFamily: 'RobotoMono', // Veya sistemin mono fontu
                      fontSize: 12,
                      color: isDark ? const Color(0xFFCE9178) : const Color(0xFF0451A5), // VS Code tarzı renkler :)
                    ),
                  ),
                ),
              ],
            ),
            // Alt boşluk (Scroll için pay)
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// Fullscreen Modu - Basit ve Odaklı
class _QrFullscreen extends StatelessWidget {
  final String payloadStr;
  const _QrFullscreen({required this.payloadStr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Sinema modu gibi
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: QrImageView(
                data: payloadStr,
                size: 300,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Kapatmak için geri dönün",
              style: TextStyle(color: Colors.white54),
            )
          ],
        ),
      ),
    );
  }
}