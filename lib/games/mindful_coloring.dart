import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class MindfulColoringPage extends ConsumerStatefulWidget {
  const MindfulColoringPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MindfulColoringPage> createState() => _MindfulColoringPageState();
}

class _MindfulColoringPageState extends ConsumerState<MindfulColoringPage>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  
  Color _selectedColor = Colors.blue;
  List<Color> _availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
    Colors.grey,
  ];
  
  List<List<Color?>> _mandalaColors = List.generate(
    8, 
    (i) => List.generate(8, (j) => null),
  );
  
  bool _isColoring = false;
  int _coloredCells = 0;
  
  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _colorCell(int row, int col) {
    if (_mandalaColors[row][col] == null) {
      setState(() {
        _mandalaColors[row][col] = _selectedColor;
        _coloredCells++;
      });
      
      _rippleController.forward().then((_) {
        _rippleController.reset();
      });
      
      if (_coloredCells == 64) {
        _showCompletionDialog();
      }
    }
  }

  void _clearMandala() {
    setState(() {
      _mandalaColors = List.generate(
        8, 
        (i) => List.generate(8, (j) => null),
      );
      _coloredCells = 0;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '🎨 Beautiful Work!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You\'ve completed your mindful coloring!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Take a moment to appreciate your creation.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _clearMandala();
            },
            child: Text('Start New'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Keep This'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text('Mindful Coloring'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearMandala,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Progress indicator
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
                  child: Column(
                    children: [
                      Text(
                        'Progress: $_coloredCells / 64',
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _coloredCells / 64,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms),
                
                SizedBox(height: 20),
                
                // Color palette
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
                  child: Column(
                    children: [
                      Text(
                        'Choose Your Color',
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableColors.map((color) {
                          bool isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: theme.colorScheme.primary,
                                        width: 3,
                                      )
                                    : null,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.5),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: -0.5, duration: 600.ms),
                
                SizedBox(height: 20),
                
                // Mandala grid
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16),
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 2,
                          ),
                          itemCount: 64,
                          itemBuilder: (context, index) {
                            int row = index ~/ 8;
                            int col = index % 8;
                            
                            return GestureDetector(
                              onTap: () => _colorCell(row, col),
                              child: AnimatedBuilder(
                                animation: _rippleController,
                                builder: (context, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: _mandalaColors[row][col] ?? Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: _mandalaColors[row][col] == null
                                        ? Center(
                                            child: _getMandalaPattern(row, col),
                                          )
                                        : null,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Instructions
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
                  child: Text(
                    'Tap gently on each cell to color it.\nTake your time and breathe deeply.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ).animate().fadeIn(duration: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMandalaPattern(int row, int col) {
    // Create a simple mandala pattern
    int centerRow = 4;
    int centerCol = 4;
    double distance = sqrt(pow(row - centerRow, 2) + pow(col - centerCol, 2));
    
    if (distance < 1) {
      return Icon(Icons.center_focus_strong, size: 12, color: Colors.grey.shade400);
    } else if (distance < 2) {
      return Icon(Icons.circle_outlined, size: 8, color: Colors.grey.shade400);
    } else if (distance < 3) {
      return Icon(Icons.crop_square, size: 6, color: Colors.grey.shade400);
    } else {
      return Icon(Icons.fiber_manual_record, size: 4, color: Colors.grey.shade400);
    }
  }
}
