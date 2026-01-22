import 'package:flutter/material.dart';
import '../../ui/components/wp_card.dart';

class IssuerHomeScreen extends StatelessWidget {
  const IssuerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final issued = [
      {"type": "StudentCard", "subject": "did:worldpass:111", "date": "2026-01-01"},
      {"type": "Membership", "subject": "did:worldpass:222", "date": "2026-01-10"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Issuer • Home"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Logout"),
          )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: issued.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final x = issued[i];
          return WpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(x["type"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("Subject: ${x["subject"]}"),
                Text("Issued: ${x["date"]}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
