import 'package:flutter/material.dart';

import '../app_data.dart';
import '../views/reservation.dart';
import '../views/signup.dart';
import '../views/upcoming.dart';
import '../views/VerifyPhoneNumber.dart';

extension FlutterFlowListSpacing<T> on List<T> {
  List<T> divide(T separator) {
    if (isEmpty) return <T>[];
    final results = <T>[];
    for (var i = 0; i < length; i++) {
      results.add(this[i]);
      if (i != length - 1) {
        results.add(separator);
      }
    }
    return results;
  }

  List<T> addToStart(T item) => [item, ...this];
  List<T> addToEnd(T item) => [...this, item];
}

extension FlutterFlowNavigationCompat on BuildContext {
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? extra}) {
    Widget destination;
    switch (routeName) {
      case 'Reservation':
        final session =
            extra is FitnessSession ? extra : AppData.bookAgainSessions.first;
        destination = ReservationWidget(session: session);
      case 'Signup':
        destination = const SignupWidget();
      case 'Upcoming':
        destination = const UpcomingWidget();
      case 'VerifyPhoneNumber':
        destination = const VerifyPhoneNumberWidget();
      default:
        destination = const SignupWidget();
    }
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  void safePop<T extends Object?>([T? result]) =>
      Navigator.of(this).maybePop(result);
}

void safeSetState(VoidCallback callback) => callback();
