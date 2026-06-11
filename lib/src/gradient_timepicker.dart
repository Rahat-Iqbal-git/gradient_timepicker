import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gradient_timepicker/src/time_picker_gradient.dart';

/// Displays a custom gradient time picker in a bottom sheet.
///
/// The sheet allows the user to select an hour, minute, and AM/PM period
/// using a wheel-style picker. The current time is used when [initialTime]
/// is not provided.
///
/// Set [use24Hour] to true to show a 24-hour clock without the AM/PM wheel.
///
/// Returns the selected [TimeOfDay] when the user taps the "Done" button,
/// or `null` if the sheet is dismissed without choosing a time.
Future<TimeOfDay?> showTimePickerSheet({
  required BuildContext context,
  TimeOfDay? initialTime,
  bool use24Hour = false,
  String buttonText = 'Done',
  TimePickerGradient gradient = TimePickerGradient.defaultGradient,
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => TimePickerSheet(
      initialTime: initialTime,
      use24Hour: use24Hour,
      buttonText: buttonText,
      gradient: gradient,
    ),
  );
}

/// A stateful widget that renders the custom gradient time picker UI.
///
/// This widget displays hour, minute, and AM/PM wheels inside a modal
/// bottom sheet, allowing the user to choose a time with a polished,
/// animated gradient background. It is typically created by
/// [showTimePickerSheet] and accepts an optional [initialTime]
/// to preselect the starting value.
///
/// Set [use24Hour] to true to show a 24-hour clock without the AM/PM wheel.
class TimePickerSheet extends StatefulWidget {
  /// Creates a [TimePickerSheet], optionally pre-selecting [initialTime].
  const TimePickerSheet({
    super.key,
    this.initialTime,
    this.use24Hour = false,
    this.buttonText = 'Done',
    this.gradient = TimePickerGradient.defaultGradient,
  });

  /// The time pre-selected when the picker opens.
  /// Defaults to [TimeOfDay.now] if null.
  final TimeOfDay? initialTime;

  /// Whether to use 24-hour format. Defaults to false.
  final bool use24Hour;

  /// The label displayed on the confirm button. Defaults to 'Done'.
  final String buttonText;

  /// The gradient color preset for AM and PM states.
  /// Defaults to [TimePickerGradient.defaultGradient].
  final TimePickerGradient gradient;

