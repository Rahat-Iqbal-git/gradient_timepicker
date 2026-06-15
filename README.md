# Gradient Timepicker

[![pub.dev][pub_badge]][pub_link]
[![License: MIT][license_badge]][license_link]

A beautiful gradient time picker for Flutter. Opens as a bottom sheet with smooth scroll-wheel selection for hour, minute, and AM/PM. The background gradient animates between a bright blue (AM) and deep navy (PM) theme.

---

## Showcase

![Gradient Timepicker demo](https://raw.githubusercontent.com/Rahat-Iqbal-git/gradient_timepicker/main/assets/demo.gif)

---

## Features

- Wheel-style scroll pickers for hour, minute, and AM/PM
- Animated gradient background that shifts between AM and PM colour schemes
- Returns the selected `TimeOfDay`, or `null` if dismissed
- Accepts an optional `initialTime`; falls back to `TimeOfDay.now()`
- Safe-area aware bottom padding

---

## Installation

```sh
flutter pub add gradient_timepicker
```

---

## Usage

```dart
import 'package:gradient_timepicker/gradient_timepicker.dart';

// Inside a widget with a BuildContext:
final TimeOfDay? picked = await showTimePickerSheet(
  context: context,
  initialTime: TimeOfDay.now(),
);

if (picked != null) {
  print('Selected: ${picked.format(context)}');
}
```

---

## API

### `showTimePickerSheet`

```dart
Future<TimeOfDay?> showTimePickerSheet({
  required BuildContext context,
  TimeOfDay? initialTime,
  bool use24Hour = false,
  String buttonText = 'Done',
  TimePickerGradient gradient = TimePickerGradient.defaultGradient,
})
```

| Parameter     | Type                  | Required | Description                                                            |
|---------------|-----------------------|----------|------------------------------------------------------------------------|
| `context`     | `BuildContext`        | yes      | The build context used to show the bottom sheet.                       |
| `initialTime` | `TimeOfDay?`          | no       | Pre-selected time. Defaults to `TimeOfDay.now()`                       |
| `use24Hour`   | `bool`                | no       | Display a 24-hour clock without AM/PM. Defaults to `false`             |
| `buttonText`  | `String`              | no       | Label for the confirm button. Defaults to `'Done'`                     |
| `gradient`    | `TimePickerGradient`  | no       | Color palette for AM/PM states. Defaults to `TimePickerGradient.defaultGradient` |

**Returns** the `TimeOfDay` chosen by the user, or `null` if the sheet is dismissed.

#### Built-in Gradients

- `TimePickerGradient.defaultGradient` — Bright blue AM, deep navy PM
- `TimePickerGradient.frostedLight` — Light blue-white AM, dark teal PM

---

## Running Tests

```sh
flutter test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov):

```sh
genhtml coverage/lcov.info -o coverage/
open coverage/index.html
```

---

[pub_badge]: https://img.shields.io/pub/v/gradient_timepicker.svg
[pub_link]: https://pub.dev/packages/gradient_timepicker
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
