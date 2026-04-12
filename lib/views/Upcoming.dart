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

enum _DateFilterPreset { all, today, last7Days, last30Days, custom }

class _UpcomingWidgetState extends State<UpcomingWidget> {
  _WorkoutFilter _filter = _WorkoutFilter.all;
  _DateFilterPreset _datePreset = _DateFilterPreset.all;
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final store = context.watch<FitnessStore>();

    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final allWorkouts = store.workouts;
    final statusFilteredWorkouts = switch (_filter) {
      _WorkoutFilter.all => allWorkouts,
      _WorkoutFilter.completed =>
        allWorkouts.where((item) => item.isCompleted).toList(growable: false),
      _WorkoutFilter.planned =>
        allWorkouts.where((item) => !item.isCompleted).toList(growable: false),
    };

    final dateRange = _resolveDateRange();
    final filteredWorkouts = statusFilteredWorkouts.where((item) {
      if (dateRange == null) {
        return true;
      }
      final workoutDate = item.date;
      return !workoutDate.isBefore(dateRange.start) &&
          !workoutDate.isAfter(dateRange.end);
    }).toList(growable: false);

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
        const SizedBox(height: 14),
        Text(
          'Filter tanggal',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'Semua tanggal',
              selected: _datePreset == _DateFilterPreset.all,
              onTap: () => setState(() => _datePreset = _DateFilterPreset.all),
            ),
            _FilterChip(
              label: 'Hari ini',
              selected: _datePreset == _DateFilterPreset.today,
              onTap: () => setState(() => _datePreset = _DateFilterPreset.today),
            ),
            _FilterChip(
              label: '7 hari',
              selected: _datePreset == _DateFilterPreset.last7Days,
              onTap: () =>
                  setState(() => _datePreset = _DateFilterPreset.last7Days),
            ),
            _FilterChip(
              label: '30 hari',
              selected: _datePreset == _DateFilterPreset.last30Days,
              onTap: () =>
                  setState(() => _datePreset = _DateFilterPreset.last30Days),
            ),
            _FilterChip(
              label: 'Custom',
              selected: _datePreset == _DateFilterPreset.custom,
              onTap: () => setState(() => _datePreset = _DateFilterPreset.custom),
            ),
          ],
        ),
        if (_datePreset == _DateFilterPreset.custom) ...[
          const SizedBox(height: 10),
          _CustomDateRangeSelector(
            startDate: _customStartDate,
            endDate: _customEndDate,
            onPickStart: _pickStartDate,
            onPickEnd: _pickEndDate,
            onReset: () {
              setState(() {
                _customStartDate = null;
                _customEndDate = null;
              });
            },
          ),
        ],
        const SizedBox(height: 10),
        Text(
          'Menampilkan ${filteredWorkouts.length} workout',
          style: theme.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF64748B),
          ),
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
              label: 'Ditampilkan',
              value: '${filteredWorkouts.length}',
            ),
            _TinyStatCard(
              label: 'Selesai',
              value:
                  '${filteredWorkouts.where((item) => item.isCompleted).length}',
            ),
            _TinyStatCard(
              label: 'Planned',
              value:
                  '${filteredWorkouts.where((item) => !item.isCompleted).length}',
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

  _DateRange? _resolveDateRange() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    switch (_datePreset) {
      case _DateFilterPreset.all:
        return null;
      case _DateFilterPreset.today:
        return _DateRange(start: todayStart, end: todayEnd);
      case _DateFilterPreset.last7Days:
        return _DateRange(
          start: todayStart.subtract(const Duration(days: 6)),
          end: todayEnd,
        );
      case _DateFilterPreset.last30Days:
        return _DateRange(
          start: todayStart.subtract(const Duration(days: 29)),
          end: todayEnd,
        );
      case _DateFilterPreset.custom:
        if (_customStartDate == null && _customEndDate == null) {
          return null;
        }
        final start = _customStartDate != null
            ? DateTime(
                _customStartDate!.year,
                _customStartDate!.month,
                _customStartDate!.day,
              )
            : DateTime(2000);
        final end = _customEndDate != null
            ? DateTime(
                _customEndDate!.year,
                _customEndDate!.month,
                _customEndDate!.day,
                23,
                59,
                59,
                999,
              )
            : DateTime(2100, 1, 1, 23, 59, 59, 999);
        return _DateRange(start: start, end: end);
    }
  }

  Future<void> _pickStartDate() async {
    final initial = _customStartDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }

    setState(() {
      _datePreset = _DateFilterPreset.custom;
      _customStartDate = picked;
      if (_customEndDate != null && _customEndDate!.isBefore(picked)) {
        _customEndDate = picked;
      }
    });
  }

  Future<void> _pickEndDate() async {
    final initial = _customEndDate ?? _customStartDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }

    setState(() {
      _datePreset = _DateFilterPreset.custom;
      _customEndDate = picked;
      if (_customStartDate != null && _customStartDate!.isAfter(picked)) {
        _customStartDate = picked;
      }
    });
  }
}

class _DateRange {
  const _DateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
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

class _CustomDateRangeSelector extends StatelessWidget {
  const _CustomDateRangeSelector({
    required this.startDate,
    required this.endDate,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onReset,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onPickStart,
              icon: const Icon(Icons.event_outlined),
              label: Text(
                startDate == null ? 'Tanggal awal' : formatWorkoutDate(startDate!),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onPickEnd,
              icon: const Icon(Icons.event_available_outlined),
              label: Text(
                endDate == null ? 'Tanggal akhir' : formatWorkoutDate(endDate!),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            onPressed: onReset,
            icon: const Icon(Icons.close),
            tooltip: 'Reset rentang',
          ),
        ],
      ),
    );
  }
}
