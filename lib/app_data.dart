import 'package:intl/intl.dart';

enum WorkoutIntensity { low, medium, high }

extension WorkoutIntensityLabel on WorkoutIntensity {
  String get label {
    switch (this) {
      case WorkoutIntensity.low:
        return 'Low';
      case WorkoutIntensity.medium:
        return 'Medium';
      case WorkoutIntensity.high:
        return 'High';
    }
  }

  static WorkoutIntensity fromLabel(String value) {
    return WorkoutIntensity.values.firstWhere(
      (item) => item.label.toLowerCase() == value.toLowerCase(),
      orElse: () => WorkoutIntensity.medium,
    );
  }
}

class WorkoutLog {
  const WorkoutLog({
    required this.id,
    required this.date,
    required this.workoutName,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurnedEstimate,
    required this.notes,
    required this.intensity,
    required this.isCompleted,
  });

  final String id;
  final DateTime date;
  final String workoutName;
  final String category;
  final int durationMinutes;
  final int caloriesBurnedEstimate;
  final String notes;
  final WorkoutIntensity intensity;
  final bool isCompleted;

  WorkoutLog copyWith({
    String? id,
    DateTime? date,
    String? workoutName,
    String? category,
    int? durationMinutes,
    int? caloriesBurnedEstimate,
    String? notes,
    WorkoutIntensity? intensity,
    bool? isCompleted,
  }) {
    return WorkoutLog(
      id: id ?? this.id,
      date: date ?? this.date,
      workoutName: workoutName ?? this.workoutName,
      category: category ?? this.category,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurnedEstimate:
          caloriesBurnedEstimate ?? this.caloriesBurnedEstimate,
      notes: notes ?? this.notes,
      intensity: intensity ?? this.intensity,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'workoutName': workoutName,
      'category': category,
      'durationMinutes': durationMinutes,
      'caloriesBurnedEstimate': caloriesBurnedEstimate,
      'notes': notes,
      'intensity': intensity.name,
      'isCompleted': isCompleted,
    };
  }

  factory WorkoutLog.fromMap(Map<String, dynamic> map) {
    return WorkoutLog(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      workoutName: map['workoutName'] as String,
      category: map['category'] as String,
      durationMinutes: (map['durationMinutes'] as num).toInt(),
      caloriesBurnedEstimate: (map['caloriesBurnedEstimate'] as num).toInt(),
      notes: (map['notes'] as String?) ?? '',
      intensity: WorkoutIntensity.values.firstWhere(
        (value) => value.name == map['intensity'],
        orElse: () => WorkoutIntensity.medium,
      ),
      isCompleted: (map['isCompleted'] as bool?) ?? false,
    );
  }
}

class BodyMetricEntry {
  const BodyMetricEntry({
    required this.id,
    required this.date,
    required this.weightKg,
    required this.heightCm,
    required this.note,
  });

  final String id;
  final DateTime date;
  final double weightKg;
  final double heightCm;
  final String note;

  BodyMetricEntry copyWith({
    String? id,
    DateTime? date,
    double? weightKg,
    double? heightCm,
    String? note,
  }) {
    return BodyMetricEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'weightKg': weightKg,
      'heightCm': heightCm,
      'note': note,
    };
  }

  factory BodyMetricEntry.fromMap(Map<String, dynamic> map) {
    return BodyMetricEntry(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      weightKg: (map['weightKg'] as num).toDouble(),
      heightCm: (map['heightCm'] as num).toDouble(),
      note: (map['note'] as String?) ?? '',
    );
  }
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.heightCm,
    required this.targetWeightKg,
    required this.activityGoalPerWeek,
    required this.initialWeightKg,
  });

  final String name;
  final double heightCm;
  final double targetWeightKg;
  final int activityGoalPerWeek;
  final double initialWeightKg;

  UserProfile copyWith({
    String? name,
    double? heightCm,
    double? targetWeightKg,
    int? activityGoalPerWeek,
    double? initialWeightKg,
  }) {
    return UserProfile(
      name: name ?? this.name,
      heightCm: heightCm ?? this.heightCm,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activityGoalPerWeek: activityGoalPerWeek ?? this.activityGoalPerWeek,
      initialWeightKg: initialWeightKg ?? this.initialWeightKg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'heightCm': heightCm,
      'targetWeightKg': targetWeightKg,
      'activityGoalPerWeek': activityGoalPerWeek,
      'initialWeightKg': initialWeightKg,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String,
      heightCm: (map['heightCm'] as num).toDouble(),
      targetWeightKg: (map['targetWeightKg'] as num).toDouble(),
      activityGoalPerWeek: (map['activityGoalPerWeek'] as num).toInt(),
      initialWeightKg: (map['initialWeightKg'] as num).toDouble(),
    );
  }
}

