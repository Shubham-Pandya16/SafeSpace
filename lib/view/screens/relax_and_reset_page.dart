import 'dart:async';

import 'package:flutter/material.dart';

enum ExerciseType { box, fourSevenEight }

enum PhaseType { inhale, hold, exhale }

class Phase {
  final PhaseType type;
  final int seconds;
  Phase(this.type, this.seconds);
}

class RelaxAndResetPage extends StatefulWidget {
  const RelaxAndResetPage({Key? key}) : super(key: key);

  @override
  State<RelaxAndResetPage> createState() => _RelaxAndResetPageState();
}

class _RelaxAndResetPageState extends State<RelaxAndResetPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  ExerciseType _exercise = ExerciseType.box;
  late List<Phase> _sequence;
  int _phaseIndex = 0;

  Timer? _phaseTimer;
  Timer? _countdownTimer;
  DateTime? _phaseEnd;
  int _remainingSeconds = 0;

  // Calm earthy palette (soft browns)
  final Color _bgStart = const Color(0xFFefe6df);
  final Color _bgEnd = const Color(0xFFF5F0EC);
  final Color _circleColor = const Color(0xFFD9CFC6);
  final Color _accent = const Color(0xFF8B6B53);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 0.0);
    _scaleAnim = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

    _startExercise(ExerciseType.box);
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _countdownTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  List<Phase> _buildSequence(ExerciseType type) {
    final List<Phase> seq = [];
    if (type == ExerciseType.box) {
      for (var i = 0; i < 4; i++) {
        seq.add(Phase(PhaseType.inhale, 4));
        seq.add(Phase(PhaseType.hold, 4));
        seq.add(Phase(PhaseType.exhale, 4));
        seq.add(Phase(PhaseType.hold, 4));
      }
    } else {
      for (var i = 0; i < 3; i++) {
        seq.add(Phase(PhaseType.inhale, 4));
        seq.add(Phase(PhaseType.hold, 7));
        seq.add(Phase(PhaseType.exhale, 8));
      }
    }
    return seq;
  }

  String get _phaseLabel {
    final phase = _sequence[_phaseIndex];
    switch (phase.type) {
      case PhaseType.inhale:
        return 'Breathe In';
      case PhaseType.hold:
        return 'Hold';
      case PhaseType.exhale:
        return 'Breathe Out';
    }
  }

  void _startExercise(ExerciseType type, {int startIndex = 0}) {
    _phaseTimer?.cancel();
    _countdownTimer?.cancel();
    _exercise = type;
    _sequence = _buildSequence(type);
    _phaseIndex = startIndex.clamp(0, _sequence.length - 1);
    _runPhase();
  }

  void _runPhase() {
    if (!mounted) return;
    _phaseTimer?.cancel();
    _countdownTimer?.cancel();

    final phase = _sequence[_phaseIndex];
    _phaseEnd = DateTime.now().add(Duration(seconds: phase.seconds));
    _updateRemaining();

    // Countdown updater: refresh every 200ms for smoothness
    _countdownTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _updateRemaining();
    });

    if (phase.type == PhaseType.inhale) {
      _controller.duration = Duration(seconds: phase.seconds);
      _controller.forward(from: 0.0).whenComplete(() {
        _advancePhase();
      });
    } else if (phase.type == PhaseType.exhale) {
      _controller.duration = Duration(seconds: phase.seconds);
      _controller.reverse(from: 1.0).whenComplete(() {
        _advancePhase();
      });
    } else {
      // Hold: keep the circle at the last state (expanded if hold after inhale,
      // or contracted if hold after exhale)
      final previousIsInhale =
          _phaseIndex > 0 &&
          _sequence[_phaseIndex - 1].type == PhaseType.inhale;
      _controller.value = previousIsInhale ? 1.0 : 0.0;

      _phaseTimer = Timer(Duration(seconds: phase.seconds), () {
        _advancePhase();
      });
    }

    setState(() {});
  }

  void _updateRemaining() {
    if (_phaseEnd == null) return;
    final diff = _phaseEnd!.difference(DateTime.now());
    final secs = diff.isNegative
        ? 0
        : diff.inSeconds + (diff.inMilliseconds % 1000 > 0 ? 1 : 0);
    if (mounted) {
      setState(() {
        _remainingSeconds = secs;
      });
    }
  }

  void _advancePhase() {
    _phaseTimer?.cancel();
    _countdownTimer?.cancel();

    if (_phaseIndex < _sequence.length - 1) {
      _phaseIndex++;
      _runPhase();
    } else {
      // Sequence finished
      if (_exercise == ExerciseType.box) {
        // Automatically transition to 4-7-8
        _startExercise(ExerciseType.fourSevenEight);
      } else {
        // Completed both exercises: gently stop on a relaxed state (contracted)
        _controller.animateTo(
          0.0,
          duration: const Duration(seconds: 2),
          curve: Curves.easeOut,
        );
        if (mounted) setState(() {});
      }
    }
  }

  void _skipToNextExercise() {
    if (_exercise == ExerciseType.box) {
      // Jump to 4-7-8 immediately
      _startExercise(ExerciseType.fourSevenEight);
    } else {
      // In 4-7-8: pop the page
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final circleSize = media.width * 0.85;

    return Scaffold(
      backgroundColor: _bgStart,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_bgStart, _bgEnd],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Relax & Reset',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _exercise == ExerciseType.box ? 'Box' : '4-7-8',
                      style: TextStyle(
                        color: _accent.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Breathing visual area
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _scaleAnim,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Soft background circle with subtle shadow
                          Container(
                            width: circleSize * _scaleAnim.value,
                            height: circleSize * _scaleAnim.value,
                            decoration: BoxDecoration(
                              color: _circleColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                          ),
                          // A slightly smaller inner circle for depth
                          Container(
                            width: circleSize * 0.7 * _scaleAnim.value,
                            height: circleSize * 0.7 * _scaleAnim.value,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Centered guidance text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _phaseLabel,
                                style: TextStyle(
                                  color: _accent,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_remainingSeconds s',
                                style: TextStyle(
                                  color: _accent.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              // Bottom controls: Skip button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _skipToNextExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _exercise == ExerciseType.box
                          ? 'Skip to the next exercise'
                          : 'Skip to the next exercise',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
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
