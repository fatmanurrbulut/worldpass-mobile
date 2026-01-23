import 'package:flutter/material.dart';
import 'dart:async';
import '../../ui/components/wp_card.dart';
import '../../ui/theme/app_tokens.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> with SingleTickerProviderStateMixin {
  // Animasyon için controller
  late AnimationController _scannerController;
  late Animation<double> _scannerAnim;

  bool isScanning = true; // Kamera açık mı?
  
  // Demo Veriler: Geçmiş doğrulamalar
  final List<Map<String, dynamic>> _history = [
    {
      "did": "did:worldpass:123...4a",
      "type": "StudentCard",
      "status": "Valid",
      "time": "10:42 AM"
    },
    {
      "did": "did:worldpass:987...b2",
      "type": "EventTicket",
      "status": "Expired",
      "time": "09:15 AM"
    },
  ];

  @override
  void initState() {
    super.initState();
    // Lazer çizgisinin yukarı aşağı gitmesi için animasyon
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scannerAnim = Tween<double>(begin: 0.1, end: 0.9).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  // Tarama Simülasyonu
  void _simulateScanResult() {
    // Gerçekte burada QR kütüphanesi tetiklenir
    setState(() => isScanning = false); // Animasyonu durdur
    
    // Yükleniyor efekti
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pop(context); // Dialog kapa

      // Listeye yeni kayıt ekle
      setState(() {
        _history.insert(0, {
          "did": "did:worldpass:555...new",
          "type": "Membership",
          "status": "Valid",
          "time": "Now",
        });
        isScanning = true; // Taramaya devam et
      });

      // Başarılı uyarısı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Credential Verified Successfully"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kimlik Doğrulayıcı"),
        actions: [
          // Flash butonu (Görsel)
          IconButton(
            icon: const Icon(Icons.flash_on_rounded),
            onPressed: () {},
            tooltip: "Flash",
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. KAMERA / TARAYICI ALANI
          Expanded(
            flex: 4, // Ekranın %40'ı tarayıcı olsun
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.black, // Kamera her zaman karanlık görünür
                borderRadius: BorderRadius.circular(AppRadii.xl),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // A) Kamera Placeholder (Gerçekte CameraPreview buraya gelir)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 64,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "QR Kodu çerçeveye hizalayın",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // B) Tarama Çerçevesi (Köşeler)
                  _ScannerOverlay(color: theme.colorScheme.primary),

                  // C) Hareketli Lazer Çizgisi
                  if (isScanning)
                    AnimatedBuilder(
                      animation: _scannerAnim,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          heightFactor: 0.05, // Çizgi yüksekliği
                          widthFactor: 0.8,   // Çizgi genişliği
                          alignment: Alignment(0, (_scannerAnim.value * 2) - 1), // -1 ile 1 arası hareket
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withOpacity(0),
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // D) Manuel Buton (Demo için)
                  Positioned(
                    bottom: 20,
                    left: 0, 
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _simulateScanResult,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Simulate Scan Tap",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. SON DOĞRULAMALAR LİSTESİ
          Expanded(
            flex: 5, // Ekranın %60'ı liste
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Tutamaç (Handle)
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Başlık ve Temizle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Son Aktiviteler",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _history.clear()),
                          child: const Text("Temizle"),
                        ),
                      ],
                    ),
                  ),

                  // Liste
                  Expanded(
                    child: _history.isEmpty
                        ? Center(
                            child: Text(
                              "Henüz doğrulama yapılmadı.",
                              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.all(AppSpacing.lg),
                            itemCount: _history.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = _history[index];
                              final isValid = item["status"] == "Valid";

                              return WpCard(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    // Durum İkonu
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isValid 
                                            ? Colors.green.withOpacity(0.1) 
                                            : Colors.red.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isValid ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                        color: isValid ? Colors.green : Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    
                                    // Bilgiler
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["type"],
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            item["did"],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'RobotoMono',
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Zaman
                                    Text(
                                      item["time"],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Köşe çizgilerini çizen custom widget
class _ScannerOverlay extends StatelessWidget {
  final Color color;
  const _ScannerOverlay({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScannerPainter(color),
      child: Container(),
    );
  }
}

class _ScannerPainter extends CustomPainter {
  final Color color;
  _ScannerPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double cornerSize = 30;
    final double padding = 20;

    final path = Path();
    
    // Sol Üst
    path.moveTo(padding, padding + cornerSize);
    path.lineTo(padding, padding);
    path.lineTo(padding + cornerSize, padding);

    // Sağ Üst
    path.moveTo(size.width - padding - cornerSize, padding);
    path.lineTo(size.width - padding, padding);
    path.lineTo(size.width - padding, padding + cornerSize);

    // Sağ Alt
    path.moveTo(size.width - padding, size.height - padding - cornerSize);
    path.lineTo(size.width - padding, size.height - padding);
    path.lineTo(size.width - padding - cornerSize, size.height - padding);

    // Sol Alt
    path.moveTo(padding + cornerSize, size.height - padding);
    path.lineTo(padding, size.height - padding);
    path.lineTo(padding, size.height - padding - cornerSize);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}