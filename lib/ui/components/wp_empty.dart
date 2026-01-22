import 'package:flutter/material.dart';

class WpEmpty extends StatelessWidget {
  final String text;
  const WpEmpty({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text));
  }
}
