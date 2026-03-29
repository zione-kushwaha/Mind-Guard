import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:audioplayers/audioplayers.dart';

class NeuralBeatsPage extends StatefulWidget {
  @override
  _NeuralBeatsPageState createState() => _NeuralBeatsPageState();
}

class _NeuralBeatsPageState extends State<NeuralBeatsPage>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isPlaying = false;
  String _currentBeat = '';
  double _volume = 0.6;
  
  final List<NeuralBeat> _beats = [
    NeuralBeat(
      id: 'alpha',
      name: 'Alpha Waves',
      description: 'Relaxed awareness and calm focus',
      frequency: '8-12 Hz',
      icon: Icons.waves,
      color: Colors.blue,
      audioPath: 'assets/music/ocean.wav',
      benefits: ['Relaxation', 'Focus', 'Creativity'],
    ),
    NeuralBeat(
      id: 'beta',
      name: 'Beta Waves',
      description: 'Active concentration and alertness',
      frequency: '12-30 Hz',
      icon: Icons.psychology,
      color: Colors.green,
      audioPath: 'nassets/music/ocean.wav',
      benefits: ['Alertness', 'Problem Solving', 'Active Thinking'],
    ),
    NeuralBeat(
      id: 'theta',
      name: 'Theta Waves',
      description: 'Deep meditation and healing',
      frequency: '4-8 Hz',
      icon: Icons.self_improvement,
      color: Colors.purple,
      audioPath: 'assets/music/ocean.wav',
      benefits: ['Deep Meditation', 'Healing', 'Intuition'],
    ),
    NeuralBeat(
      id: 'delta',
      name: 'Delta Waves',
      description: 'Deep sleep and restoration',
      frequency: '0.5-4 Hz',
      icon: Icons.bedtime,
      color: Colors.indigo,
      audioPath: 'assets/music/ocean.wav',
      benefits: ['Deep Sleep', 'Healing', 'Recovery'],
    ),
    NeuralBeat(
      id: 'gamma',
      name: 'Gamma Waves',
      description: 'High-level cognitive functioning',
      frequency: '30-100 Hz',
      icon: Icons.flash_on,
      color: Colors.orange,
      audioPath: 'assets/music/ocean.wav',
      benefits: ['Peak Performance', 'Insight', 'Consciousness'],
    ),
    NeuralBeat(
      id: 'schumann',
      name: 'Schumann Resonance',
      description: 'Earth\'s natural frequency',
      frequency: '7.83 Hz',
      icon: Icons.public,
      color: Colors.brown,
      audioPath: 'assets/music/ocean.wav',
      benefits: ['Grounding', 'Balance', 'Natural Harmony'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    // Listen to audio player state changes
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() {
          _isPlaying = false;
          _currentBeat = '';
        });
        _waveController.stop();
        _pulseController.stop();
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playBeat(NeuralBeat beat) async {
    try {
      if (_isPlaying && _currentBeat == beat.id) {
        // Stop current beat
        await _audioPlayer.stop();
        _waveController.stop();
        _pulseController.stop();
        setState(() {
          _isPlaying = false;
          _currentBeat = '';
        });
        print('🔇 Stopped playing: ${beat.name}');
      } else {
        // Stop any currently playing beat
        await _audioPlayer.stop();
        
        setState(() {
          _isPlaying = true;
          _currentBeat = beat.id;
        });
        
        // Start animations
        _waveController.repeat();
        _pulseController.repeat(reverse: true);
        
        // Play the actual audio
        try {
          await _audioPlayer.play(AssetSource(beat.audioPath));
          await _audioPlayer.setVolume(_volume);
          await _audioPlayer.setReleaseMode(ReleaseMode.loop);
          print('🎵 Playing: ${beat.name} (${beat.audioPath})');
        } catch (audioError) {
          print('❌ Audio file not found: ${beat.audioPath}');
          // Fallback: play a default sound
          try {
            await _audioPlayer.play(AssetSource('sounds/notification_1.mp3'));
            await _audioPlayer.setVolume(_volume);
            await _audioPlayer.setReleaseMode(ReleaseMode.loop);
            print('🔄 Playing fallback audio for: ${beat.name}');
          } catch (fallbackError) {
            print('❌ Fallback audio also failed: $fallbackError');
            // Reset state if all audio fails
            setState(() {
              _isPlaying = false;
              _currentBeat = '';
            });
            _waveController.stop();
            _pulseController.stop();
          }
        }
      }
    } catch (e) {
      print('❌ Audio playback error: $e');
      setState(() {
        _isPlaying = false;
        _currentBeat = '';
      });
      _waveController.stop();
      _pulseController.stop();
    }
  }

  void _stopAllBeats() async {
    await _audioPlayer.stop();
    _waveController.stop();
    _pulseController.stop();
    setState(() {
      _isPlaying = false;
      _currentBeat = '';
    });
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
          'Neural Beats',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isPlaying)
            IconButton(
              icon: Icon(Icons.stop, color: Colors.red),
              onPressed: _stopAllBeats,
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
              Colors.indigo.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            // Info Card
            Card(
              margin: EdgeInsets.all(16),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: theme.colorScheme.primary),
                        SizedBox(width: 8),
                        Text(
                          'About Neural Beats',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Binaural beats can help synchronize your brainwaves to specific frequencies, promoting relaxation, focus, or sleep. Use headphones for the best experience.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Volume Control
                    Row(
                      children: [
                        Icon(Icons.volume_up, color: theme.colorScheme.primary),
                        SizedBox(width: 8),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 6,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                              thumbColor: theme.colorScheme.primary,
                              activeTrackColor: theme.colorScheme.primary,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                            child: Slider(
                              value: _volume,
                              onChanged: (value) {
                                setState(() {
                                  _volume = value;
                                });
                                // Update volume in real-time if audio is playing
                                if (_isPlaying) {
                                  _audioPlayer.setVolume(value);
                                }
                              },
                              min: 0.0,
                              max: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 40,
                          child: Text(
                            '${(_volume * 100).round()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).animate().slideY(begin: -1, duration: 600.ms).fade(),
            
            // Neural Beats Grid
            Expanded(
              child: AnimationLimiter(
                child: GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _beats.length,
                  itemBuilder: (context, index) {
                    final beat = _beats[index];
                    final isCurrentlyPlaying = _isPlaying && _currentBeat == beat.id;
                    
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      columnCount: 2,
                      child: ScaleAnimation(
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () => _playBeat(beat),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: isCurrentlyPlaying
                                        ? beat.color.withOpacity(0.3)
                                        : Colors.grey.withOpacity(0.2),
                                    blurRadius: isCurrentlyPlaying ? 20 : 10,
                                    spreadRadius: isCurrentlyPlaying ? 2 : 0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                                border: isCurrentlyPlaying
                                    ? Border.all(
                                        color: beat.color,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Beat Icon with Animation
                                    AnimatedBuilder(
                                      animation: _pulseController,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: isCurrentlyPlaying
                                              ? 1.0 + (_pulseController.value * 0.1)
                                              : 1.0,
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: beat.color.withOpacity(0.2),
                                            ),
                                            child: Icon(
                                              isCurrentlyPlaying
                                                  ? Icons.pause
                                                  : beat.icon,
                                              size: 30,
                                              color: beat.color,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    
                                    SizedBox(height: 12),
                                    
                                    // Beat Name
                                    Text(
                                      beat.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    
                                    SizedBox(height: 4),
                                    
                                    // Frequency
                                    Text(
                                      beat.frequency,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: beat.color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    
                                    SizedBox(height: 8),
                                    
                                    // Description
                                    Text(
                                      beat.description,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    
                                    SizedBox(height: 8),
                                    
                                    // Benefits
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: beat.benefits.take(2).map((benefit) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: beat.color.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            benefit,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: beat.color,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    
                                    if (isCurrentlyPlaying)
                                      Container(
                                        margin: EdgeInsets.only(top: 8),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: beat.color,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Playing',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ).animate().fade().scale(),
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
          ],
        ),
      ),
    );
  }
}

class NeuralBeat {
  final String id;
  final String name;
  final String description;
  final String frequency;
  final IconData icon;
  final Color color;
  final String audioPath;
  final List<String> benefits;

  NeuralBeat({
    required this.id,
    required this.name,
    required this.description,
    required this.frequency,
    required this.icon,
    required this.color,
    required this.audioPath,
    required this.benefits,
  });
}
