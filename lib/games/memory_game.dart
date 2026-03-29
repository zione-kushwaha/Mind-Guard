import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

class MemoryGamePage extends ConsumerStatefulWidget {
  const MemoryGamePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends ConsumerState<MemoryGamePage>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _successController;
  
  List<String> _cardEmojis = [
    '🌸', '🌺', '🌻', '🌼', '🌷', '🌹', '🌙', '⭐',
    '🌸', '🌺', '🌻', '🌼', '🌷', '🌹', '🌙', '⭐',
  ];
  
  List<bool> _cardFlipped = List.filled(16, false);
  List<bool> _cardMatched = List.filled(16, false);
  List<int> _flippedIndices = [];
  
  int _score = 0;
  int _attempts = 0;
  bool _gameWon = false;
  
  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _shuffleCards();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _shuffleCards() {
    setState(() {
      _cardEmojis.shuffle(Random());
      _cardFlipped = List.filled(16, false);
      _cardMatched = List.filled(16, false);
      _flippedIndices.clear();
      _score = 0;
      _attempts = 0;
      _gameWon = false;
    });
  }

  void _onCardTap(int index) {
    if (_cardFlipped[index] || _cardMatched[index] || _flippedIndices.length >= 2) {
      return;
    }

    setState(() {
      _cardFlipped[index] = true;
      _flippedIndices.add(index);
    });

    if (_flippedIndices.length == 2) {
      _attempts++;
      Future.delayed(Duration(milliseconds: 1000), () {
        _checkMatch();
      });
    }
  }

  void _checkMatch() {
    if (_flippedIndices.length == 2) {
      int firstIndex = _flippedIndices[0];
      int secondIndex = _flippedIndices[1];
      
      if (_cardEmojis[firstIndex] == _cardEmojis[secondIndex]) {
        // Match found
        setState(() {
          _cardMatched[firstIndex] = true;
          _cardMatched[secondIndex] = true;
          _score += 10;
        });
        _successController.forward().then((_) {
          _successController.reset();
        });
        
        // Check if game is won
        if (_cardMatched.every((matched) => matched)) {
          setState(() {
            _gameWon = true;
          });
          _showWinDialog();
        }
      } else {
        // No match
        setState(() {
          _cardFlipped[firstIndex] = false;
          _cardFlipped[secondIndex] = false;
        });
      }
      
      setState(() {
        _flippedIndices.clear();
      });
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '🎉 Congratulations!',
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
              'You won the memory game!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Score: $_score',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'Attempts: $_attempts',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shuffleCards();
            },
            child: Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Exit'),
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
        title: Text('Memory Game'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _shuffleCards,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Score board
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Score',
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            '$_score',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Attempts',
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            '$_attempts',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 500.ms),
                
                SizedBox(height: 20),
                
                // Game grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onCardTap(index),
                        child: AnimatedBuilder(
                          animation: _successController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _cardMatched[index] 
                                  ? 1.0 + (_successController.value * 0.1)
                                  : 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _cardMatched[index] 
                                      ? Colors.green.shade100
                                      : (_cardFlipped[index] 
                                          ? Colors.white 
                                          : theme.colorScheme.primary),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: _cardFlipped[index] || _cardMatched[index]
                                      ? Text(
                                          _cardEmojis[index],
                                          style: TextStyle(fontSize: 32),
                                        )
                                      : Icon(
                                          Icons.help_outline,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ).animate().scale(
                        delay: Duration(milliseconds: index * 50),
                        duration: 300.ms,
                      );
                    },
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
                    'Match pairs of identical emojis to win!\nTap cards to flip them over.',
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
}
