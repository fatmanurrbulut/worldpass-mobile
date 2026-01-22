import 'package:flutter/material.dart';
import 'wp_button.dart';

class WpError extends StatelessWidget {
  final String text;
  final VoidCallback? onRetry;

  const WpError({super.key, required this.text, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              WpButton(text: "Retry", onPressed: onRetry),
            ]
          ],
        ),
      ),
    );
  }
}
