import 'package:flutter/material.dart';

import '../app_data.dart';
import '../components/ConfirmCancelationPopup.dart';
import '../components/ConfirmReservationPopup.dart';

class ReservationWidget extends StatefulWidget {
  const ReservationWidget({
    super.key,
    required this.session,
    this.initiallyBooked = false,
  });

  static String routeName = 'Reservation';
  static String routePath = '/reservation';

  final FitnessSession session;
  final bool initiallyBooked;

  @override
  State<ReservationWidget> createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  late final PageController _pageController;
  late bool _isBooked;
  bool _isFavorite = false;
  bool _showFullDescription = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _isBooked = widget.initiallyBooked || widget.session.isReserved;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final theme = Theme.of(context);
    final images = [
      session.imageUrl,
      'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=1200&q=80',
      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () => _showMessage('Share flow belum dihubungkan.'),
            icon: const Icon(Icons.ios_share_outlined),
          ),
          IconButton(
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140F172A),
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isBooked
                          ? '${session.credits} credits reserved'
                          : session.creditsLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isBooked
                          ? 'Ketik cancel jika ingin membatalkan booking.'
                          : 'Reserve your spot before it fills up.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: _isBooked
                      ? _openCancellationSheet
                      : _openReservationSheet,
                  style: FilledButton.styleFrom(
                    backgroundColor: _isBooked ? const Color(0xFFDC2626) : null,
                  ),
                  child: Text(_isBooked ? 'Cancel reservation' : 'Reserve'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  SizedBox(
                    height: 260,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() {
                        _currentImageIndex = index;
                      }),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFE2E8F0),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              size: 48,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1}/${images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    session.ratingLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${formatStudioLine(session)} · ${session.category}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatSessionSchedule(session),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${session.instructor} · ${session.distanceLabel}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showMessage('Invite flow coming soon.'),
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Invite'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showMessage('Calendar sync coming soon.'),
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: const Text('Add'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _InfoCard(
              title: 'About this class',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.description,
                    maxLines: _showFullDescription ? null : 3,
                    overflow: _showFullDescription
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() {
                      _showFullDescription = !_showFullDescription;
                    }),
                    child: Text(
                      _showFullDescription ? 'Show less' : 'Read more',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const _InfoCard(
              title: 'Reservation details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: 'Credits', value: '6 credits'),
                  _DetailRow(
                    label: 'Cancellation policy',
                    value:
                        'Cancel 12 hours in advance to avoid a late cancellation fee.',
                  ),
                  _DetailRow(
                    label: 'What to bring',
                    value:
                        'Grip socks, water bottle, and a towel if preferred.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openReservationSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ConfirmReservationPopupWidget(
          session: widget.session,
          onConfirm: () {
            Navigator.of(context).pop();
            setState(() {
              _isBooked = true;
            });
            _showMessage('Reservation confirmed for ${widget.session.title}.');
          },
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> _openCancellationSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ConfirmCancelationPopupWidget(
          session: widget.session,
          onConfirmCancel: () {
            Navigator.of(context).pop();
            setState(() {
              _isBooked = false;
            });
            _showMessage('Reservation cancelled. Credits have been restored.');
          },
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
