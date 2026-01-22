import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../ui/components/wp_card.dart';
import '../../ui/components/wp_button.dart';

class PresentQrScreen extends StatelessWidget {
  final Map<String, dynamic> payload;
  const PresentQrScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final payloadStr = jsonEncode(payload);
    final pretty = const JsonEncoder.withIndent("  ").convert(payload);

    return Scaffold(
      appBar: AppBar(title: const Text("Present • QR")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          WpCard(
            child: Column(
              children: [
                // QR
                QrImageView(
                  data: payloadStr,
                  size: 260,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Scan this QR to verify",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Fullscreen + Copy
                Row(
                  children: [
                    Expanded(
                      child: WpButton(
                        text: "Fullscreen",
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: WpButton(
                        text: "Copy Payload",
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: payloadStr));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Payload copied")),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          WpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Payload (readable)",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                SelectableText(pretty),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrFullscreen extends StatelessWidget {
  final String payloadStr;
  const _QrFullscreen({required this.payloadStr});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Fullscreen")),
      body: Center(
        child: QrImageView(
          data: payloadStr,
          size: 360,
        ),
      ),
    );
  }
}
