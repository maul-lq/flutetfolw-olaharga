import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'app_data.dart';
import 'fitness_store.dart';
import 'views/Home.dart';
import 'views/Reservation.dart';
import 'views/Signup.dart';
import 'views/Upcoming.dart';
import 'views/VerifyPhoneNumber.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => FitnessStore()..load(),
      child: const OlahragaApp(),
    ),
  );
}

class OlahragaApp extends StatelessWidget {
  const OlahragaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1D4ED8),
      scaffoldBackgroundColor: const Color(0xFFF6F8FC),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manual Fitness Tracker',
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFDBEAFE),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF1D4ED8)
                  : const Color(0xFF64748B),
            );
          }),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 52),
            side: const BorderSide(color: Color(0xFFCBD5E1)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.3),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const DashboardShell(),
    );
  }
}

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;

  Future<void> _openWorkoutDetail([WorkoutLog? workout]) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReservationWidget(workout: workout),
      ),
    );
  }

  void _openProfileSetup() {
    setState(() => _currentIndex = 2);
  }

  void _openBodyProgress() {
    setState(() => _currentIndex = 3);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeWidget(
        onSelectWorkout: (workout) => _openWorkoutDetail(workout),
        onAddWorkout: () => _openWorkoutDetail(),
        onAddBodyProgress: _openBodyProgress,
        onOpenUpcoming: () => setState(() => _currentIndex = 1),
        onOpenSignup: _openProfileSetup,
      ),
      UpcomingWidget(
        onSelectWorkout: (workout) => _openWorkoutDetail(workout),
        onAddWorkout: () => _openWorkoutDetail(),
        onStartExploring: () => setState(() => _currentIndex = 0),
      ),
      SignupWidget(
        onBack: () => setState(() => _currentIndex = 0),
      ),
      VerifyPhoneNumberWidget(
        onBack: () => setState(() => _currentIndex = 0),
      ),
    ];

    final labels = ['Dashboard', 'Workout Log', 'Profile', 'Body Progress'];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: labels[0],
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month),
            label: labels[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            selectedIcon: const Icon(Icons.person_add_alt_1),
            label: labels[2],
          ),
          NavigationDestination(
            icon: const Icon(Icons.monitor_weight_outlined),
            selectedIcon: const Icon(Icons.monitor_weight),
            label: labels[3],
          ),
        ],
      ),
    );
  }
}
