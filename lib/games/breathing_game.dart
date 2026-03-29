import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BreathingGamePage extends ConsumerStatefulWidget {
  const BreathingGamePage({Key? key}) : super(key: key);

  @override
  ConsumerState<BreathingGamePage> createState() => _BreathingGamePageState();
}

class _BreathingGamePageState extends ConsumerState<BreathingGamePage>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _colorController;
  late Animation<double> _breatheAnimation;
  late Animation<Color?> _colorAnimation;
  
  bool _isBreathing = false;
  String _breathingPhase = 'Tap to start';
  int _currentCycle = 0;
  int _totalCycles = 0;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _colorController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _breatheAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _breatheController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: Colors.blue.shade200,
      end: Colors.green.shade200,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));
    
    _breatheController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentCycle++;
          _breathingPhase = 'Breathe out slowly...';
        });
        _breatheController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        if (_isBreathing) {
          setState(() {
            _breathingPhase = 'Breathe in deeply...';
          });
          _breatheController.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isBreathing = true;
      _currentCycle = 0;
      _totalCycles = 10;
      _breathingPhase = 'Breathe in deeply...';
    });
    _breatheController.forward();
    _colorController.repeat(reverse: true);
  }

  void _stopBreathing() {
    setState(() {
      _isBreathing = false;
      _breathingPhase = 'Tap to start';
    });
    _breatheController.stop();
    _colorController.stop();
    _breatheController.reset();
    _colorController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text('Breathing Exercise'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.green.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Progress indicator
                if (_isBreathing)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cycle: $_currentCycle / $_totalCycles',
                          style: theme.textTheme.titleMedium,
                        ),
                        LinearProgressIndicator(
                          value: _currentCycle / _totalCycles,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ).animate().fadeIn(duration: 300.ms),
                      ],
                    ),
                  ).animate().slideY(begin: -1, duration: 500.ms),
                
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Breathing circle
                        GestureDetector(
                          onTap: _isBreathing ? _stopBreathing : _startBreathing,
                          child: AnimatedBuilder(
                            animation: Listenable.merge([
                              _breatheAnimation,
                              _colorAnimation,
                            ]),
                            builder: (context, child) {
                              return Container(
                                width: 200 + (100 * _breatheAnimation.value),
                                height: 200 + (100 * _breatheAnimation.value),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _colorAnimation.value ?? Colors.blue.shade200,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_colorAnimation.value ?? Colors.blue.shade200)
                                          .withOpacity(0.3),
                                      blurRadius: 20 + (10 * _breatheAnimation.value),
                                      spreadRadius: 5 + (5 * _breatheAnimation.value),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    _isBreathing ? Icons.pause : Icons.play_arrow,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ).animate().scale(duration: 300.ms),
                        
                        SizedBox(height: 40),
                        
                        // Breathing instruction
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            _breathingPhase,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ).animate().fadeIn(duration: 500.ms),
                        
                        SizedBox(height: 40),
                        
                        // Instructions
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info_outline, color: theme.colorScheme.primary),
                                  SizedBox(width: 8),
                                  Text(
                                    'How to use:',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                '• Tap the circle to start breathing exercise\n'
                                '• Follow the expanding circle to breathe in\n'
                                '• Follow the contracting circle to breathe out\n'
                                '• Complete 10 cycles for best results',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ).animate().slideY(begin: 1, duration: 700.ms),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
