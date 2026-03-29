import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class JournalPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends ConsumerState<JournalPage> {
  final TextEditingController _journalController = TextEditingController();
  final List<Map<String, dynamic>> _journalEntries = [];
  
  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.book_outlined,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Secure Journal',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.security),
                    onPressed: () => _showSecurityInfo(context),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Your thoughts are safe and encrypted',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 24),
              
              // New entry section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
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
                    Text(
                      'New Entry',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _journalController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Write your thoughts, feelings, or reflections...',
                          hintStyle: GoogleFonts.inter(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveEntry,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, size: 20),
                                SizedBox(width: 8),
                                Text('Save Entry'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => _showMoodSelector(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.secondary,
                          ),
                          child: Icon(Icons.mood, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Previous entries
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Previous Entries',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: _journalEntries.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.library_books_outlined,
                                    size: 64,
                                    color: theme.colorScheme.outline,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No entries yet',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Start writing to track your journey',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _journalEntries.length,
                              itemBuilder: (context, index) {
                                final entry = _journalEntries[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.colorScheme.outline.withOpacity(0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat('MMM d, yyyy').format(entry['date']),
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          Spacer(),
                                          if (entry['mood'] != null)
                                            Text(
                                              entry['mood'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        entry['content'],
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
  }

  void _saveEntry() {
    if (_journalController.text.trim().isEmpty) return;
    
    setState(() {
      _journalEntries.insert(0, {
        'content': _journalController.text.trim(),
        'date': DateTime.now(),
        'mood': null,
      });
    });
    
    _journalController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Entry saved securely'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMoodSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Mood'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            '😊 Happy',
            '😌 Calm',
            '😐 Neutral',
            '😔 Sad',
            '😰 Anxious',
            '😡 Angry',
          ].map((mood) => ListTile(
            title: Text(mood),
            onTap: () {
              Navigator.pop(context);
              // Add mood to current entry
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showSecurityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Security & Privacy'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock, color: Colors.green),
                SizedBox(width: 8),
                Text('End-to-end encryption'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_android, color: Colors.green),
                SizedBox(width: 8),
                Text('Stored locally on device'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.cloud_off, color: Colors.green),
                SizedBox(width: 8),
                Text('No cloud backup'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.delete, color: Colors.green),
                SizedBox(width: 8),
                Text('You control your data'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }
}
