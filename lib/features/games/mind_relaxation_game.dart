import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

class MindRelaxationGame extends StatefulWidget {
  @override
  _MindRelaxationGameState createState() => _MindRelaxationGameState();
}

class _MindRelaxationGameState extends State<MindRelaxationGame>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _colorController;
  late Animation<double> _rippleAnimation;
  late Animation<Color?> _colorAnimation;
  
  List<RippleEffect> _ripples = [];
  int _score = 0;
  bool _isPlaying = false;
  
  final List<Color> _colors = [
    Colors.blue,
    Colors.purple,
    Colors.green,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _colorController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(_colorController);
    
    _colorController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _score = 0;
      _ripples.clear();
    });
  }

  void _stopGame() {
    setState(() {
      _isPlaying = false;
    });
  }

  void _onTap(TapDownDetails details) {
    if (!_isPlaying) return;
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.globalToLocal(details.globalPosition);
    
    setState(() {
      _score++;
      _ripples.add(
        RippleEffect(
          position: position,
          color: _colors[math.Random().nextInt(_colors.length)],
          timestamp: DateTime.now(),
        ),
      );
    });
    
    _rippleController.forward().then((_) {
      _rippleController.reset();
      _cleanupRipples();
    });
  }

  void _cleanupRipples() {
    final now = DateTime.now();
    setState(() {
      _ripples.removeWhere((ripple) =>
          now.difference(ripple.timestamp).inSeconds > 3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mind Relaxation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTapDown: _onTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.5,
              colors: [
                Colors.black,
                Colors.blue.shade900,
                Colors.purple.shade900,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background animated particles
              ...List.generate(20, (index) {
                return AnimatedBuilder(
                  animation: _colorController,
                  builder: (context, child) {
                    return Positioned(
                      left: math.Random().nextDouble() * 
                          MediaQuery.of(context).size.width,
                      top: math.Random().nextDouble() * 
                          MediaQuery.of(context).size.height,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(
                            0.3 + (_colorController.value * 0.4),
                          ),
                        ),
                      ).animate(
                        onPlay: (controller) => controller.repeat(),
                      ).fadeIn(duration: Duration(seconds: 2))
                       .then()
                       .fadeOut(duration: Duration(seconds: 2)),
                    );
                  },
                );
              }),
              
              // Ripple effects
              ...(_ripples.map((ripple) {
                return AnimatedBuilder(
                  animation: _rippleAnimation,
                  builder: (context, child) {
                    return Positioned(
                      left: ripple.position.dx - (100 * _rippleAnimation.value),
                      top: ripple.position.dy - (100 * _rippleAnimation.value),
                      child: Container(
                        width: 200 * _rippleAnimation.value,
                        height: 200 * _rippleAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ripple.color.withOpacity(
                              1.0 - _rippleAnimation.value,
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList()),
              
              // Score display
              if (_isPlaying)
                Positioned(
                  top: 50,
                  left: 20,
                  child: Card(
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Touches: $_score',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().slideX(begin: -1, duration: 500.ms),
                ),
              
              // Instructions or welcome message
              if (!_isPlaying)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _colorController,
                        builder: (context, child) {
                          return Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  _colorAnimation.value?.withOpacity(0.3) ?? 
                                      Colors.blue.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                              border: Border.all(
                                color: _colorAnimation.value ?? Colors.blue,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.touch_app,
                              size: 60,
                              color: _colorAnimation.value ?? Colors.blue,
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 40),
                      
                      Text(
                        'Mind Relaxation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fade().slideY(begin: 1),
                      
                      SizedBox(height: 20),
                      
                      Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tap anywhere on the screen to create beautiful ripples. Focus on the colors and movements to relax your mind.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ).animate().fade(delay: 500.ms).slideY(begin: 1),
                      
                      SizedBox(height: 40),
                      
                      ElevatedButton.icon(
                        onPressed: _startGame,
                        icon: Icon(Icons.play_arrow),
                        label: Text('Start Relaxing'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
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
                    ],
                  ),
                ),
              
              // Exit button when playing
              if (_isPlaying)
                Positioned(
                  top: 50,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _stopGame,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.stop, color: Colors.white),
                  ).animate().scale(delay: 200.ms),
                ),
              
              // Floating instructions when playing
              if (_isPlaying)
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Tap anywhere to create ripples • Focus on the colors • Breathe deeply',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ).animate().fade(delay: 2000.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class RippleEffect {
  final Offset position;
  final Color color;
  final DateTime timestamp;

  RippleEffect({
    required this.position,
    required this.color,
    required this.timestamp,
  });
}
