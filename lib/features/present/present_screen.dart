import 'package:flutter/material.dart';
import '../../core/models/credential.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/components/wp_card.dart';
import 'present_qr_screen.dart';
import '../../ui/components/nav_animate.dart';

class PresentScreen extends StatefulWidget {
  const PresentScreen({super.key});

  @override
  State<PresentScreen> createState() => _PresentScreenState();
}

class _PresentScreenState extends State<PresentScreen> {
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

  /// seçili VC'nin alan seçimi
  Map<String, bool> selectedFields = {};

  @override
  void initState() {
    super.initState();
    _syncFieldsForSelectedVc();
  }

  void _syncFieldsForSelectedVc() {
    final vc = vcs[selectedIndex];
    final keys = vc.rawJson.keys.toList()..sort();

    // önceki seçimlerden mümkün olanları koru
    final next = <String, bool>{};
    for (final k in keys) {
      next[k] = selectedFields[k] ?? true; // default: açık
    }

    setState(() => selectedFields = next);
  }

  @override
  Widget build(BuildContext context) {
    final vc = vcs[selectedIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Present")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          WpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("1) Select Credential",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                DropdownButton<int>(
                  value: selectedIndex,
                  isExpanded: true,
                  items: List.generate(vcs.length, (i) {
                    final x = vcs[i];
                    return DropdownMenuItem(
                      value: i,
                      child: Text("${x.type.join(", ")} • ${x.issuer}"),
                    );
                  }),
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => selectedIndex = v);
                    _syncFieldsForSelectedVc();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          WpCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("2) Select Fields",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                if (selectedFields.isEmpty)
                  const Text("No fields found in this credential."),
                ...selectedFields.entries.map((e) {
                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(e.key),
                    value: e.value,
                    onChanged: (v) => setState(() => selectedFields[e.key] = v ?? false),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          WpButton(
            text: "Generate QR (demo payload)",
            onPressed: () {
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
              };

                Navigator.push(
                  context,
                  wpRoute(PresentQrScreen(payload: payload)),
                );
            },
          ),
        ],
      ),
    );
  }
}
