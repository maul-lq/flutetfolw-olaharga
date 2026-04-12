import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_data.dart';

class FitnessStore extends ChangeNotifier {
  static const String _workoutsKey = 'fitness.workouts';
  static const String _bodyMetricsKey = 'fitness.body_metrics';
  static const String _profileKey = 'fitness.user_profile';

  bool _isLoading = true;
  List<WorkoutLog> _workouts = <WorkoutLog>[];
  List<BodyMetricEntry> _bodyMetrics = <BodyMetricEntry>[];
  UserProfile? _profile;

  bool get isLoading => _isLoading;

  List<WorkoutLog> get workouts {
    final logs = List<WorkoutLog>.from(_workouts);
    logs.sort((a, b) => b.date.compareTo(a.date));
    return List<WorkoutLog>.unmodifiable(logs);
  }

  List<BodyMetricEntry> get bodyMetrics {
    final metrics = List<BodyMetricEntry>.from(_bodyMetrics);
    metrics.sort((a, b) => b.date.compareTo(a.date));
    return List<BodyMetricEntry>.unmodifiable(metrics);
  }

  UserProfile? get profile => _profile;

  List<WorkoutLog> get completedWorkouts =>
      workouts.where((item) => item.isCompleted).toList(growable: false);

  List<WorkoutLog> get plannedWorkouts =>
      workouts.where((item) => !item.isCompleted).toList(growable: false);

  WorkoutLog? get latestWorkout {
    if (workouts.isEmpty) {
      return null;
    }
    return workouts.first;
  }

  BodyMetricEntry? get latestBodyMetric {
    if (bodyMetrics.isEmpty) {
      return null;
    }
    return bodyMetrics.first;
  }

  BodyMetricEntry? get previousBodyMetric {
    if (bodyMetrics.length < 2) {
      return null;
    }
    return bodyMetrics[1];
  }

  double? get latestWeightDelta {
    final latest = latestBodyMetric;
    final previous = previousBodyMetric;
    if (latest == null || previous == null) {
      return null;
    }
    return latest.weightKg - previous.weightKg;
  }

  double? get bmi {
    final metric = latestBodyMetric;
    if (metric == null || metric.heightCm <= 0) {
      return null;
    }
    final heightMeter = metric.heightCm / 100;
    return metric.weightKg / (heightMeter * heightMeter);
  }

  int get workoutsThisWeek {
    final now = DateTime.now();
    final weekStart =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    return completedWorkouts
        .where((item) => !item.date.isBefore(weekStart))
        .length;
  }

