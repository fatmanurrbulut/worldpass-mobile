import 'package:flutter/material.dart';

class WpSkeletonBox extends StatelessWidget {
  final double height;
  final double? width;
  const WpSkeletonBox({super.key, required this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class WpSkeletonList extends StatelessWidget {
  final int count;
  const WpSkeletonList({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => const WpSkeletonBox(height: 86),
    );
  }
}
