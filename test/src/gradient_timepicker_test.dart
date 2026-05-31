import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient_timepicker/src/gradient_timepicker.dart';

void main() {
  testWidgets('showTimePickerSheet returns selected time when Done is tapped', (
    tester,
  ) async {
    late Future<TimeOfDay?> resultFuture;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    resultFuture = showTimePickerSheet(
                      context: context,
                      initialTime: const TimeOfDay(hour: 7, minute: 30),
                    );
                  },
                  child: const Text('Open picker'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open picker'));
    await tester.pumpAndSettle();

    expect(find.text('Done'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    final result = await resultFuture;

    expect(result, isNotNull);
    expect(result, equals(const TimeOfDay(hour: 7, minute: 30)));
  });
}
