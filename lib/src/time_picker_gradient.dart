import 'package:flutter/material.dart';

/// Defines the gradient colors used for the AM and PM states of the picker.
///
/// Use one of the built-in presets (e.g. [TimePickerGradient.defaultGradient]).
// ignore: use_enums
class TimePickerGradient {
  const TimePickerGradient._({
    required this.amColors,
    required this.pmColors,
    required this.amTextColor,
    required this.pmTextColor,
  });

  /// The gradient colors displayed during AM hours.
  final List<Color> amColors;

  /// The gradient colors displayed during PM hours.
  final List<Color> pmColors;

  /// The base color for wheel text and the colon during AM hours.
  final Color amTextColor;

  /// The base color for wheel text and the colon during PM hours.
  final Color pmTextColor;

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
    amTextColor: Colors.white,
    pmTextColor: Colors.white,
  );

  /// A soft dawn-to-dusk palette: blush lavender for AM,
  /// deep indigo-plum for PM.
  static const moonrise = TimePickerGradient._(
    amColors: [
      Color(0xFFDAE2F8),
      Color(0xFFD8C3CE),
      Color(0xFFD6A4A4),
    ],
    pmColors: [
      Color(0xFF253247),
      Color(0xFF31313F),
      Color(0xFF4A2F2F),
    ],
    amTextColor: Color(0xFF2C2C2C),
    pmTextColor: Colors.white,
  );

  /// A pearlescent palette: pale lime-yellow to muted mauve for AM,
  /// olive-green to muted mauve for PM.
  static const opal = TimePickerGradient._(
    amColors: [
      Color(0xFFE7E9BB),
      Color(0xFF827D8F),
    ],
    pmColors: [
      Color(0xFF7A7840),
      Color(0xFF3C3849),
    ],
    amTextColor: Color(0xFF2C2C2C),
    pmTextColor: Colors.white,
  );

  /// A misty slate palette: hazy grey-blue for AM, deep slate for PM.
  static const mystic = TimePickerGradient._(
    amColors: [
      Color(0xFF757F9A),
      Color(0xFFD7DDE8),
    ],
    pmColors: [
      Color(0xFF757F9A),
      Color(0xFF2C3445),
    ],
    amTextColor: Color(0xFF2C2C2C),
    pmTextColor: Colors.white,
  );

  /// A soft frosted-glass palette: light blue-white for AM,
  /// dark teal-navy for PM.
  static const frostedLight = TimePickerGradient._(
    amColors: [
      Color(0xFFEBF4F5),
      Color(0xFFCCDEED),
      Color(0xFFB5C6E0),
    ],
    pmColors: [
      Color(0xFF1F3A3D),
      Color(0xFF162C33),
      Color(0xFF111A28),
    ],
    amTextColor: Color(0xFF2C2C2C),
    pmTextColor: Colors.white,
  );
}
