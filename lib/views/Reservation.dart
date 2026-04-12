import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_data.dart';
import '../fitness_store.dart';

class ReservationWidget extends StatefulWidget {
  const ReservationWidget({
    super.key,
    this.workout,
  });

  static String routeName = 'Reservation';
  static String routePath = '/reservation';

  final WorkoutLog? workout;

  @override
  State<ReservationWidget> createState() => _ReservationWidgetState();
}

class _ReservationWidgetState extends State<ReservationWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _workoutNameController;
  late final TextEditingController _durationController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _notesController;

  late DateTime _selectedDate;
  late WorkoutIntensity _selectedIntensity;
  late String _selectedCategory;
  late bool _isCompleted;

  bool get _isEditMode => widget.workout != null;

  @override
  void initState() {
    super.initState();
    final workout = widget.workout;

    _workoutNameController = TextEditingController(
      text: workout?.workoutName ?? '',
    );
    _durationController = TextEditingController(
      text: workout != null ? '${workout.durationMinutes}' : '45',
    );
    _caloriesController = TextEditingController(
      text: workout != null ? '${workout.caloriesBurnedEstimate}' : '300',
    );
    _notesController = TextEditingController(
      text: workout?.notes ?? '',
    );

    _selectedDate = workout?.date ?? DateTime.now();
    _selectedIntensity = workout?.intensity ?? WorkoutIntensity.medium;
    _selectedCategory = workout?.category ?? AppData.workoutCategories.first;
    _isCompleted = workout?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _workoutNameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'Workout Detail' : 'Add Workout'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          actions: [
            if (_isEditMode)
              IconButton(
                onPressed: _deleteWorkout,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Hapus workout',
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: FilledButton(
            onPressed: _saveWorkout,
            child: Text(_isEditMode ? 'Simpan perubahan' : 'Simpan workout'),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _isCompleted
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        _isCompleted ? Icons.check_circle : Icons.schedule,
                        color: _isCompleted
                            ? const Color(0xFF15803D)
                            : const Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _workoutNameController.text.trim().isEmpty
                                ? 'Workout baru'
                                : _workoutNameController.text.trim(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${formatWorkoutDateTime(_selectedDate)} · $_selectedCategory',
                            style: theme.textTheme.bodySmall?.copyWith(
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
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workout info',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _workoutNameController,
                        decoration: const InputDecoration(
                          labelText: 'Workout name',
                          hintText: 'Contoh: Full Body Strength',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama workout wajib diisi';
                          }
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: AppData.workoutCategories
                            .map(
                              (category) => DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<WorkoutIntensity>(
                        initialValue: _selectedIntensity,
                        decoration: const InputDecoration(
                          labelText: 'Intensity',
                        ),
                        items: WorkoutIntensity.values
                            .map(
                              (intensity) => DropdownMenuItem<WorkoutIntensity>(
                                value: intensity,
                                child: Text(intensity.label),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedIntensity = value;
                          });
                        },
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _durationController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Duration (minutes)',
                              ),
                              validator: (value) {
                                final parsed = int.tryParse(value?.trim() ?? '');
                                if (parsed == null || parsed <= 0) {
                                  return 'Isi durasi valid';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _caloriesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Estimated calories',
                              ),
                              validator: (value) {
                                final parsed = int.tryParse(value?.trim() ?? '');
                                if (parsed == null || parsed <= 0) {
                                  return 'Isi kalori valid';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: _pickWorkoutDate,
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(formatWorkoutDateTime(_selectedDate)),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _notesController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          hintText: 'Catatan latihan, beban, atau progres.',
                        ),
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile.adaptive(
                        value: _isCompleted,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Tandai selesai'),
                        subtitle: const Text(
                          'Aktifkan jika workout sudah Anda kerjakan.',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isCompleted = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickWorkoutDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (time == null) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _saveWorkout() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final duration = int.parse(_durationController.text.trim());
    final calories = int.parse(_caloriesController.text.trim());
    final store = context.read<FitnessStore>();

    final data = WorkoutLog(
      id: widget.workout?.id ?? 'workout-${DateTime.now().microsecondsSinceEpoch}',
      date: _selectedDate,
      workoutName: _workoutNameController.text.trim(),
      category: _selectedCategory,
      durationMinutes: duration,
      caloriesBurnedEstimate: calories,
      notes: _notesController.text.trim(),
      intensity: _selectedIntensity,
      isCompleted: _isCompleted,
    );

    if (_isEditMode) {
      await store.updateWorkout(data);
    } else {
      await store.addWorkout(data);
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditMode
              ? 'Workout berhasil diperbarui.'
              : 'Workout baru berhasil ditambahkan.',
        ),
      ),
    );
    Navigator.of(context).maybePop();
  }

  Future<void> _deleteWorkout() async {
    final workout = widget.workout;
    if (workout == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus workout?'),
          content: const Text(
            'Data workout akan dihapus dari log dan tidak bisa dikembalikan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    await context.read<FitnessStore>().deleteWorkout(workout.id);
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout dihapus dari log.')),
    );
    Navigator.of(context).maybePop();
  }
}
