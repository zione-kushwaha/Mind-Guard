import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationPage extends StatefulWidget {
  @override
  _MeditationPageState createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late AnimationController _waveController;
  late AnimationController _floatController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  int _currentTabIndex = 0;
  bool _isPlaying = false;
  String _currentSession = '';
  Duration _sessionDuration = Duration(minutes: 10);
  
  final List<MeditationCategory> _categories = [
    MeditationCategory(
      id: 'guided',
      name: 'Guided Meditation',
      icon: Icons.headphones,
      color: Colors.blue,
      sessions: [
        MeditationSession(
          id: 'trauma_healing',
          title: 'Trauma Healing',
          description: 'Gentle meditation for trauma recovery',
          duration: Duration(minutes: 15),
          difficulty: 'Beginner',
          benefits: ['Healing', 'Peace', 'Recovery'],
          audioPath: 'assets/music/ocean.wav',
        ),
        MeditationSession(
          id: 'anxiety_relief',
          title: 'Anxiety Relief',
          description: 'Calming meditation to reduce anxiety',
          duration: Duration(minutes: 12),
          difficulty: 'Beginner',
          benefits: ['Calm', 'Relaxation', 'Peace'],
          audioPath: 'assets/music/ocean.wav',
        ),
        MeditationSession(
          id: 'sleep_preparation',
          title: 'Sleep Preparation',
          description: 'Prepare your mind for peaceful sleep',
          duration: Duration(minutes: 20),
          difficulty: 'Beginner',
          benefits: ['Sleep', 'Relaxation', 'Rest'],
          audioPath: 'assets/music/ocean.wav',
        ),
        MeditationSession(
          id: 'grounding',
          title: 'Grounding Meditation',
          description: 'Connect with the present moment',
          duration: Duration(minutes: 10),
          difficulty: 'Beginner',
          benefits: ['Grounding', 'Presence', 'Stability'],
          audioPath: 'assets/music/ocean.wav',
        ),
      ],
    ),
    MeditationCategory(
      id: 'body_scan',
      name: 'Body Scan',
      icon: Icons.accessibility_new,
      color: Colors.green,
      sessions: [
        MeditationSession(
          id: 'full_body',
          title: 'Full Body Scan',
          description: 'Complete body awareness meditation',
          duration: Duration(minutes: 25),
          difficulty: 'Intermediate',
          benefits: ['Awareness', 'Relaxation', 'Healing'],
          audioPath: 'assets/music/ocean.wav',
        ),
        MeditationSession(
          id: 'tension_release',
          title: 'Tension Release',
          description: 'Release physical tension and stress',
          duration: Duration(minutes: 18),
          difficulty: 'Beginner',
          benefits: ['Release', 'Relaxation', 'Comfort'],
          audioPath: 'assets/music/ocean.wav',
        ),
      ],
    ),
    MeditationCategory(
      id: 'breathing',
      name: 'Breathing',
      icon: Icons.air,
      color: Colors.cyan,
      sessions: [
        MeditationSession(
          id: 'box_breathing',
          title: 'Box Breathing',
          description: '4-4-4-4 breathing technique',
          duration: Duration(minutes: 8),
          difficulty: 'Beginner',
          benefits: ['Focus', 'Calm', 'Control'],
          audioPath: 'assets/music/ocean.wav',
        ),
        MeditationSession(
          id: 'calming_breath',
          title: 'Calming Breath',
          description: 'Deep breathing for relaxation',
          duration: Duration(minutes: 12),
          difficulty: 'Beginner',
          benefits: ['Calm', 'Relaxation', 'Peace'],
          audioPath: 'assets/music/ocean.wav',
        ),
      ],
    ),
    MeditationCategory(
      id: 'loving_kindness',
      name: 'Loving Kindness',
      icon: Icons.favorite,
      color: Colors.pink,
      sessions: [
        MeditationSession(
          id: 'self_compassion',
          title: 'Self Compassion',
          description: 'Cultivate kindness toward yourself',
          duration: Duration(minutes: 15),
          difficulty: 'Intermediate',
          benefits: ['Self-Love', 'Compassion', 'Healing'],
          audioPath: 'assets/music/ocean.wav',
        ),
        MeditationSession(
          id: 'forgiveness',
          title: 'Forgiveness',
          description: 'Practice forgiveness meditation',
          duration: Duration(minutes: 18),
          difficulty: 'Advanced',
          benefits: ['Forgiveness', 'Release', 'Peace'],
          audioPath: 'assets/music/ocean.wav',
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
    _waveController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _floatController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _waveController.dispose();
    _floatController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  List<MeditationSession> get _allSessions {
    return _categories.expand((category) => category.sessions).toList();
  }

  void _playSession(MeditationSession session) async {
    try {
      if (_isPlaying && _currentSession == session.id) {
        await _audioPlayer.stop();
        _breatheController.stop();
        _waveController.stop();
        setState(() {
          _isPlaying = false;
          _currentSession = '';
        });
      } else {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = true;
          _currentSession = session.id;
        });
        _breatheController.repeat(reverse: true);
        _waveController.repeat();
      }
    } catch (e) {
      print('Audio playback error: $e');
    }
  }

  void _stopSession() async {
    await _audioPlayer.stop();
    _breatheController.stop();
    _waveController.stop();
    setState(() {
      _isPlaying = false;
      _currentSession = '';
    });
  }

  Widget _buildTabBar() {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem('Meditations', 0, Icons.self_improvement),
          _buildTabItem('Programs', 1, Icons.playlist_play),
          _buildTabItem('Progress', 2, Icons.trending_up),
          _buildTabItem('Timer', 3, Icons.timer),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index, IconData icon) {
    bool isActive = _currentTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentTabIndex = index;
          });
          HapticFeedback.lightImpact();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? Theme.of(context).colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey,
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationsTab() {
    return Column(
      children: [
        // Categories
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Container(
                width: 100,
                margin: EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      category.name,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Sessions List
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _allSessions.length,
              itemBuilder: (context, index) {
                final session = _allSessions[index];
                final isPlaying = _isPlaying && _currentSession == session.id;
                
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isPlaying
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.1),
                              blurRadius: isPlaying ? 20 : 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                          border: isPlaying
                              ? Border.all(color: Colors.blue, width: 2)
                              : null,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: GestureDetector(
                            onTap: () => _playSession(session),
                            child: AnimatedBuilder(
                              animation: _breatheController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: isPlaying
                                      ? 1.0 + (_breatheController.value * 0.1)
                                      : 1.0,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue.withOpacity(0.2),
                                    ),
                                    child: Icon(
                                      isPlaying ? Icons.pause : Icons.play_arrow,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            session.title,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                session.description,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${session.duration.inMinutes} min',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Icon(
                                    Icons.signal_cellular_alt,
                                    size: 14,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    session.difficulty,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: session.benefits.map((benefit) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      benefit,
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
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
    );
  }

  Widget _buildProgramsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatController.value * 10),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.playlist_play,
                    size: 50,
                    color: Colors.purple,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Text(
            'Meditation Programs',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Structured programs coming soon!',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up,
                  size: 40,
                  color: Colors.green,
                ),
                SizedBox(height: 8),
                Text(
                  '7 Days',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Your Progress',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You\'ve meditated for 7 days in a row!',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerTab() {
    return Column(
      children: [
        SizedBox(height: 40),
        AnimatedBuilder(
          animation: _breatheController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_breatheController.value * 0.1),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer,
                      size: 60,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${_sessionDuration.inMinutes} min',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 40),
        Container(
          margin: EdgeInsets.all(16),
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
              Text(
                'Meditation Timer',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimerButton('5 min', Duration(minutes: 5)),
                  _buildTimerButton('10 min', Duration(minutes: 10)),
                  _buildTimerButton('15 min', Duration(minutes: 15)),
                  _buildTimerButton('20 min', Duration(minutes: 20)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimerButton('25 min', Duration(minutes: 25)),
                  _buildTimerButton('30 min', Duration(minutes: 30)),
                  _buildTimerButton('45 min', Duration(minutes: 45)),
                  _buildTimerButton('60 min', Duration(minutes: 60)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerButton(String label, Duration duration) {
    bool isSelected = _sessionDuration == duration;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _sessionDuration = duration;
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Meditation & Mindfulness',
          style: GoogleFonts.inter(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isPlaying)
            IconButton(
              icon: Icon(Icons.stop, color: Colors.red),
              onPressed: _stopSession,
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
            _buildTabBar(),
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildMeditationsTab(),
                  _buildProgramsTab(),
                  _buildProgressTab(),
                  _buildTimerTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeditationCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<MeditationSession> sessions;

  MeditationCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.sessions,
  });
}

class MeditationSession {
  final String id;
  final String title;
  final String description;
  final Duration duration;
  final String difficulty;
  final List<String> benefits;
  final String audioPath;

  MeditationSession({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.benefits,
    required this.audioPath,
  });
}
