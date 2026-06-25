import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:gradient_timepicker/gradient_timepicker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Gradient Time Picker Example', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimeOfDay? _selectedTime12;
  TimeOfDay? _selectedTime24;
  TimePickerGradient _selectedGradient = TimePickerGradient.defaultGradient;

  Future<void> _openTimePicker12() async {
    final result = await showTimePickerSheet(
      context: context,
      initialTime: _selectedTime12,
      gradient: _selectedGradient,
    );
    if (result != null) {
      setState(() => _selectedTime12 = result);
    }
  }

  Future<void> _openTimePicker24() async {
    final result = await showTimePickerSheet(
      context: context,
      initialTime: _selectedTime24,
      use24Hour: true,
      gradient: _selectedGradient,
    );
    if (result != null) {
      setState(() => _selectedTime24 = result);
    }
  }

  String _format12(TimeOfDay? time) {
    if (time == null) return 'No time selected';
    final raw = time.hourOfPeriod;
    final h = raw == 0 ? 12 : raw;
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${h.toString().padLeft(2, '0')}:$m $period';
  }

  String _format24(TimeOfDay? time) {
    if (time == null) return 'No time selected';
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFF5F5F5),
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text(
          'Time Picker Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          _GradientPresetsRow(
            selectedGradient: _selectedGradient,
            onSelect: (g) => setState(() => _selectedGradient = g),
          ),
          const SizedBox(height: 40),
          _PickerCard(
            label: '12-hour',
            timeLabel: _format12(_selectedTime12),
            hasSelection: _selectedTime12 != null,
            onTap: _openTimePicker12,
          ),
          const SizedBox(height: 16),
          _PickerCard(
            label: '24-hour',
            timeLabel: _format24(_selectedTime24),
            hasSelection: _selectedTime24 != null,
            onTap: _openTimePicker24,
          ),
          SizedBox(height: 500),
        ],
      ),
    );
  }
}

class _GradientPresetsRow extends StatelessWidget {
  const _GradientPresetsRow({required this.selectedGradient, required this.onSelect});

  final TimePickerGradient selectedGradient;
  final ValueChanged<TimePickerGradient> onSelect;

  static const _presets = [
    (name: 'Default', gradient: TimePickerGradient.defaultGradient),
    (name: 'Moonrise', gradient: TimePickerGradient.moonrise),
    (name: 'Opal', gradient: TimePickerGradient.opal),
    (name: 'Mystic', gradient: TimePickerGradient.mystic),
    (name: 'Frosted', gradient: TimePickerGradient.frostedLight),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'GRADIENT PRESETS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 165,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final preset in _presets) ...[
                  _GradientCard(
                    name: preset.name,
                    gradient: preset.gradient,
                    isSelected: preset.gradient == selectedGradient,
                    onTap: () => onSelect(preset.gradient),
                  ),
                  const SizedBox(width: 12),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientCard extends StatefulWidget {
  const _GradientCard({
    required this.name,
    required this.gradient,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final TimePickerGradient gradient;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_GradientCard> createState() => _GradientCardState();
}

class _GradientCardState extends State<_GradientCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const double _unselectedWidth = 100;
  static const double _selectedWidth = 116;
  static const double _unselectedHeight = 150;
  static const double _selectedHeight = 200;

  static final _spring = SpringDescription.withDampingRatio(
    mass: 1,
    stiffness: 400,
    ratio: 0.6,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..value = widget.isSelected ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(_GradientCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      _controller.animateWith(
        SpringSimulation(_spring, _controller.value, widget.isSelected ? 1.0 : 0.0, 0),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value.clamp(0.0, 1.5);
          return SizedBox(
            width: _unselectedWidth + (_selectedWidth - _unselectedWidth) * t,
            height: _unselectedHeight + (_selectedHeight - _unselectedHeight) * t,
            child: child,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: widget.gradient.amColors,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: widget.gradient.pmColors,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.isSelected)
                const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                    shadows: [Shadow(blurRadius: 8, color: Colors.black38)],
                  ),
                ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.label,
    required this.timeLabel,
    required this.hasSelection,
    required this.onTap,
  });

  final String label;
  final String timeLabel;
  final bool hasSelection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black45,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeLabel,
                  style: TextStyle(
                    fontSize: 32,
                    // fontWeight: FontWeight.w600,
                    color: hasSelection ? Colors.black87 : Colors.black26,
                  ),
                ),
                Icon(Icons.chevron_right_outlined, color: Colors.black26),
              ],
            ),
            // const SizedBox(height: 16),
            // SizedBox(
            //   width: double.maxFinite,
            //   child: ElevatedButton(
            //     onPressed: onTap,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.grey,
            //       foregroundColor: Colors.white,
            //       minimumSize: const Size(200, 52),
            //       shape: const StadiumBorder(),
            //       elevation: 0,
            //     ),
            //     child: const Text(
            //       'Select time',
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
