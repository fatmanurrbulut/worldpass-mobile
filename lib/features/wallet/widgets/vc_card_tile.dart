import 'package:flutter/material.dart';
import '../../../core/models/credential.dart';
import '../../../ui/theme/app_tokens.dart';

class VcCardTile extends StatelessWidget {
  final Credential vc;
  const VcCardTile({super.key, required this.vc});

  IconData _iconForType() {
    final t = vc.type.join(" ").toLowerCase();
    if (t.contains("student")) return Icons.school;
    if (t.contains("member")) return Icons.verified_user;
    return Icons.badge;
    }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.sm),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child: Icon(_iconForType(),
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(vc.type.join(", "),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(vc.issuer,
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: Text(
            vc.expirationDate == null ? "No Exp" : "Exp",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
