import 'package:flutter/material.dart';

class WpLoading extends StatelessWidget {
  final String? text;
  const WpLoading({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (text != null) ...[
            const SizedBox(height: 10),
            Text(text!),
          ]
        ],
      ),
    );
  }
}
