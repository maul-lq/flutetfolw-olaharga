import 'package:flutter/material.dart';

import '../app_data.dart';

class ConfirmCancelationPopupWidget extends StatelessWidget {
  const ConfirmCancelationPopupWidget({
    super.key,
    required this.session,
    required this.onConfirmCancel,
    this.onClose,
  });

  final FitnessSession session;
  final VoidCallback onConfirmCancel;
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
                    'Confirm cancellation',
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
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: Text(
                'We\'ll refund your ${session.credits} credits. Cancel at least 12 hours before class to avoid a late-cancel fee.',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFF991B1B)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: onClose,
                      child: const Text('Keep reservation')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onConfirmCancel,
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626)),
                    child: const Text('Cancel reservation'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
