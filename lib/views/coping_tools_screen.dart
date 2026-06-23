import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CopingToolsScreen extends StatefulWidget {
  final bool isEmbedded;
  const CopingToolsScreen({super.key, this.isEmbedded = false});

  @override
  State<CopingToolsScreen> createState() => _CopingToolsScreenState();
}

class _CopingToolsScreenState extends State<CopingToolsScreen>
    with SingleTickerProviderStateMixin {
  // Breathing Timer State
  bool _isBreathing = false;
  int _secondsElapsed = 0;
  Timer? _timer;
  String _instruction = "Breathe In";
  double _circleSize = 150.0;
  Duration _animationDuration = const Duration(seconds: 4);

  // Phase 0=inhale, 1=hold, 2=exhale
  int _phase = 0;

  // Recovery Affirmations State
  int _quoteIndex = 0;
  final List<String> _quotes = [
    "My feelings are valid, and I am learning to navigate them.",
    "I am worthy of peace, comfort, and recovery.",
    "I take things one breath, one step, and one day at a time.",
    "I am strong enough to face this moment, and it will pass.",
    "I choose to be kind to myself today."
  ];

  // Gradient stops for the three phases
  static const _phaseGradients = [
    // Inhale – cool teal
    [Color(0xFF43E8D8), Color(0xFF4DB6AC)],
    // Hold – soft purple
    [Color(0xFFB39DDB), Color(0xFF9C7FD4)],
    // Exhale – deep teal/ocean
    [Color(0xFF26C6DA), Color(0xFF00838F)],
  ];

  static const _phaseShadowColors = [
    Color(0xFF4DB6AC),
    Color(0xFFB39DDB),
    Color(0xFF26C6DA),
  ];

  List<Color> get _currentGradient => _phaseGradients[_phase];
  Color get _currentShadow => _phaseShadowColors[_phase];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isBreathing = true;
      _secondsElapsed = 0;
      _instruction = "Breathe In";
      _circleSize = 260.0;
      _animationDuration = const Duration(seconds: 4);
      _phase = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        final cyclePosition = _secondsElapsed % 12;

        if (cyclePosition == 0) {
          _instruction = "Breathe In";
          _circleSize = 260.0;
          _animationDuration = const Duration(seconds: 4);
          _phase = 0;
        } else if (cyclePosition == 4) {
          _instruction = "Hold";
          _circleSize = 260.0;
          _animationDuration = const Duration(seconds: 4);
          _phase = 1;
        } else if (cyclePosition == 8) {
          _instruction = "Breathe Out";
          _circleSize = 150.0;
          _animationDuration = const Duration(seconds: 4);
          _phase = 2;
        }
      });
    });
  }

  void _stopBreathing() {
    _timer?.cancel();
    setState(() {
      _isBreathing = false;
      _secondsElapsed = 0;
      _instruction = "Breathe In";
      _circleSize = 150.0;
      _animationDuration = const Duration(milliseconds: 500);
      _phase = 0;
    });
  }

  void _refreshQuote() {
    setState(() {
      _quoteIndex = (_quoteIndex + 1) % _quotes.length;
    });
  }

  int _getRemainingTimeInStage() {
    if (!_isBreathing) return 4;
    return 4 - (_secondsElapsed % 4);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section Header ──────────────────────────────────────────────
            Text(
              'Mindful Breathing',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E2D47),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Follow the rhythm to calm your nervous system.',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 28),

            // ── Immersive Breathing Canvas ──────────────────────────────────
            Container(
              height: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Concentric Glow Stack
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow aura
                        AnimatedContainer(
                          duration: _animationDuration,
                          curve: Curves.easeInOut,
                          width: _circleSize + 80,
                          height: _circleSize + 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                _currentShadow.withOpacity(
                                    _isBreathing ? 0.12 : 0.04),
                                _currentShadow.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                        // Middle ring
                        AnimatedContainer(
                          duration: _animationDuration,
                          curve: Curves.easeInOut,
                          width: _circleSize + 40,
                          height: _circleSize + 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                _currentShadow.withOpacity(
                                    _isBreathing ? 0.18 : 0.06),
                                _currentShadow.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                        // Core gradient circle with glow shadow
                        AnimatedContainer(
                          duration: _animationDuration,
                          curve: Curves.easeInOut,
                          width: _circleSize,
                          height: _circleSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _currentGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _currentShadow.withOpacity(
                                    _isBreathing ? 0.45 : 0.15),
                                blurRadius: _isBreathing ? 36 : 12,
                                spreadRadius: _isBreathing ? 4 : 0,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _instruction,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                if (_isBreathing) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_getRemainingTimeInStage()}s',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isBreathing ? 'Focus on your breath' : 'Ready',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF6B7A99),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Control Button ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isBreathing ? _stopBreathing : _startBreathing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isBreathing
                      ? const Color(0xFFF5F5F8)
                      : theme.colorScheme.primary,
                  foregroundColor: _isBreathing
                      ? const Color(0xFF1E2D47)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _isBreathing ? 'Stop Breathing' : 'Start Breathing',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ── Affirmation Section ─────────────────────────────────────────
            Text(
              'Soothing Affirmation',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E2D47),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap or swipe the card to reveal a new supportive quote.',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Premium Quote Card
            GestureDetector(
              onTap: _refreshQuote,
              onHorizontalDragEnd: (details) => _refreshQuote(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B5EA7), Color(0xFFB39DDB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C7FD4).withOpacity(0.30),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.format_quote_rounded,
                      color: Colors.white54,
                      size: 36,
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        final slide = Tween<Offset>(
                          begin: const Offset(0.12, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        ));
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: slide,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        _quotes[_quoteIndex],
                        key: ValueKey<int>(_quoteIndex),
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_quotes.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _quoteIndex ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _quoteIndex
                                ? Colors.white
                                : Colors.white.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );

    if (widget.isEmbedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coping Sanctuary'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: content,
    );
  }
}
