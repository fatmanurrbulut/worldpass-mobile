import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/models/credential.dart';
import '../../ui/components/wp_card.dart';

class WalletDetailScreen extends StatelessWidget {
  final Credential vc;
  const WalletDetailScreen({super.key, required this.vc});

  @override
  Widget build(BuildContext context) {
    final pretty = const JsonEncoder.withIndent("  ").convert(vc.rawJson);

    return Scaffold(
      appBar: AppBar(title: const Text("Credential Detail")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          WpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vc.type.join(", "),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("ID: ${vc.id}"),
                Text("Issuer: ${vc.issuer}"),
                Text("Issued: ${vc.issuanceDate}"),
                Text("Expires: ${vc.expirationDate ?? "-"}"),
                Text("Subject DID: ${vc.subjectDid}"),
              ],
            ),
          ),
          const SizedBox(height: 12),
          WpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Raw JSON",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
