import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MoodCheckWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MoodCheckWidget> createState() => _MoodCheckWidgetState();
}

class _MoodCheckWidgetState extends ConsumerState<MoodCheckWidget> {
  String? selectedMood;
  
  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Great', 'color': Colors.green},
    {'emoji': '😌', 'label': 'Good', 'color': Colors.blue},
    {'emoji': '😐', 'label': 'Okay', 'color': Colors.orange},
    {'emoji': '😔', 'label': 'Low', 'color': Colors.red},
    {'emoji': '😰', 'label': 'Anxious', 'color': Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mood,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'How are you feeling today?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMMM d').format(DateTime.now()),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moods.map((mood) {
              final isSelected = selectedMood == mood['label'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMood = mood['label'];
                  });
                  _saveMood(mood['label']);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? mood['color'].withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSelected 
                          ? mood['color']
                          : theme.colorScheme.outline.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        mood['emoji'],
                        style: TextStyle(fontSize: 24),
                      ),
                      SizedBox(height: 2),
                      Text(
                        mood['label'],
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected 
                              ? mood['color']
                              : theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedMood != null) ...[
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Mood logged for today',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _saveMood(String mood) {
    // This would save to local storage or backend
    // For now, we'll just show a confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mood "$mood" saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
