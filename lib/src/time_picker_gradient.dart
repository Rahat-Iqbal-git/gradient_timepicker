import 'package:flutter/material.dart';

/// Defines the gradient colors used for the AM and PM states of the picker.
///
/// Use one of the built-in presets (e.g. [TimePickerGradient.defaultGradient]).
class TimePickerGradient {
  const TimePickerGradient._({
    required this.amColors,
    required this.pmColors,
  });

  /// The three gradient colors displayed during AM hours.
  final List<Color> amColors;

  /// The three gradient colors displayed during PM hours.
  final List<Color> pmColors;

  /// The default blue-sky AM / deep-night PM palette.
  static const defaultGradient = TimePickerGradient._(
    amColors: [
      Color(0xFF007AFF),
      Color(0xFF1C4C8E),
      Color(0xFF6B7D8E),
    ],
    pmColors: [
      Color(0xFF0A0F2E),
      Color(0xFF1A3A8F),
      Color(0xFF1565C0),
    ],
  );

  /// A soft frosted-glass palette: light blue-white for AM,
  /// dark teal-navy for PM.
  static const frostedLight = TimePickerGradient._(
    amColors: [
      Color(0xFFEBF4F5),
      Color(0xFFB5C6E0),
    ],
    pmColors: [
      Color(0xFF1F3A3D),
      Color(0xFF111A28),
    ],
  );
}
