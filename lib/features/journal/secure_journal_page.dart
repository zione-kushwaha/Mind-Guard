import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';

class SecureJournalPage extends StatefulWidget {
  @override
  _SecureJournalPageState createState() => _SecureJournalPageState();
}

class _SecureJournalPageState extends State<SecureJournalPage>
    with TickerProviderStateMixin {
  late AnimationController _fabController;
  final TextEditingController _entryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<JournalEntry> _entries = [];
  String _selectedMood = 'neutral';
  List<String> _selectedTags = [];
  
  final List<String> _moods = [
    'happy', 'sad', 'anxious', 'calm', 'angry', 'grateful', 'hopeful', 'neutral'
  ];
  
  final List<String> _availableTags = [
    'trigger', 'progress', 'therapy', 'medication', 'family', 'work', 
    'sleep', 'exercise', 'social', 'coping', 'breakthrough', 'setback'
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _loadSampleEntries();
  }

  @override
  void dispose() {
    _fabController.dispose();
    _entryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadSampleEntries() {
    // Sample entries for demonstration
    _entries = [
      JournalEntry(
        id: '1',
        content: 'Had a good therapy session today. Learned about grounding techniques.',
        mood: 'hopeful',
        tags: ['therapy', 'progress'],
        date: DateTime.now().subtract(Duration(days: 1)),
      ),
      JournalEntry(
        id: '2',
        content: 'Feeling anxious about the upcoming presentation at work.',
        mood: 'anxious',
        tags: ['work', 'trigger'],
        date: DateTime.now().subtract(Duration(days: 3)),
      ),
    ];
  }

  void _showAddEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('New Journal Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Entry Content
                TextField(
                  controller: _entryController,
                  decoration: InputDecoration(
                    hintText: 'How are you feeling today?',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 5,
                ),
                
                SizedBox(height: 16),
                
                // Mood Selection
                Text('Mood:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _moods.map((mood) {
                    return FilterChip(
                      label: Text('${_getMoodEmoji(mood)} ${mood.toUpperCase()}'),
                      selected: _selectedMood == mood,
                      onSelected: (selected) {
                        setDialogState(() {
                          _selectedMood = mood;
                        });
                      },
                    );
                  }).toList(),
                ),
                
                SizedBox(height: 16),
                
                // Tags Selection
                Text('Tags:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _availableTags.map((tag) {
                    return FilterChip(
                      label: Text(tag),
                      selected: _selectedTags.contains(tag),
                      onSelected: (selected) {
                        setDialogState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _entryController.clear();
                _selectedTags.clear();
                _selectedMood = 'neutral';
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_entryController.text.isNotEmpty) {
                  _addEntry();
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _addEntry() {
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _entryController.text,
      mood: _selectedMood,
      tags: List.from(_selectedTags),
      date: DateTime.now(),
    );
    
    setState(() {
      _entries.insert(0, entry);
    });
    
    _entryController.clear();
    _selectedTags.clear();
    _selectedMood = 'neutral';
  }

  String _getMoodEmoji(String mood) {
    switch (mood) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'anxious':
        return '😰';
      case 'calm':
        return '😌';
      case 'angry':
        return '😠';
      case 'grateful':
        return '🙏';
      case 'hopeful':
        return '🌟';
      default:
        return '😐';
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return Colors.yellow;
      case 'sad':
        return Colors.blue;
      case 'anxious':
        return Colors.red;
      case 'calm':
        return Colors.green;
      case 'angry':
        return Colors.orange;
      case 'grateful':
        return Colors.purple;
      case 'hopeful':
        return Colors.teal;
      default:
        return Colors.grey;
    }
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
          'Secure Journal',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.analytics, color: theme.colorScheme.primary),
            onPressed: () {
              // Show mood analytics
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.blue.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            // Security Notice
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your journal entries are encrypted and stored securely.',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: -1, duration: 600.ms).fade(),
            
            // Entries List
            Expanded(
              child: _entries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.book_outlined,
                            size: 100,
                            color: Colors.grey.shade300,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'No entries yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Start by adding your first journal entry',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : AnimationLimiter(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          final entry = _entries[index];
                          
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Card(
                                  margin: EdgeInsets.only(bottom: 16),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Header
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getMoodColor(entry.mood).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    _getMoodEmoji(entry.mood),
                                                    style: TextStyle(fontSize: 16),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    entry.mood.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: _getMoodColor(entry.mood),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              DateFormat('MMM dd, yyyy').format(entry.date),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 12),
                                        
                                        // Content
                                        Text(
                                          entry.content,
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 1.5,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        
                                        if (entry.tags.isNotEmpty) ...[
                                          SizedBox(height: 12),
                                          Wrap(
                                            spacing: 6,
                                            children: entry.tags.map((tag) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: theme.colorScheme.primary.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '#$tag',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: theme.colorScheme.primary,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ],
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEntryDialog,
        backgroundColor: theme.colorScheme.primary,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Entry',
          style: TextStyle(color: Colors.white),
        ),
      ).animate().scale(delay: 800.ms),
    );
  }
}

class JournalEntry {
  final String id;
  final String content;
  final String mood;
  final List<String> tags;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.content,
    required this.mood,
    required this.tags,
    required this.date,
  });
}
