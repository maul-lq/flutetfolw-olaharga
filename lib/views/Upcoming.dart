import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_data.dart';
import '../fitness_store.dart';

class UpcomingWidget extends StatefulWidget {
  const UpcomingWidget({
    super.key,
    this.onSelectWorkout,
    this.onStartExploring,
    this.onAddWorkout,
  });

  static String routeName = 'Upcoming';
  static String routePath = '/upcoming';

  final ValueChanged<WorkoutLog>? onSelectWorkout;
  final VoidCallback? onStartExploring;
  final VoidCallback? onAddWorkout;

  @override
  State<UpcomingWidget> createState() => _UpcomingWidgetState();
}

enum _WorkoutFilter { all, completed, planned }

class _UpcomingWidgetState extends State<UpcomingWidget> {
  _WorkoutFilter _filter = _WorkoutFilter.all;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = context.watch<FitnessStore>();

    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allWorkouts = store.workouts;
    final filteredWorkouts = switch (_filter) {
      _WorkoutFilter.all => allWorkouts,
      _WorkoutFilter.completed =>
        allWorkouts.where((item) => item.isCompleted).toList(growable: false),
      _WorkoutFilter.planned =>
        allWorkouts.where((item) => !item.isCompleted).toList(growable: false),
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Workout Log',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: widget.onAddWorkout,
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Lihat workout yang sudah selesai atau masih direncanakan. Tap item untuk buka detail dan edit.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'Semua',
              selected: _filter == _WorkoutFilter.all,
              onTap: () => setState(() => _filter = _WorkoutFilter.all),
            ),
            _FilterChip(
              label: 'Selesai',
              selected: _filter == _WorkoutFilter.completed,
              onTap: () => setState(() => _filter = _WorkoutFilter.completed),
            ),
            _FilterChip(
              label: 'Planned',
              selected: _filter == _WorkoutFilter.planned,
              onTap: () => setState(() => _filter = _WorkoutFilter.planned),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.05,
          children: [
            _TinyStatCard(
              label: 'Total',
              value: '${allWorkouts.length}',
            ),
            _TinyStatCard(
              label: 'Selesai',
              value: '${store.completedWorkouts.length}',
            ),
            _TinyStatCard(
              label: 'Planned',
              value: '${store.plannedWorkouts.length}',
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (filteredWorkouts.isEmpty)
          _EmptyLogState(
            onAddWorkout: widget.onAddWorkout,
            onBackToDashboard: widget.onStartExploring,
          )
        else
          for (final workout in filteredWorkouts) ...[
            _WorkoutLogItem(
              workout: workout,
              onTap: () => widget.onSelectWorkout?.call(workout),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _TinyStatCard extends StatelessWidget {
  const _TinyStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
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

class _WorkoutLogItem extends StatelessWidget {
  const _WorkoutLogItem({required this.workout, this.onTap});

  final WorkoutLog workout;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor =
        workout.isCompleted ? const Color(0xFF15803D) : const Color(0xFFB45309);
    final statusBg =
        workout.isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      workout.isCompleted ? 'Completed' : 'Planned',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                workout.workoutName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${workout.category} · ${workout.intensity.label}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatWorkoutDateTime(workout.date),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    formatDurationMinutes(workout.durationMinutes),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${workout.caloriesBurnedEstimate} kcal (estimasi)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyLogState extends StatelessWidget {
  const _EmptyLogState({
    this.onAddWorkout,
    this.onBackToDashboard,
  });

  final VoidCallback? onAddWorkout;
  final VoidCallback? onBackToDashboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.event_note_outlined,
                size: 44, color: Color(0xFF94A3B8)),
            const SizedBox(height: 10),
            Text(
              'Belum ada workout sesuai filter ini',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tambah workout baru atau kembali ke dashboard untuk melihat ringkasan progress.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: onAddWorkout,
                  child: const Text('Tambah workout'),
                ),
                OutlinedButton(
                  onPressed: onBackToDashboard,
                  child: const Text('Dashboard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
