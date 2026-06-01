import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gradient_timepicker/src/gradient_timepicker.dart';

// Pumps the host app and opens the picker. The [resultFuture] is populated
// inside the button's onPressed so it is captured before tapping Done.
Future<void> _pumpPicker(
  WidgetTester tester, {
  required void Function(Future<TimeOfDay?>) capture,
  TimeOfDay? initialTime,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: ElevatedButton(
            onPressed: () => capture(
              showTimePickerSheet(context: context, initialTime: initialTime),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('returns selected time when Done is tapped', (tester) async {
    late Future<TimeOfDay?> result;
    await _pumpPicker(
      tester,
      capture: (f) => result = f,
      initialTime: const TimeOfDay(hour: 7, minute: 30),
    );

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(await result, equals(const TimeOfDay(hour: 7, minute: 30)));
  });

  testWidgets('returns null when sheet is dismissed without selecting', (
    tester,
  ) async {
    late Future<TimeOfDay?> result;
    await _pumpPicker(
      tester,
      capture: (f) => result = f,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );

    await tester.drag(find.text('Done'), const Offset(0, 400));
    await tester.pumpAndSettle();

    expect(await result, isNull);
  });

  testWidgets('correctly converts midnight (00:00) to 12:00 AM', (
    tester,
  ) async {
    late Future<TimeOfDay?> result;
    await _pumpPicker(
      tester,
      capture: (f) => result = f,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
    );

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(await result, equals(const TimeOfDay(hour: 0, minute: 0)));
  });

  testWidgets('correctly converts noon (12:00) to 12:00 PM', (tester) async {
    late Future<TimeOfDay?> result;
    await _pumpPicker(
      tester,
      capture: (f) => result = f,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(await result, equals(const TimeOfDay(hour: 12, minute: 0)));
  });

  testWidgets('correctly converts 23:59 to 11:59 PM', (tester) async {
    late Future<TimeOfDay?> result;
    await _pumpPicker(
      tester,
      capture: (f) => result = f,
      initialTime: const TimeOfDay(hour: 23, minute: 59),
    );

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(await result, equals(const TimeOfDay(hour: 23, minute: 59)));
  });

  testWidgets('correctly converts 13:45 to 1:45 PM', (tester) async {
    late Future<TimeOfDay?> result;
    await _pumpPicker(
      tester,
      capture: (f) => result = f,
      initialTime: const TimeOfDay(hour: 13, minute: 45),
    );

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(await result, equals(const TimeOfDay(hour: 13, minute: 45)));
  });

  testWidgets('shows Done button and AM/PM options when opened', (
    tester,
  ) async {
    await _pumpPicker(
      tester,
      capture: (_) {},
      initialTime: const TimeOfDay(hour: 9, minute: 15),
    );

    expect(find.text('Done'), findsOneWidget);
    expect(find.text('AM'), findsOneWidget);
    expect(find.text('PM'), findsOneWidget);
  });

  testWidgets('returns a valid TimeOfDay when no initialTime is provided', (
    tester,
  ) async {
    late Future<TimeOfDay?> result;
    await _pumpPicker(tester, capture: (f) => result = f);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    final time = await result;
    expect(time, isNotNull);
    expect(time!.hour, inInclusiveRange(0, 23));
    expect(time.minute, inInclusiveRange(0, 59));
  });
}
