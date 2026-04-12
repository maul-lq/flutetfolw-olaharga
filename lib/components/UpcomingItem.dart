import 'package:flutter/material.dart';

import '../app_data.dart';

class UpcomingItemWidget extends StatelessWidget {
  const UpcomingItemWidget({
    super.key,
    required this.session,
    this.onTap,
    this.onInvite,
    this.onAddToCalendar,
    this.onShare,
  });

  final FitnessSession session;
  final VoidCallback? onTap;
  final VoidCallback? onInvite;
  final VoidCallback? onAddToCalendar;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  session.imageUrl,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: const Color(0xFFE2E8F0),
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 4),
              Text(
                formatStudioLine(session),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: onInvite,
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Invite friends'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: onAddToCalendar,
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: onShare,
                    icon: const Icon(Icons.share_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