class WorkoutTemplate {
  const WorkoutTemplate({
    required this.name,
    required this.category,
    required this.durationMinutes,
    required this.estimatedCalories,
    required this.intensity,
    this.notes = '',
  });

  final String name;
  final String category;
  final int durationMinutes;
  final int estimatedCalories;
  final WorkoutIntensity intensity;
  final String notes;
}

class FitnessSession {
  const FitnessSession({
    required this.id,
    required this.title,
    required this.studio,
    required this.location,
    required this.category,
    required this.instructor,
    required this.description,
    required this.imageUrl,
    required this.startTime,
    required this.durationMinutes,
    required this.credits,
    required this.rating,
    required this.reviewCount,
    required this.distanceMiles,
    this.previousCredits,
    this.isReserved = false,
  });

  final String id;
  final String title;
  final String studio;
  final String location;
  final String category;
  final String instructor;
  final String description;
  final String imageUrl;
  final DateTime startTime;
  final int durationMinutes;
  final int credits;
  final int? previousCredits;
  final double rating;
  final int reviewCount;
  final double distanceMiles;
  final bool isReserved;

  DateTime get endTime => startTime.add(Duration(minutes: durationMinutes));

  String get distanceLabel => '${distanceMiles.toStringAsFixed(1)} mi';

  String get ratingLabel => rating.toStringAsFixed(1);

  String get reviewCountLabel =>
      '(${NumberFormat.compact().format(reviewCount)}+)';

  String get creditsLabel {
    if (previousCredits != null && previousCredits! > credits) {
      return '$credits credits · was $previousCredits';
    }
    return '$credits credits';
  }
}

String formatWorkoutDate(DateTime date) {
  return DateFormat('EEE, d MMM yyyy').format(date);
}

String formatWorkoutDateTime(DateTime date) {
  return DateFormat('EEE, d MMM · HH:mm').format(date);
}

String formatDurationMinutes(int minutes) {
  if (minutes < 60) {
    return '$minutes min';
  }
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  if (remainder == 0) {
    return '$hours h';
  }
  return '$hours h $remainder min';
}

String formatSessionSchedule(FitnessSession session) {
  final dayLabel = _relativeDay(session.startTime);
  final dateLabel = DateFormat('MMM d').format(session.startTime);
  final startLabel = DateFormat('h:mm a').format(session.startTime);
  final endLabel = DateFormat('h:mm a').format(session.endTime);
  return '$dayLabel, $dateLabel · $startLabel - $endLabel';
}

String formatStudioLine(FitnessSession session) =>
    '[${session.studio}] · ${session.location}';

String _relativeDay(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final diff = target.difference(today).inDays;

  if (diff == 0) {
    return 'Today';
  }
  if (diff == 1) {
    return 'Tomorrow';
  }
  return DateFormat('EEE').format(date);
}

