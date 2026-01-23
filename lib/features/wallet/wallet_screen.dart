import 'package:flutter/material.dart';
import '../../core/models/credential.dart';
import '../../ui/components/wp_card.dart';
import '../../ui/components/wp_empty.dart';
import '../../ui/components/wp_error.dart';
import 'wallet_detail_screen.dart';
import '../../ui/components/wp_skeleton.dart';
import 'widgets/vc_card_tile.dart';
import '../../ui/theme/app_tokens.dart';
import '../../ui/components/nav_animate.dart';


class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool loading = true;
  bool hasError = false;
  List<Credential> list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool simulateError = false, bool simulateEmpty = false}) async {
    setState(() {
      loading = true;
      hasError = false;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (simulateError) {
      setState(() {
        loading = false;
        hasError = true;
      });
      return;
    }

    final demo = simulateEmpty
        ? <Credential>[]
        : <Credential>[
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

    setState(() {
      list = demo;
      loading = false;
      hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        // debug amaçlı küçük butonlar: sonra kaldırırız
        actions: [
          IconButton(
            tooltip: "Simulate empty",
            onPressed: () => _load(simulateEmpty: true),
            icon: const Icon(Icons.inbox),
          ),
          IconButton(
            tooltip: "Simulate error",
            onPressed: () => _load(simulateError: true),
            icon: const Icon(Icons.error_outline),
          ),
        ],
      ),
      body: loading
          ? const WpSkeletonList(count: 8)
          : hasError
              ? WpError(
                  text: "Could not load credentials.",
                  onRetry: () => _load(),
                )
              : list.isEmpty
                  ? const WpEmpty(title: "No credentials yet.")
                  : RefreshIndicator(
                      onRefresh: () => _load(),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final vc = list[i];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppRadii.md),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  wpRoute(WalletDetailScreen(vc: vc)),
                                );
                              },
                              child: WpCard(
                                child: VcCardTile(vc: vc),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
