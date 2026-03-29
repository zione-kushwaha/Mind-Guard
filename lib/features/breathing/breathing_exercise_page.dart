import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BreathingExercisePage extends StatefulWidget {
  @override
  _BreathingExercisePageState createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _backgroundController;
  late Animation<double> _breatheAnimation;
  late Animation<Color?> _colorAnimation;
  
  bool _isBreathing = false;
  String _breathePhase = 'Ready to begin';
  int _breatheCount = 0;
  int _selectedDuration = 5; // minutes
  
  final List<int> _durations = [1, 3, 5, 10, 15];
  final List<String> _breathePatterns = [
    '4-7-8 Pattern',
    '4-4-4 Pattern',
    '5-5-5 Pattern',
    'Box Breathing',
  ];
  String _selectedPattern = '4-7-8 Pattern';

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );
    
    _breatheAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breatheController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: Colors.blue.shade300,
      end: Colors.purple.shade300,
    ).animate(_backgroundController);
    
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isBreathing = true;
      _breatheCount = 0;
    });
    _breatheCycle();
  }

  void _stopBreathing() {
    setState(() {
      _isBreathing = false;
      _breathePhase = 'Ready to begin';
    });
    _breatheController.stop();
  }

  void _breatheCycle() async {
    if (!_isBreathing) return;
    
    // Inhale
    setState(() => _breathePhase = 'Inhale');
    await _breatheController.forward();
    if (!_isBreathing) return;
    
    // Hold
    setState(() => _breathePhase = 'Hold');
    await Future.delayed(Duration(seconds: 2));
    if (!_isBreathing) return;
    
    // Exhale
    setState(() => _breathePhase = 'Exhale');
    await _breatheController.reverse();
    if (!_isBreathing) return;
    
    setState(() {
      _breatheCount++;
      _breathePhase = 'Rest';
    });
    
    await Future.delayed(Duration(seconds: 1));
    if (_isBreathing) {
      _breatheCycle();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Breathing Exercise',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _colorAnimation.value?.withOpacity(0.1) ?? Colors.blue.shade50,
                  Colors.white,
                  _colorAnimation.value?.withOpacity(0.05) ?? Colors.purple.shade50,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Settings Card
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Settings',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            // Duration Selection
                            Text('Duration (minutes)'),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: _durations.map((duration) {
                                return FilterChip(
                                  label: Text('${duration}m'),
                                  selected: _selectedDuration == duration,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedDuration = duration;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 16),
                            // Pattern Selection
                            Text('Breathing Pattern'),
                            SizedBox(height: 8),
                            DropdownButton<String>(
                              value: _selectedPattern,
                              isExpanded: true,
                              items: _breathePatterns.map((pattern) {
                                return DropdownMenuItem(
                                  value: pattern,
                                  child: Text(pattern),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPattern = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ).animate().slideY(begin: -1, duration: 800.ms).fade(),
                    
                    SizedBox(height: 40),
                    
                    // Breathing Circle
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _breatheAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _breatheAnimation.value,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          theme.colorScheme.primary.withOpacity(0.3),
                                          theme.colorScheme.secondary.withOpacity(0.1),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary.withOpacity(0.3),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: theme.colorScheme.primary,
                                        ),
                                        child: Icon(
                                          Icons.air,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).animate().scale(duration: 1000.ms, curve: Curves.elasticOut),
                            
                            SizedBox(height: 40),
                            
                            // Breathing Phase Text
                            Text(
                              _breathePhase,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ).animate().fade().slideY(begin: 1),
                            
                            SizedBox(height: 20),
                            
                            // Breath Count
                            if (_isBreathing)
                              Text(
                                'Breath Count: $_breatheCount',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ).animate().fade().slideY(begin: 1),
                          ],
                        ),
                      ),
                    ),
                    
                    // Control Buttons
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!_isBreathing)
                            ElevatedButton.icon(
                              onPressed: _startBreathing,
                              icon: Icon(Icons.play_arrow),
                              label: Text('Start'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ).animate().scale(delay: 500.ms),
                          
                          if (_isBreathing)
                            ElevatedButton.icon(
                              onPressed: _stopBreathing,
                              icon: Icon(Icons.stop),
                              label: Text('Stop'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
