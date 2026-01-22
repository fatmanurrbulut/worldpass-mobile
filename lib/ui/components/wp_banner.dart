import 'package:flutter/material.dart';

class WpBanner extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? background;

  const WpBanner({
    super.key,
    required this.text,
    this.icon = Icons.info_outline,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    final bg = background ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
