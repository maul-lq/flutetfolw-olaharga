import 'package:flutter/material.dart';

import '../app_data.dart';

class ConfirmReservationPopupWidget extends StatelessWidget {
  const ConfirmReservationPopupWidget({
    super.key,
    required this.session,
    required this.onConfirm,
    this.onClose,
  });

  final FitnessSession session;
  final VoidCallback onConfirm;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Checkout',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  session.imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const ColoredBox(
                    color: Color(0xFFE2E8F0),
                    child: SizedBox(
                        width: 64,
                        height: 64,
                        child: Icon(Icons.image_not_supported_outlined)),
                  ),
                ),
              ),
              title: Text(session.title,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              subtitle: Text(
                  '${formatSessionSchedule(session)}\n${formatStudioLine(session)}'),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reservation summary',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text('Credits: ${session.creditsLabel}'),
                  const SizedBox(height: 4),
                  const Text(
                      'Cancel 12 hours in advance to avoid a late cancellation fee.'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: onClose, child: const Text('Back')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                      onPressed: onConfirm,
                      child: const Text('Confirm reservation')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
