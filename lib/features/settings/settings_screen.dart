import 'package:flutter/material.dart';
import '../../ui/components/wp_button.dart';
import '../../ui/components/wp_card.dart';
import '../../ui/components/nav_animate.dart';
import '../../ui/theme/app_tokens.dart'; // Spacing
import '../issuer/issuer_login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // 1. PROFİL KARTI
          WpCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    "M", // Mathis'in M'si
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // İsim ve DID
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Mathis",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: Colors.blue.shade400,
                          )
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "did:worldpass:123...xyz",
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                          fontFamily: 'RobotoMono',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Edit Butonu
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {},
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // 2. GÜVENLİK AYARLARI (Kişi 2'nin alanı)
          _SectionHeader(title: "SECURITY & PRIVACY"),
          WpCard(
            padding: EdgeInsets.zero, // List Tile'lar kenara yapışsın
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.fingerprint,
                  title: "Biometric Login",
                  trailing: Switch.adaptive(
                    value: true, 
                    onChanged: (v) {},
                    activeColor: theme.colorScheme.primary,
                  ),
                ),
                _Divider(),
                _SettingsTile(
                  icon: Icons.security_rounded,
                  title: "Two-Factor Auth (2FA)",
                  subtitle: "Not enabled",
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    // 2FA ekranına git
                  },
                ),
                _Divider(),
                _SettingsTile(
                  icon: Icons.history_rounded,
                  title: "Activity Log",
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // 3. GELİŞTİRİCİ / DEMO MODU
          _SectionHeader(title: "DEVELOPER ZONE"),
          WpCard(
            child: Column(
              children: [
                const Text(
                  "Switching to Issuer Mode allows you to issue credentials for testing purposes.",
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
                const SizedBox(height: 12),
                WpButton(
                  text: "Go to Issuer Mode (Demo)",
                  icon: Icons.swap_horiz_rounded,
                  color: Colors.indigoAccent, // Farklı bir renk olsun
                  onPressed: () {
                    Navigator.push(
                      context,
                      wpRoute(const IssuerLoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xl),

          // 4. ÇIKIŞ VE VERSİYON
          WpButton(
            text: "Log Out",
            icon: Icons.logout_rounded,
            color: theme.colorScheme.error, // Kırmızı buton
            onPressed: () {
              // Çıkış işlemleri...
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          
          const SizedBox(height: 16),
          Center(
            child: Text(
              "WorldPass v1.0.0 (Build 24)",
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// --- Yardımcı Widget'lar ---

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
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: theme.colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant))
          : null,
      trailing: trailing,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 60, // İkonun hizasından başlasın
      endIndent: 0,
      color: Theme.of(context).dividerColor.withOpacity(0.1),
    );
  }
}