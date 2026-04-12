import 'package:flutter/material.dart';

import '../app_data.dart';

class PriceDropItemsWidget extends StatelessWidget {
  const PriceDropItemsWidget({
    super.key,
    required this.session,
    this.onTap,
    this.onBook,
  });

  final FitnessSession session;
  final VoidCallback? onTap;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Price drop!',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF15803D),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      session.title,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatSessionSchedule(session),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xFF475569)),
                    ),
                    const SizedBox(height: 6),
                    Text(formatStudioLine(session),
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      session.instructor,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: FilledButton(
                            onPressed: onBook,
                            style: FilledButton.styleFrom(
                                minimumSize: const Size(120, 44)),
                            child: const Text('Book'),
                          ),
                        ),
                        Text(
                          session.creditsLabel,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  session.imageUrl,
                  width: 96,
                  height: 144,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 96,
                    height: 144,
                    color: const Color(0xFFE2E8F0),
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
