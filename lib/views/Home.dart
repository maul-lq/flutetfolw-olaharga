import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_data.dart';
import '../fitness_store.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    this.onSelectWorkout,
    this.onOpenUpcoming,
    this.onOpenSignup,
    this.onAddWorkout,
    this.onAddBodyProgress,
  });

  static String routeName = 'Home';
  static String routePath = '/home';

  final ValueChanged<WorkoutLog>? onSelectWorkout;
  final VoidCallback? onOpenUpcoming;
  final VoidCallback? onOpenSignup;
  final VoidCallback? onAddWorkout;
  final VoidCallback? onAddBodyProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = context.watch<FitnessStore>();

    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final profileName = (store.profile?.name.trim().isNotEmpty ?? false)
        ? store.profile!.name.trim()
        : 'Athlete';
    final latestMetric = store.latestBodyMetric;
    final latestWeightDelta = store.latestWeightDelta;
    final recentWorkouts = store.workouts.take(3).toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        Text(
          'Manual Fitness Tracker',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Halo, $profileName. Pantau latihan harian dan progress tubuh dari satu dashboard.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 20),
        _QuickActions(
          onAddWorkout: onAddWorkout,
          onAddBodyProgress: onAddBodyProgress,
          onOpenUpcoming: onOpenUpcoming,
          onOpenProfile: onOpenSignup,
        ),
        const SizedBox(height: 22),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _MetricCard(
              title: 'Workout minggu ini',
              value: '${store.workoutsThisWeek}',
              subtitle: 'Sesi selesai',
              icon: Icons.fitness_center,
            ),
            _MetricCard(
              title: 'Durasi latihan',
              value: '${store.totalMinutesThisWeek} min',
              subtitle: 'Total minggu ini',
              icon: Icons.timer_outlined,
            ),
            _MetricCard(
              title: 'Streak',
              value: '${store.currentStreak} hari',
              subtitle: 'Konsisten berturut-turut',
              icon: Icons.local_fire_department_outlined,
            ),
            _MetricCard(
              title: 'BMI',
              value: store.bmi != null ? store.bmi!.toStringAsFixed(1) : '-',
              subtitle: 'Berdasar data terakhir',
              icon: Icons.monitor_heart_outlined,
            ),
          ],
        ),
        const SizedBox(height: 22),
        if (latestMetric != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.monitor_weight_outlined, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Berat terbaru ${latestMetric.weightKg.toStringAsFixed(1)} kg',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          latestWeightDelta == null
                              ? 'Belum ada pembanding sebelumnya.'
                              : 'Perubahan ${latestWeightDelta >= 0 ? '+' : ''}${latestWeightDelta.toStringAsFixed(1)} kg dari entry sebelumnya.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        _SectionHeader(
          title: 'Workout terakhir',
          subtitle: 'Buka detail untuk edit, tandai selesai, atau hapus log.',
          actionLabel: 'Lihat semua',
          onAction: onOpenUpcoming,
        ),
        const SizedBox(height: 12),
        if (recentWorkouts.isEmpty)
          _EmptyState(
            title: 'Belum ada workout',
            subtitle: 'Tambah workout pertama Anda untuk mulai tracking.',
            cta: 'Tambah workout',
            onTap: onAddWorkout,
          )
        else
          for (final workout in recentWorkouts) ...[
            _WorkoutPreviewCard(
              workout: workout,
              onTap: () => onSelectWorkout?.call(workout),
            ),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 16),
        const _SectionHeader(
          title: 'Quick workout ideas',
          subtitle: 'Template cepat yang bisa langsung dipakai.',
        ),
        const SizedBox(height: 12),
        for (final template in AppData.quickWorkoutTemplates) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.bolt_outlined),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${template.category} · ${formatDurationMinutes(template.durationMinutes)} · ${template.estimatedCalories} kcal',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.tonal(
                    onPressed: onAddWorkout,
                    child: const Text('Gunakan'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    this.onAddWorkout,
    this.onAddBodyProgress,
    this.onOpenUpcoming,
    this.onOpenProfile,
  });

  final VoidCallback? onAddWorkout;
  final VoidCallback? onAddBodyProgress;
  final VoidCallback? onOpenUpcoming;
  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        FilledButton.icon(
          onPressed: onAddWorkout,
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Tambah workout'),
        ),
        FilledButton.tonalIcon(
          onPressed: onAddBodyProgress,
          icon: const Icon(Icons.monitor_weight_outlined),
          label: const Text('Tambah progress'),
        ),
        OutlinedButton.icon(
          onPressed: onOpenUpcoming,
          icon: const Icon(Icons.list_alt_outlined),
          label: const Text('Workout log'),
        ),
        OutlinedButton.icon(
          onPressed: onOpenProfile,
          icon: const Icon(Icons.person_outline),
          label: const Text('Setup profil'),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF1D4ED8)),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
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
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel!),
          ),
      ],
    );
  }
}

class _WorkoutPreviewCard extends StatelessWidget {
  const _WorkoutPreviewCard({required this.workout, this.onTap});

  final WorkoutLog workout;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: workout.isCompleted
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(
                  workout.isCompleted
                      ? Icons.check_circle_outline
                      : Icons.schedule,
                  color: workout.isCompleted
                      ? const Color(0xFF166534)
                      : const Color(0xFF92400E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.workoutName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${workout.category} · ${formatDurationMinutes(workout.durationMinutes)} · ${formatWorkoutDateTime(workout.date)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.cta,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String cta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined, size: 36, color: Color(0xFF94A3B8)),
            const SizedBox(height: 10),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onTap, child: Text(cta)),
          ],
        ),
      ),
    );
  }
}