  int get totalMinutesThisWeek {
    final now = DateTime.now();
    final weekStart =
        DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));

    return completedWorkouts
        .where((item) => !item.date.isBefore(weekStart))
        .fold<int>(0, (total, item) => total + item.durationMinutes);
  }

  int get currentStreak {
    if (completedWorkouts.isEmpty) {
      return 0;
    }

    final sorted = List<WorkoutLog>.from(completedWorkouts)
      ..sort((a, b) => b.date.compareTo(a.date));

    final uniqueDays = <DateTime>[];
    for (final workout in sorted) {
      final day = DateTime(workout.date.year, workout.date.month, workout.date.day);
      if (uniqueDays.isEmpty || uniqueDays.last != day) {
        uniqueDays.add(day);
      }
    }

    final today = DateTime.now();
    final currentDay = DateTime(today.year, today.month, today.day);

    if (uniqueDays.isNotEmpty &&
        uniqueDays.first != currentDay &&
        uniqueDays.first != currentDay.subtract(const Duration(days: 1))) {
      return 0;
    }

    var streak = 0;
    DateTime? previous;
    for (final day in uniqueDays) {
      if (previous == null) {
        streak = 1;
        previous = day;
        continue;
      }

      final diff = previous.difference(day).inDays;
      if (diff == 1) {
        streak += 1;
        previous = day;
      } else {
        break;
      }
    }

    return streak;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    _workouts = _loadWorkoutLogs(prefs);
    _bodyMetrics = _loadBodyMetrics(prefs);
    _profile = _loadProfile(prefs);

    if (_workouts.isEmpty) {
      _workouts = List<WorkoutLog>.from(AppData.seedWorkoutLogs);
    }
    if (_bodyMetrics.isEmpty) {
      _bodyMetrics = List<BodyMetricEntry>.from(AppData.seedBodyMetrics);
    }
    _profile ??= AppData.seedProfile;

    _isLoading = false;
    notifyListeners();

    await _persist();
  }

  Future<void> saveProfile(UserProfile profile) async {
    _profile = profile;

    final hasMetricForToday = bodyMetrics.any(
      (metric) =>
          metric.date.year == DateTime.now().year &&
          metric.date.month == DateTime.now().month &&
          metric.date.day == DateTime.now().day,
    );

    if (!hasMetricForToday && profile.initialWeightKg > 0 && profile.heightCm > 0) {
      _bodyMetrics.add(
        BodyMetricEntry(
          id: _newId('metric'),
          date: DateTime.now(),
          weightKg: profile.initialWeightKg,
          heightCm: profile.heightCm,
          note: 'Initial profile setup',
        ),
      );
    }

    notifyListeners();
    await _persist();
  }

  Future<void> addWorkout(WorkoutLog workout) async {
    _workouts.add(workout);
    notifyListeners();
    await _persist();
  }

  Future<void> updateWorkout(WorkoutLog workout) async {
    final index = _workouts.indexWhere((item) => item.id == workout.id);
    if (index == -1) {
      return;
    }
    _workouts[index] = workout;
    notifyListeners();
    await _persist();
  }

  Future<void> deleteWorkout(String id) async {
    _workouts.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persist();
  }

  Future<void> toggleWorkoutCompletion(String id, bool isCompleted) async {
    final index = _workouts.indexWhere((item) => item.id == id);
    if (index == -1) {
      return;
    }
    _workouts[index] = _workouts[index].copyWith(isCompleted: isCompleted);
    notifyListeners();
    await _persist();
  }

  Future<void> addBodyMetric(BodyMetricEntry metric) async {
    _bodyMetrics.add(metric);
    notifyListeners();
    await _persist();
  }

  Future<void> updateBodyMetric(BodyMetricEntry metric) async {
    final index = _bodyMetrics.indexWhere((item) => item.id == metric.id);
    if (index == -1) {
      return;
    }
    _bodyMetrics[index] = metric;
    notifyListeners();
    await _persist();
  }

  Future<void> deleteBodyMetric(String id) async {
    _bodyMetrics.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persist();
  }

  String _newId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }

  List<WorkoutLog> _loadWorkoutLogs(SharedPreferences prefs) {
    final raw = prefs.getString(_workoutsKey);
    if (raw == null || raw.isEmpty) {
      return <WorkoutLog>[];
    }

    try {
      final parsed = jsonDecode(raw) as List<dynamic>;
      return parsed
          .whereType<Map<String, dynamic>>()
          .map(WorkoutLog.fromMap)
          .toList(growable: true);
    } catch (_) {
      return <WorkoutLog>[];
    }
  }

  List<BodyMetricEntry> _loadBodyMetrics(SharedPreferences prefs) {
    final raw = prefs.getString(_bodyMetricsKey);
    if (raw == null || raw.isEmpty) {
      return <BodyMetricEntry>[];
    }

    try {
      final parsed = jsonDecode(raw) as List<dynamic>;
      return parsed
          .whereType<Map<String, dynamic>>()
          .map(BodyMetricEntry.fromMap)
          .toList(growable: true);
    } catch (_) {
      return <BodyMetricEntry>[];
    }
  }

  UserProfile? _loadProfile(SharedPreferences prefs) {
    final raw = prefs.getString(_profileKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutsValue = jsonEncode(_workouts.map((item) => item.toMap()).toList());
    final metricsValue = jsonEncode(_bodyMetrics.map((item) => item.toMap()).toList());

    await prefs.setString(_workoutsKey, workoutsValue);
    await prefs.setString(_bodyMetricsKey, metricsValue);
    if (_profile != null) {
      await prefs.setString(_profileKey, jsonEncode(_profile!.toMap()));
    }
  }
}