  @override
  State<TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<TimePickerSheet>
    with TickerProviderStateMixin {
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  FixedExtentScrollController? _periodController;
  late final AnimationController _textColorController;
  late final Animation<Color?> _textColorAnimation;

  late final List<String> _hours;
  final List<String> _minutes = List.generate(
    60,
    (i) => i.toString().padLeft(2, '0'),
  );
  final List<String> _periods = ['AM', 'PM'];

  late int _selectedHour;
  late int _selectedMinute;
  late int _selectedPeriod;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialTime ?? TimeOfDay.now();
    final h = initial.hour;

    if (widget.use24Hour) {
      _hours = List.generate(24, (i) => i.toString().padLeft(2, '0'));
      _selectedHour = h;
      _selectedPeriod = h < 12 ? 0 : 1;
    } else {
      _hours = List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
      _selectedPeriod = h < 12 ? 0 : 1;
      final hour12 = h % 12 == 0 ? 12 : h % 12;
      _selectedHour = hour12 - 1;
    }
    _selectedMinute = initial.minute;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinute,
    );
    if (!widget.use24Hour) {
      _periodController = FixedExtentScrollController(
        initialItem: _selectedPeriod,
      );
    }
    _textColorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      value: _selectedPeriod.toDouble(),
    );
    _textColorAnimation =
        ColorTween(
          begin: widget.gradient.amTextColor,
          end: widget.gradient.pmTextColor,
        ).animate(
          CurvedAnimation(
            parent: _textColorController,
            curve: Curves.easeInOut,
          ),
        );
    _textColorAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController?.dispose();
    _textColorController.dispose();
    super.dispose();
  }

  void _onPeriodChanged(int i) {
    setState(() => _selectedPeriod = i);
    if (i == 0) {
      unawaited(_textColorController.reverse());
    } else {
      unawaited(_textColorController.forward());
    }
  }

  void _onDone() {
    final int hour;
    if (widget.use24Hour) {
      hour = _selectedHour;
    } else {
      final hour12 = _selectedHour + 1;
      if (_selectedPeriod == 0) {
        hour = hour12 == 12 ? 0 : hour12;
      } else {
        hour = hour12 == 12 ? 12 : hour12 + 12;
      }
    }
    Navigator.of(context).pop(TimeOfDay(hour: hour, minute: _selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.7;
    final wheelsHeight = height - 120;
    final textColor = _textColorAnimation.value ?? widget.gradient.amTextColor;
    return SizedBox(
      height: height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _selectedPeriod == 0
                ? widget.gradient.amColors
                : widget.gradient.pmColors,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: wheelsHeight,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 110,
                        child: _WheelColumn(
                          controller: _hourController,
                          items: _hours,
                          selectedIndex: _selectedHour,
                          onSelectedItemChanged: (i) => setState(
                            () => _selectedHour = i,
                          ),
                          alignment: Alignment.centerRight,
                          textColor: textColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 4,
                          left: widget.use24Hour ? 10 : 0,
                          right: widget.use24Hour ? 10 : 0,
                        ),
                        child: Text(
                          ':',
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.9),
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        child: _WheelColumn(
                          controller: _minuteController,
                          items: _minutes,
                          selectedIndex: _selectedMinute,
                          onSelectedItemChanged: (i) =>
                              setState(() => _selectedMinute = i),
                          alignment: Alignment.centerLeft,
                          textColor: textColor,
                        ),
                      ),
                      if (!widget.use24Hour)
                        SizedBox(
                          width: 64,
                          child: _PeriodColumn(
                            controller: _periodController!,
                            periods: _periods,
                            selectedIndex: _selectedPeriod,
                            onSelectedItemChanged: _onPeriodChanged,
                            textColor: textColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: () {
                  final inset = MediaQuery.viewPaddingOf(context).bottom;
                  return inset < 40 ? 16.0 + inset : 16.0;
                }(),
                top: 14,
              ),
              child: ElevatedButton(
                onPressed: _onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.black87,
                  minimumSize: const Size(200, 52),
                  maximumSize: Size(
                    MediaQuery.sizeOf(context).width * 0.8,
                    52,
                  ),
                  shape: const StadiumBorder(),
                  elevation: 0,
                ),
                child: Text(
                  widget.buttonText,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WheelColumn extends StatefulWidget {
  const _WheelColumn({
    required this.controller,
    required this.items,
    required this.selectedIndex,
    required this.onSelectedItemChanged,
    required this.alignment,
    required this.textColor,
  });

  final FixedExtentScrollController controller;
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelectedItemChanged;
  final Alignment alignment;
  final Color textColor;

  @override
  State<_WheelColumn> createState() => _WheelColumnState();
}

class _WheelColumnState extends State<_WheelColumn> {
  static const double _itemExtent = 60;

  double _fractionalIndex = 0;

  @override
  void initState() {
    super.initState();
    _fractionalIndex = widget.selectedIndex.toDouble();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.controller.hasClients) {
      setState(() {
        _fractionalIndex = widget.controller.offset / _itemExtent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: widget.controller,
      itemExtent: _itemExtent,
      diameterRatio: 100,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: widget.onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.items.length,
        builder: (context, index) {
          final distance = (index - _fractionalIndex).abs();
          final proximity = (1 - distance).clamp(0.0, 1.0);
          final fontSize = 36.0 + 16.0 * proximity;
          final opacity = distance < 1
              ? 1.0 - distance * 0.55
              : distance < 2
              ? 0.45 - (distance - 1) * 0.25
              : 0.2;

          return Align(
            alignment: widget.alignment,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                widget.items[index],
                style: TextStyle(
                  color: widget.textColor.withValues(
                    alpha: opacity.clamp(0.0, 1.0),
                  ),
                  fontSize: fontSize,
                  fontWeight: distance < 0.5
                      ? FontWeight.w600
                      : FontWeight.w400,
                  height: 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PeriodColumn extends StatefulWidget {
  const _PeriodColumn({
    required this.controller,
    required this.periods,
    required this.selectedIndex,
    required this.onSelectedItemChanged,
    required this.textColor,
  });

  final FixedExtentScrollController controller;
  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onSelectedItemChanged;
  final Color textColor;

  @override
  State<_PeriodColumn> createState() => _PeriodColumnState();
}

class _PeriodColumnState extends State<_PeriodColumn> {
  static const double _itemExtent = 60;

  double _fractionalIndex = 0;

  @override
  void initState() {
    super.initState();
    _fractionalIndex = widget.selectedIndex.toDouble();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.controller.hasClients) {
      setState(() {
        _fractionalIndex = widget.controller.offset / _itemExtent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      controller: widget.controller,
      itemExtent: _itemExtent,
      diameterRatio: 100,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: widget.onSelectedItemChanged,
      children: List.generate(widget.periods.length, (index) {
        final distance = (index - _fractionalIndex).abs();
        final proximity = (1 - distance).clamp(0.0, 1.0);
        final fontSize = 16.0 + 4.0 * proximity;
        final opacity = distance < 1
            ? 1.0 - distance * 0.55
            : distance < 2
            ? 0.45 - (distance - 1) * 0.25
            : 0.2;

        return Center(
          child: Text(
            widget.periods[index],
            style: TextStyle(
              color: widget.textColor.withValues(
                alpha: opacity.clamp(0.0, 1.0),
              ),
              fontSize: fontSize,
              fontWeight: distance < 0.5 ? FontWeight.w600 : FontWeight.w400,
              height: 1,
            ),
          ),
        );
      }),
    );
  }
}
