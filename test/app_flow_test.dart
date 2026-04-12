import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:olahraga/app_data.dart';
import 'package:olahraga/main.dart';
import 'package:olahraga/views/reservation.dart';
import 'package:olahraga/views/signup.dart';
import 'package:olahraga/views/VerifyPhoneNumber.dart';

void main() {
  test('formatSessionSchedule returns readable output', () {
    final session = AppData.bookAgainSessions.first;
    final label = formatSessionSchedule(session);

    expect(label, isNotEmpty);
    expect(label, contains(':'));
    expect(label, contains('·'));
  });

  testWidgets('signup flow navigates to verify phone number', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupWidget()));

    await tester.enterText(find.byType(TextFormField).at(0), 'Rizlrad');
    await tester.enterText(find.byType(TextFormField).at(1), 'Fz');
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'rizlrad@example.com',
    );
    await tester.pump();

    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign up');
    expect(signUpButton, findsOneWidget);
    expect(tester.widget<ElevatedButton>(signUpButton).onPressed, isNotNull);

    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    expect(find.byType(VerifyPhoneNumberWidget), findsOneWidget);
    expect(find.textContaining('rizlrad@example.com'), findsOneWidget);
  });

  testWidgets('reservation popups update booking state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReservationWidget(session: AppData.bookAgainSessions.first),
      ),
    );

    expect(find.widgetWithText(FilledButton, 'Reserve'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Reserve'));
    await tester.pumpAndSettle();

    expect(find.text('Checkout'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Confirm reservation'));
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(FilledButton, 'Cancel reservation'),
      findsOneWidget,
    );

    await tester
        .tap(find.widgetWithText(FilledButton, 'Cancel reservation').first);
    await tester.pumpAndSettle();

    expect(find.text('Confirm cancellation'), findsOneWidget);
    await tester.tap(
      find.widgetWithText(FilledButton, 'Cancel reservation').last,
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(FilledButton, 'Reserve'), findsOneWidget);
  });

  testWidgets('dashboard tab flow returns from Upcoming to Home',
      (tester) async {
    await tester.pumpWidget(const OlahragaApp());
    await tester.pumpAndSettle();

    expect(find.text('For you'), findsOneWidget);

    await tester.tap(find.text('Upcoming').last);
    await tester.pumpAndSettle();

    expect(find.text('Time to book!'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Start exploring'));
    await tester.pumpAndSettle();

    expect(find.text('For you'), findsOneWidget);
  });
}
