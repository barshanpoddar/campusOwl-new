import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  int pomodoroDuration = 25 * 60;
  int shortBreakDuration = 5 * 60;
  int longBreakDuration = 15 * 60;
  String mode = 'pomodoro'; // 'pomodoro' | 'shortBreak' | 'longBreak'
  bool isActive = false;
  int timeRemaining = 25 * 60;
  Timer? _timer;
  int completedSessions = 0;

  @override
  void initState() {
    super.initState();
    timeRemaining = pomodoroDuration;
  }

  void _start() {
    if (isActive) return;
    setState(() => isActive = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (timeRemaining > 0) {
        setState(() => timeRemaining -= 1);
      } else {
        _timer?.cancel();
        setState(() => isActive = false);
        if (mode == 'pomodoro') {
          completedSessions += 1;
          if (completedSessions % 4 == 0) {
            _switchMode('longBreak');
          } else {
            _switchMode('shortBreak');
          }
        } else {
          _switchMode('pomodoro');
        }
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => isActive = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      isActive = false;
      completedSessions = 0;
      mode = 'pomodoro';
      timeRemaining = pomodoroDuration;
    });
  }

  void _switchMode(String newMode) {
    setState(() {
      mode = newMode;
      timeRemaining = (newMode == 'pomodoro')
          ? pomodoroDuration
          : (newMode == 'shortBreak' ? shortBreakDuration : longBreakDuration);
    });
  }

  String _format(int seconds) {
    final m = (seconds / 60).floor();
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPaused = !isActive && timeRemaining > 0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
              mode == 'pomodoro'
                  ? 'Focus Time'
                  : mode == 'shortBreak'
                      ? 'Short Break'
                      : 'Long Break',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 8),
                shape: BoxShape.circle),
            child: Center(
                child: Text(_format(timeRemaining),
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (!isActive && !isPaused)
              ElevatedButton.icon(
                  onPressed: _start,
                  icon: SvgPicture.asset(
                    'assets/icons/play.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text('Start')),
            if (isPaused)
              ElevatedButton.icon(
                  onPressed: _start,
                  icon: SvgPicture.asset(
                    'assets/icons/play.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text('Resume')),
            if (isActive)
              ElevatedButton.icon(
                  onPressed: _pause,
                  icon: SvgPicture.asset(
                    'assets/icons/pause.svg',
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text('Pause')),
            const SizedBox(width: 12),
            OutlinedButton.icon(
                onPressed: _reset,
                icon: SvgPicture.asset(
                  'assets/icons/arrow_path.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: const Text('Reset')),
          ]),
          const SizedBox(height: 20),
          Text('Completed sessions: $completedSessions / 4'),
        ]),
      ),
    );
  }
}
