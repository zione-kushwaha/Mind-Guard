import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GroundingExercisePage extends StatefulWidget {
  @override
  _GroundingExercisePageState createState() => _GroundingExercisePageState();
}

class _GroundingExercisePageState extends State<GroundingExercisePage>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  
  int _currentStep = 0;
  bool _isExerciseActive = false;
  
  final List<GroundingStep> _steps = [
    GroundingStep(
      title: '5 Things You Can See',
      description: 'Look around and identify 5 things you can see. Take your time.',
      icon: Icons.visibility,
      color: Colors.blue,
      count: 5,
    ),
    GroundingStep(
      title: '4 Things You Can Touch',
      description: 'Feel 4 different textures around you. Notice how they feel.',
      icon: Icons.touch_app,
      color: Colors.green,
      count: 4,
    ),
    GroundingStep(
      title: '3 Things You Can Hear',
      description: 'Listen carefully and identify 3 different sounds.',
      icon: Icons.hearing,
      color: Colors.orange,
      count: 3,
    ),
    GroundingStep(
      title: '2 Things You Can Smell',
      description: 'Take a deep breath and notice 2 different scents.',
      icon: Icons.air,
      color: Colors.purple,
      count: 2,
    ),
    GroundingStep(
      title: '1 Thing You Can Taste',
      description: 'Notice any taste in your mouth, or take a sip of water.',
      icon: Icons.favorite,
      color: Colors.red,
      count: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _isExerciseActive = true;
      _currentStep = 0;
    });
    _progressController.forward();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _progressController.reset();
      _progressController.forward();
    } else {
      _completeExercise();
    }
  }

  void _completeExercise() {
    setState(() {
      _isExerciseActive = false;
    });
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 8),
            Text('Well Done!'),
          ],
        ),
        content: Text(
          'You\'ve completed the 5-4-3-2-1 grounding exercise. How are you feeling now?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Great!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStepData = _isExerciseActive ? _steps[_currentStep] : null;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Grounding Exercise',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Progress Indicator
                if (_isExerciseActive)
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Step ${_currentStep + 1} of ${_steps.length}',
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                '${((_currentStep + 1) / _steps.length * 100).round()}%',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: (_currentStep + 1) / _steps.length,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().slideY(begin: -1, duration: 600.ms).fade(),
                
                SizedBox(height: 20),
                
                // Exercise Content
                Expanded(
                  child: _isExerciseActive
                      ? _buildExerciseContent(currentStepData!, theme)
                      : _buildWelcomeContent(theme),
                ),
                
                // Control Buttons
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: _isExerciseActive
                      ? ElevatedButton.icon(
                          onPressed: _nextStep,
                          icon: Icon(Icons.check),
                          label: Text(_currentStep == _steps.length - 1 ? 'Complete' : 'Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentStepData?.color ?? theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ).animate().scale(delay: 800.ms)
                      : ElevatedButton.icon(
                          onPressed: _startExercise,
                          icon: Icon(Icons.play_arrow),
                          label: Text('Start Exercise'),
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
                        ).animate().scale(delay: 1000.ms),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeContent(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.1),
              child: Container(
                width: 150,
                height: 150,
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
                child: Icon(
                  Icons.self_improvement,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          },
        ),
        
        SizedBox(height: 40),
        
        Text(
          '5-4-3-2-1 Grounding',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ).animate().fade().slideY(begin: 1),
        
        SizedBox(height: 20),
        
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'This technique helps you focus on the present moment by using your five senses. It\'s perfect for managing anxiety and staying grounded.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 1),
        
        SizedBox(height: 30),
        
        // Steps Preview
        AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: _steps.map((step) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: step.color.withOpacity(0.2),
                      child: Icon(step.icon, color: step.color),
                    ),
                    title: Text(
                      step.title,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${step.count} items',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseContent(GroundingStep step, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.8 + (_progressController.value * 0.4),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      step.color.withOpacity(0.3),
                      step.color.withOpacity(0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: step.color.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        step.icon,
                        size: 60,
                        color: step.color,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '${step.count}',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: step.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        
        SizedBox(height: 40),
        
        Text(
          step.title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: step.color,
          ),
          textAlign: TextAlign.center,
        ).animate().fade().slideY(begin: 1),
        
        SizedBox(height: 20),
        
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              step.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade700,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ).animate().fade(delay: 200.ms).slideY(begin: 1),
      ],
    );
  }
}

class GroundingStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int count;

  GroundingStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.count,
  });
}
