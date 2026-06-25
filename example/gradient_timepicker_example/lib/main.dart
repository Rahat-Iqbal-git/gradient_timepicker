import 'package:flutter/material.dart';
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

  final ScrollController _scrollController = ScrollController();
  double _topEffect = 0;
  static const double _effectRampDistance = 32;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final next = (_scrollController.offset / _effectRampDistance).clamp(0.0, 1.0);
    if (next != _topEffect) setState(() => _topEffect = next);
  }

  Future<void> _openTimePicker12() async {
    final result = await showTimePickerSheet(
      context: context,
      initialTime: _selectedTime12,
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
          const _GradientPresetsRow(),
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
        ],
      ),
    );
  }
}

class _GradientPresetsRow extends StatelessWidget {
  const _GradientPresetsRow();

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
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              for (final preset in _presets) ...[
                _GradientCard(name: preset.name, gradient: preset.gradient),
                const SizedBox(width: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GradientCard extends StatelessWidget {
  const _GradientCard({required this.name, required this.gradient});

  final String name;
  final TimePickerGradient gradient;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 100,
        height: 150,
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
                        colors: gradient.amColors,
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
                        colors: gradient.pmColors,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Text(
                name,
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
