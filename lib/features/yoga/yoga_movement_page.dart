import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class YogaMovementPage extends StatefulWidget {
  @override
  _YogaMovementPageState createState() => _YogaMovementPageState();
}

class _YogaMovementPageState extends State<YogaMovementPage>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _floatController;
  
  int _selectedRoutineIndex = 0;
  bool _isSessionActive = false;
  int _currentPoseIndex = 0;
  int _poseTimer = 0;
  
  final List<YogaRoutine> _routines = [
    YogaRoutine(
      name: 'Gentle Morning',
      description: 'Start your day with gentle movements',
      duration: '10 min',
      difficulty: 'Beginner',
      color: Colors.orange,
      icon: Icons.wb_sunny,
      poses: [
        YogaPose(
          name: 'Mountain Pose',
          description: 'Stand tall, feet hip-width apart, arms at sides',
          duration: 30,
          instructions: 'Breathe deeply and feel grounded',
          icon: Icons.person,
        ),
        YogaPose(
          name: 'Cat-Cow Stretch',
          description: 'On hands and knees, arch and round your back',
          duration: 45,
          instructions: 'Move slowly with your breath',
          icon: Icons.pets,
        ),
        YogaPose(
          name: 'Child\'s Pose',
          description: 'Kneel and stretch arms forward, rest forehead down',
          duration: 60,
          instructions: 'Relax and breathe deeply',
          icon: Icons.self_improvement,
        ),
      ],
    ),
    YogaRoutine(
      name: 'Anxiety Relief',
      description: 'Calming poses for stress and anxiety',
      duration: '15 min',
      difficulty: 'Beginner',
      color: Colors.blue,
      icon: Icons.healing,
      poses: [
        YogaPose(
          name: 'Legs Up the Wall',
          description: 'Lie on back, legs up against wall',
          duration: 120,
          instructions: 'Focus on deep breathing',
          icon: Icons.airline_seat_legroom_extra,
        ),
        YogaPose(
          name: 'Gentle Twist',
          description: 'Seated spinal twist to release tension',
          duration: 45,
          instructions: 'Hold each side for equal time',
          icon: Icons.sync_alt,
        ),
        YogaPose(
          name: 'Savasana',
          description: 'Lie flat, completely relax',
          duration: 180,
          instructions: 'Let go of all tension',
          icon: Icons.bed,
        ),
      ],
    ),
    YogaRoutine(
      name: 'Evening Unwind',
      description: 'Prepare for restful sleep',
      duration: '12 min',
      difficulty: 'Beginner',
      color: Colors.purple,
      icon: Icons.nightlight,
      poses: [
        YogaPose(
          name: 'Forward Fold',
          description: 'Seated forward bend to calm the mind',
          duration: 60,
          instructions: 'Breathe slowly and deeply',
          icon: Icons.accessibility_new,
        ),
        YogaPose(
          name: 'Supine Spinal Twist',
          description: 'Lying twist to release the day\'s tension',
          duration: 90,
          instructions: 'Stay present with each breath',
          icon: Icons.rotate_left,
        ),
        YogaPose(
          name: 'Meditation',
          description: 'Sit comfortably and focus on breath',
          duration: 300,
          instructions: 'Notice thoughts without judgment',
          icon: Icons.self_improvement,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    );
    _breatheController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _startRoutine() {
    setState(() {
      _isSessionActive = true;
      _currentPoseIndex = 0;
      _poseTimer = _routines[_selectedRoutineIndex].poses[0].duration;
    });
    _startPoseTimer();
  }

  void _startPoseTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_isSessionActive && _poseTimer > 0) {
        setState(() {
          _poseTimer--;
        });
        _startPoseTimer();
      } else if (_isSessionActive && _poseTimer == 0) {
        _nextPose();
      }
    });
  }

  void _nextPose() {
    final routine = _routines[_selectedRoutineIndex];
    if (_currentPoseIndex < routine.poses.length - 1) {
      setState(() {
        _currentPoseIndex++;
        _poseTimer = routine.poses[_currentPoseIndex].duration;
      });
      _startPoseTimer();
    } else {
      _completeRoutine();
    }
  }

  void _completeRoutine() {
    setState(() {
      _isSessionActive = false;
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
            Text('Session Complete!'),
          ],
        ),
        content: Text(
          'Great job! You\'ve completed your yoga session. Take a moment to notice how you feel.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Namaste'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
          'Yoga & Movement',
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
              Colors.orange.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: _isSessionActive
            ? _buildSessionView(theme)
            : _buildRoutineSelection(theme),
      ),
    );
  }

  Widget _buildRoutineSelection(ThemeData theme) {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatController.value * 10),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.orange.withOpacity(0.3),
                            Colors.pink.withOpacity(0.1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.self_improvement,
                        size: 60,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text(
                'Choose Your Practice',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ).animate().fade().slideY(begin: 1),
              SizedBox(height: 10),
              Text(
                'Select a routine that matches your current needs',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 200.ms).slideY(begin: 1),
            ],
          ),
        ),
        
        // Routine Cards
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: _routines.length,
              itemBuilder: (context, index) {
                final routine = _routines[index];
                final isSelected = _selectedRoutineIndex == index;
                
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRoutineIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: isSelected
                                ? Border.all(color: routine.color, width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? routine.color.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.2),
                                blurRadius: isSelected ? 20 : 10,
                                spreadRadius: isSelected ? 2 : 0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: routine.color.withOpacity(0.2),
                                  ),
                                  child: Icon(
                                    routine.icon,
                                    color: routine.color,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        routine.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        routine.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 16,
                                            color: Colors.grey.shade500,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            routine.duration,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Icon(
                                            Icons.fitness_center,
                                            size: 16,
                                            color: Colors.grey.shade500,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            routine.difficulty,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: routine.color,
                                    size: 24,
                                  ).animate().scale(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Start Button
        Padding(
          padding: EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: _startRoutine,
            icon: Icon(Icons.play_arrow),
            label: Text('Start Practice'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _routines[_selectedRoutineIndex].color,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ).animate().scale(delay: 800.ms),
        ),
      ],
    );
  }

  Widget _buildSessionView(ThemeData theme) {
    final routine = _routines[_selectedRoutineIndex];
    final currentPose = routine.poses[_currentPoseIndex];
    
    return Column(
      children: [
        // Progress Bar
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pose ${_currentPoseIndex + 1} of ${routine.poses.length}',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    '${_poseTimer}s',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: routine.color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentPoseIndex + 1) / routine.poses.length,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(routine.color),
              ),
            ],
          ),
        ),
        
        // Pose Display
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _breatheController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (_breatheController.value * 0.3),
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              routine.color.withOpacity(0.3),
                              routine.color.withOpacity(0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: routine.color.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          currentPose.icon,
                          size: 80,
                          color: routine.color,
                        ),
                      ),
                    );
                  },
                ),
                
                SizedBox(height: 40),
                
                Text(
                  currentPose.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: routine.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 20),
                
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          currentPose.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey.shade700,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          currentPose.instructions,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Control Buttons
        Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isSessionActive = false;
                  });
                },
                icon: Icon(Icons.stop),
                label: Text('End Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _nextPose,
                icon: Icon(Icons.skip_next),
                label: Text('Next Pose'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: routine.color,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class YogaRoutine {
  final String name;
  final String description;
  final String duration;
  final String difficulty;
  final Color color;
  final IconData icon;
  final List<YogaPose> poses;

  YogaRoutine({
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.color,
    required this.icon,
    required this.poses,
  });
}

class YogaPose {
  final String name;
  final String description;
  final int duration;
  final String instructions;
  final IconData icon;

  YogaPose({
    required this.name,
    required this.description,
    required this.duration,
    required this.instructions,
    required this.icon,
  });
}
