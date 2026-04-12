import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:olahraga/app_data.dart';
import 'package:olahraga/fitness_store.dart';
import 'package:olahraga/main.dart';
import 'package:olahraga/views/reservation.dart';
import 'package:olahraga/views/signup.dart';
import 'package:olahraga/views/VerifyPhoneNumber.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<FitnessStore> createLoadedStore() async {
    final store = FitnessStore();
    await store.load();
    return store;
  }

  test('formatWorkoutDateTime returns readable output', () {
    final workout = AppData.seedWorkoutLogs.first;
    final label = formatWorkoutDateTime(workout.date);

    expect(label, isNotEmpty);
    expect(label, contains('·'));
  });

  test('resetAllData clears all persisted fitness data', () async {
    final store = await createLoadedStore();

    expect(store.workouts, isNotEmpty);
    expect(store.bodyMetrics, isNotEmpty);
    expect(store.profile, isNotNull);

    await store.resetAllData();

    expect(store.workouts, isEmpty);
    expect(store.bodyMetrics, isEmpty);
    expect(store.profile, isNull);

    final reloadedStore = FitnessStore();
    await reloadedStore.load();

    expect(reloadedStore.workouts, isEmpty);
    expect(reloadedStore.bodyMetrics, isEmpty);
    expect(reloadedStore.profile, isNull);
  });

  testWidgets('profile setup saves user profile', (tester) async {
    final store = await createLoadedStore();

    await tester.pumpWidget(
      ChangeNotifierProvider<FitnessStore>.value(
        value: store,
        child: const MaterialApp(home: SignupWidget()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Rizlrad');
    await tester.enterText(find.byType(TextFormField).at(1), '172');
    await tester.enterText(find.byType(TextFormField).at(2), '5');
    await tester.enterText(find.byType(TextFormField).at(3), '74.2');
    await tester.enterText(find.byType(TextFormField).at(4), '69.5');

    await tester.tap(find.widgetWithText(FilledButton, 'Simpan profil'));
    await tester.pumpAndSettle();

    expect(store.profile, isNotNull);
    expect(store.profile!.name, 'Rizlrad');
    expect(store.profile!.activityGoalPerWeek, 5);
  });

  testWidgets('workout editor adds new workout log', (tester) async {
    final store = await createLoadedStore();
    final initialCount = store.workouts.length;

    await tester.pumpWidget(
      ChangeNotifierProvider<FitnessStore>.value(
        value: store,
        child: const MaterialApp(home: ReservationWidget()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Evening HIIT');
    await tester.enterText(find.byType(TextFormField).at(1), '40');
    await tester.enterText(find.byType(TextFormField).at(2), '360');
    await tester.enterText(
      find.byType(TextFormField).at(3),
      'Circuit workout after office hours',
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Simpan workout'));
    await tester.pumpAndSettle();

    expect(store.workouts.length, initialCount + 1);
    expect(
      store.workouts.any((item) => item.workoutName == 'Evening HIIT'),
      isTrue,
    );
  });

  testWidgets('body progress entry is persisted', (tester) async {
    final store = await createLoadedStore();
    final initialCount = store.bodyMetrics.length;

    await tester.pumpWidget(
      ChangeNotifierProvider<FitnessStore>.value(
        value: store,
        child: const MaterialApp(home: VerifyPhoneNumberWidget()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '70.9');
    await tester.enterText(find.byType(TextFormField).at(1), '171');
    await tester.enterText(find.byType(TextFormField).at(2), 'Weekly check-in');

    await tester.tap(find.widgetWithText(FilledButton, 'Simpan progress tubuh'));
    await tester.pumpAndSettle();

    expect(store.bodyMetrics.length, initialCount + 1);
    expect(store.latestBodyMetric, isNotNull);
    expect(store.latestBodyMetric!.weightKg, 70.9);
  });

  testWidgets('dashboard tab navigation opens workout log and back',
      (tester) async {
    final store = await createLoadedStore();

    await tester.pumpWidget(
      ChangeNotifierProvider<FitnessStore>.value(
        value: store,
        child: const OlahragaApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Manual Fitness Tracker'), findsOneWidget);

    await tester.tap(find.text('Workout Log').last);
    await tester.pumpAndSettle();

    expect(find.text('Workout Log'), findsWidgets);

    await tester.tap(find.text('Dashboard').last);
    await tester.pumpAndSettle();

    expect(find.text('Manual Fitness Tracker'), findsOneWidget);
  });
}
