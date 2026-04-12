import 'package:intl/intl.dart';

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

  static final List<String> phoneCountryCodes = ['+1', '+62', '+65', '+66'];
}