class AppData {
  static DateTime _slot(int dayOffset, int hour, int minute) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + dayOffset, hour, minute);
  }

  static const List<String> workoutCategories = [
    'Strength',
    'Cardio',
    'Mobility',
    'Yoga',
    'HIIT',
    'Core',
    'Recovery',
  ];

  static const List<WorkoutTemplate> quickWorkoutTemplates = [
    WorkoutTemplate(
      name: 'Full Body Strength',
      category: 'Strength',
      durationMinutes: 50,
      estimatedCalories: 420,
      intensity: WorkoutIntensity.high,
    ),
    WorkoutTemplate(
      name: 'Morning Run',
      category: 'Cardio',
      durationMinutes: 30,
      estimatedCalories: 260,
      intensity: WorkoutIntensity.medium,
    ),
    WorkoutTemplate(
      name: 'Mobility Reset',
      category: 'Mobility',
      durationMinutes: 20,
      estimatedCalories: 95,
      intensity: WorkoutIntensity.low,
    ),
  ];

  static final List<WorkoutLog> seedWorkoutLogs = [
    WorkoutLog(
      id: 'workout-seed-1',
      date: _slot(-1, 18, 30),
      workoutName: 'Upper Body Push Day',
      category: 'Strength',
      durationMinutes: 55,
      caloriesBurnedEstimate: 410,
      notes: 'Bench press, incline DB press, shoulder press.',
      intensity: WorkoutIntensity.high,
      isCompleted: true,
    ),
    WorkoutLog(
      id: 'workout-seed-2',
      date: _slot(-3, 7, 0),
      workoutName: 'Tempo Run',
      category: 'Cardio',
      durationMinutes: 35,
      caloriesBurnedEstimate: 300,
      notes: 'Easy pace + 4 x 3 min tempo block.',
      intensity: WorkoutIntensity.medium,
      isCompleted: true,
    ),
    WorkoutLog(
      id: 'workout-seed-3',
      date: _slot(1, 19, 0),
      workoutName: 'Core and Mobility',
      category: 'Mobility',
      durationMinutes: 30,
      caloriesBurnedEstimate: 140,
      notes: 'Plank circuit and hip opener routine.',
      intensity: WorkoutIntensity.low,
      isCompleted: false,
    ),
  ];

  static final List<BodyMetricEntry> seedBodyMetrics = [
    BodyMetricEntry(
      id: 'metric-seed-1',
      date: _slot(-7, 7, 15),
      weightKg: 72.4,
      heightCm: 171,
      note: 'Baseline minggu ini.',
    ),
    BodyMetricEntry(
      id: 'metric-seed-2',
      date: _slot(-1, 7, 20),
      weightKg: 71.9,
      heightCm: 171,
      note: 'Lebih konsisten cardio.',
    ),
  ];

  static const UserProfile seedProfile = UserProfile(
    name: 'Athlete',
    heightCm: 171,
    targetWeightKg: 69,
    activityGoalPerWeek: 4,
    initialWeightKg: 72.4,
  );

  static final List<FitnessSession> bookAgainSessions = [
    FitnessSession(
      id: 'erin-fitness',
      title: 'Erin Cantrell Fitness',
      studio: 'ClassPass',
      location: 'Downtown Austin',
      category: 'Strength Training, Yoga',
      instructor: 'Erin Cantrell',
      description:
          'A feel-good full body session that blends mobility, core stability, and strength intervals so you leave energized instead of exhausted.',
      imageUrl:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1200&q=80',
      startTime: _slot(1, 16, 20),
      durationMinutes: 50,
      credits: 6,
      rating: 5.0,
      reviewCount: 500,
      distanceMiles: 4.7,
    ),
    FitnessSession(
      id: 'cycle-lab',
      title: 'Cycle Lab Express',
      studio: 'Spin Society',
      location: 'South Congress',
      category: 'Cycling, Cardio',
      instructor: 'Nadia Flores',
      description:
          'A fast-paced ride with structured climbs and sprints that fits neatly into a lunch break.',
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80',
      startTime: _slot(2, 12, 15),
      durationMinutes: 45,
      credits: 5,
      rating: 4.8,
      reviewCount: 320,
      distanceMiles: 3.2,
    ),
  ];

  static final List<FitnessSession> priceDropSessions = [
    FitnessSession(
      id: 'solidcore-full-body',
      title: 'Full Body',
      studio: 'solidcore',
      location: 'Ann Arbor',
      category: 'Pilates',
      instructor: 'Sydney Maddox',
      description:
          'A challenging reformer-inspired workout focused on slow tempo strength, core activation, and total-body endurance.',
      imageUrl:
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&w=1200&q=80',
      startTime: _slot(1, 10, 10),
      durationMinutes: 50,
      credits: 6,
      previousCredits: 8,
      rating: 4.9,
      reviewCount: 5000,
      distanceMiles: 2.1,
    ),
    FitnessSession(
      id: 'hiit-45',
      title: 'HIIT 45 Strength & Endurance',
      studio: 'Train Yard',
      location: 'North Loop',
      category: 'HIIT',
      instructor: 'Marcus Hill',
      description:
          'Intervals on the rower, bike, and floor with scalable progressions for all levels.',
      imageUrl:
          'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&w=1200&q=80',
      startTime: _slot(2, 9, 30),
      durationMinutes: 45,
      credits: 5,
      previousCredits: 7,
      rating: 4.7,
      reviewCount: 1800,
      distanceMiles: 5.4,
    ),
  ];

  static final List<FitnessSession> upcomingSessions = [
    FitnessSession(
      id: 'upcoming-full-body',
      title: 'Full Body',
      studio: 'solidcore',
      location: 'Ann Arbor',
      category: 'Pilates',
      instructor: 'Vern Hapman · Core Crew',
      description:
          'A reservation-ready version of the popular full body sequence with cues focused on posture, controlled tempo, and core engagement.',
      imageUrl:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1200&q=80',
      startTime: _slot(1, 16, 20),
      durationMinutes: 50,
      credits: 6,
      rating: 4.9,
      reviewCount: 5000,
      distanceMiles: 2.1,
      isReserved: true,
    ),
    FitnessSession(
      id: 'upcoming-hiit',
      title: 'HIIT 45 Strength and Endurance',
      studio: 'Train Yard',
      location: 'North Loop',
      category: 'HIIT',
      instructor: 'Ari Benson',
      description:
          'Intervals that alternate between power output and recovery blocks so you build capacity without losing form.',
      imageUrl:
          'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=1200&q=80',
      startTime: _slot(2, 9, 30),
      durationMinutes: 45,
      credits: 5,
      rating: 4.8,
      reviewCount: 2800,
      distanceMiles: 3.8,
      isReserved: true,
    ),
  ];

  static const List<String> phoneCountryCodes = ['+1', '+62', '+65', '+66'];
}
