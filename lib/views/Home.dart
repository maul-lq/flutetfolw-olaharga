import 'package:flutter/material.dart';

import '/components/book_card_item/book_card_item_widget.dart';
import '/components/price_drop_items/price_drop_items_widget.dart';
import '../app_data.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    this.onSelectSession,
    this.onOpenUpcoming,
    this.onOpenSignup,
  });

  static String routeName = 'Home';
  static String routePath = '/home';

  final ValueChanged<FitnessSession>? onSelectSession;
  final VoidCallback? onOpenUpcoming;
  final VoidCallback? onOpenSignup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final horizontalSessions = [
      ...AppData.bookAgainSessions,
      ...AppData.priceDropSessions,
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'For you',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Temukan class favorit, rebook yang paling cocok, dan lanjutkan onboarding akun Anda.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.tonalIcon(
              onPressed: onOpenSignup,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Sign up'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ReferralBanner(onJoinNow: onOpenSignup),
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'Book it again',
          subtitle:
              'Kelas yang paling mirip dengan skenario dari template asli.',
          actionLabel: 'Upcoming',
          onAction: onOpenUpcoming,
        ),
        const SizedBox(height: 16),
        _HorizontalSessionStrip(
          sessions: AppData.bookAgainSessions,
          onSelectSession: onSelectSession,
        ),
        const SizedBox(height: 28),
        const _SectionHeader(
          title: 'Price drop!',
          subtitle: 'Kelas diskon yang tetap bisa langsung dibooking.',
        ),
        const SizedBox(height: 16),
        for (final session in AppData.priceDropSessions) ...[
          PriceDropItemsWidget(
            session: session,
            onTap: () => onSelectSession?.call(session),
            onBook: () => onSelectSession?.call(session),
          ),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 12),
        const _SectionHeader(
          title: 'Fitness studios nearby',
          subtitle: 'Kelas populer yang dekat dengan lokasi Anda sekarang.',
        ),
        const SizedBox(height: 16),
        _HorizontalSessionStrip(
          sessions: horizontalSessions,
          onSelectSession: onSelectSession,
          ctaLabel: 'View class',
        ),
        const SizedBox(height: 28),
        const _SectionHeader(
          title: 'Local gems to discover',
          subtitle:
              'Highlight kelas dengan vibe boutique seperti di template awal.',
        ),
        const SizedBox(height: 16),
        _HorizontalSessionStrip(
          sessions: horizontalSessions.reversed.toList(),
          onSelectSession: onSelectSession,
          ctaLabel: 'Explore',
        ),
        const SizedBox(height: 28),
        const _SectionHeader(
          title: 'Save on spa and salon',
          subtitle:
              'Section tambahan yang sebelumnya hilang dari layout template.',
        ),
        const SizedBox(height: 16),
        _HorizontalSessionStrip(
          sessions: AppData.priceDropSessions,
          onSelectSession: onSelectSession,
          ctaLabel: 'See offer',
        ),
        const SizedBox(height: 28),
        const _SectionHeader(
          title: 'Newly added',
          subtitle:
              'Tambahan terbaru yang menjaga struktur akhir feed tetap mirip template.',
        ),
        const SizedBox(height: 16),
        _HorizontalSessionStrip(
          sessions: horizontalSessions,
          onSelectSession: onSelectSession,
          ctaLabel: 'Try now',
        ),
      ],
    );
  }
}

class _HorizontalSessionStrip extends StatelessWidget {
  const _HorizontalSessionStrip({
    required this.sessions,
    required this.onSelectSession,
    this.ctaLabel = 'Book again',
  });

  final List<FitnessSession> sessions;
  final ValueChanged<FitnessSession>? onSelectSession;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sessions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final session = sessions[index];
          return SizedBox(
            width: 240,
            child: BookCardItemWidget(
              session: session,
              ctaLabel: ctaLabel,
              onTap: () => onSelectSession?.call(session),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

class _ReferralBanner extends StatelessWidget {
  const _ReferralBanner({this.onJoinNow});

  final VoidCallback? onJoinNow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D4ED8), Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Refer a friend and get \$30',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gift your friends 20 bonus credits, lalu lanjutkan flow signup + verifikasi nomor seperti pada template asli.',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: onJoinNow,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1D4ED8),
                  minimumSize: const Size(0, 44),
                ),
                child: const Text('Join now'),
              ),
              OutlinedButton(
                onPressed: onJoinNow,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white30),
                  minimumSize: const Size(0, 44),
                ),
                child: const Text('Complete profile'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
