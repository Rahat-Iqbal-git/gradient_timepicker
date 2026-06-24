import 'package:flutter/material.dart';
import 'package:gradient_timepicker/gradient_timepicker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gradient Time Picker Example',
      home: HomePage(),
    );
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
    if (next != _topEffect) {
      setState(() => _topEffect = next);
    }
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
      backgroundColor: const Color(0xFFF5F5F5),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Time Picker Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0),
                Colors.white,
              ],
              stops: [0.0, 0.12 * _topEffect],
            ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight + 32,
                bottom: 32,
              ),
              itemCount: 6,
              separatorBuilder: (_, _) => const SizedBox(height: 32),
              itemBuilder: (context, index) {
                // Alternate between the 12-hour and 24-hour cards.
                return index.isEven
                    ? _PickerCard(
                        label: '12-hour',
                        timeLabel: _format12(_selectedTime12),
                        hasSelection: _selectedTime12 != null,
                        onTap: _openTimePicker12,
                      )
                    : _PickerCard(
                        label: '24-hour',
                        timeLabel: _format24(_selectedTime24),
                        hasSelection: _selectedTime24 != null,
                        onTap: _openTimePicker24,
                      );
              },
            ),
          ),
        ],
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
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Text(
          timeLabel,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: hasSelection ? Colors.black87 : Colors.black26,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A3A8F),
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 52),
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: const Text(
            'Select time',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

