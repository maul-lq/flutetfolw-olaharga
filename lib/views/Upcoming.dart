import 'package:flutter/material.dart';

import '../app_data.dart';
import '../components/UpcomingItem.dart';

class UpcomingWidget extends StatelessWidget {
  const UpcomingWidget({
    super.key,
    this.onSelectSession,
    this.onStartExploring,
  });

  static String routeName = 'Upcoming';
  static String routePath = '/upcoming';

  final ValueChanged<FitnessSession>? onSelectSession;
  final VoidCallback? onStartExploring;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      children: [
        Text(
          'Upcoming',
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          'Lihat booking aktif Anda, undang teman, atau kembali eksplor class baru.',
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 20),
        _PromoCard(onStartExploring: onStartExploring),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.card_giftcard, color: Color(0xFFD97706)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bring a buddy!',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Get a reward when your friend signs up for a ClassPass plan. Share dari sini atau lanjutkan ke halaman sign up.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: const Color(0xFF92400E)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, size: 16),
              SizedBox(width: 8),
              Text(
                'Share to Instagram',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your upcoming classes',
          style:
              theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        if (AppData.upcomingSessions.isEmpty)
          _EmptyState(onStartExploring: onStartExploring)
        else
          for (final session in AppData.upcomingSessions) ...[
            UpcomingItemWidget(
              session: session,
              onTap: () => onSelectSession?.call(session),
              onInvite: () =>
                  _showFeatureSnackBar(context, 'Invite friends coming soon.'),
              onAddToCalendar: () =>
                  _showFeatureSnackBar(context, 'Calendar export coming soon.'),
              onShare: () =>
                  _showFeatureSnackBar(context, 'Share flow coming soon.'),
            ),
            const SizedBox(height: 16),
          ],
      ],
    );
  }

  void _showFeatureSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({this.onStartExploring});

  final VoidCallback? onStartExploring;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time to book!',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no upcoming reservations for the next slot. Start exploring untuk langsung pindah ke feed Home.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onStartExploring,
            icon: const Icon(Icons.explore_outlined),
            label: const Text('Start exploring'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({this.onStartExploring});

  final VoidCallback? onStartExploring;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          const Icon(Icons.calendar_month_outlined,
              size: 48, color: Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text(
            'No upcoming reservations yet',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Switch back to Home and reserve your next class in a couple of taps.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: const Color(0xFF64748B)),
          ),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: onStartExploring, child: const Text('Browse classes')),
        ],
      ),
    );
  }
}
