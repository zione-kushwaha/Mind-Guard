import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class CalmSoundsPage extends StatefulWidget {
  @override
  _CalmSoundsPageState createState() => _CalmSoundsPageState();
}

class _CalmSoundsPageState extends State<CalmSoundsPage>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isPlaying = false;
  String _currentSound = '';
  double _volume = 0.7;
  int _currentTabIndex = 0;
  Duration _timerDuration = Duration(minutes: 10);

  Map<String, double> _soundMix = {};
  List<String> _favoritesSounds = [];
  
  final List<SoundCategory> _categories = [
    SoundCategory(
      id: 'nature',
      name: 'Nature',
      icon: Icons.nature,
      color: Colors.green,
      sounds: [
        SoundItem(
          id: 'rain',
          name: 'Gentle Rain',
          description: 'Soft rain falling on leaves',
          icon: Icons.grain,
          color: Colors.blue,
          audioPath: 'assets/music/rain.wav', // Using available sound
          duration: Duration(hours: 1),
        ),
        SoundItem(
          id: 'ocean',
          name: 'Ocean Waves',
          description: 'Peaceful ocean waves',
          icon: Icons.water,
          color: Colors.teal,
          audioPath: 'assets/music/ocean.wav', // Using available sound
          duration: Duration(hours: 1),
        ),
        SoundItem(
          id: 'forest',
          name: 'Forest Sounds',
          description: 'Birds chirping in the forest',
          icon: Icons.forest,
          color: Colors.green,
          audioPath: 'assets/sounds/notification_3.mp3', // Using available sound
          duration: Duration(minutes: 45),
        ),
        SoundItem(
          id: 'wind',
          name: 'Gentle Wind',
          description: 'Soft wind through trees',
          icon: Icons.air,
          color: Colors.cyan,
          audioPath: 'assets/sounds/notification_4.mp3', // Using available sound
          duration: Duration(minutes: 30),
        ),
        SoundItem(
          id: 'thunder',
          name: 'Distant Thunder',
          description: 'Calming thunderstorm',
          icon: Icons.flash_on,
          color: Colors.indigo,
          audioPath: 'assets/music/thunder.wav', // Using available sound
          duration: Duration(minutes: 20),
        ),
      ],
    ),
    SoundCategory(
      id: 'meditation',
      name: 'Meditation',
      icon: Icons.self_improvement,
      color: Colors.purple,
      sounds: [
        SoundItem(
          id: 'tibetan_bowl',
          name: 'Tibetan Bowl',
          description: 'Healing bowl sounds',
          icon: Icons.circle_outlined,
          color: Colors.amber,
          audioPath: 'assets/music/tibetan_bowl.wav', // Using neural beats
          duration: Duration(minutes: 15),
        ),
        SoundItem(
          id: 'om_chanting',
          name: 'Om Chanting',
          description: 'Sacred meditation chants',
          icon: Icons.spa,
          color: Colors.deepOrange,
          audioPath: 'assets/neural_beats/neural_beats_2.mp3', // Using neural beats
          duration: Duration(minutes: 20),
        ),
        SoundItem(
          id: 'temple_bells',
          name: 'Temple Bells',
          description: 'Peaceful temple ambiance',
          icon: Icons.notifications_none,
          color: Colors.brown,
          audioPath: 'assets/music/temple_bells.wav', // Using neural beats
          duration: Duration(minutes: 25),
        ),
      ],
    ),
    SoundCategory(
      id: 'focus',
      name: 'Focus',
      icon: Icons.psychology,
      color: Colors.indigo,
      sounds: [
        SoundItem(
          id: 'white_noise',
          name: 'White Noise',
          description: 'Gentle white noise for focus',
          icon: Icons.waves,
          color: Colors.grey,
          audioPath: 'assets/neural_beats/neural_beats_4.mp3', // Using neural beats
          duration: Duration(hours: 2),
        ),
        SoundItem(
          id: 'brown_noise',
          name: 'Brown Noise',
          description: 'Deep focus brown noise',
          icon: Icons.blur_on,
          color: Colors.brown,
          audioPath: 'assets/neural_beats/neural_beats_5.mp3', // Using neural beats
          duration: Duration(hours: 2),
        ),
        SoundItem(
          id: 'pink_noise',
          name: 'Pink Noise',
          description: 'Balanced pink noise',
          icon: Icons.graphic_eq,
          color: Colors.pink,
          audioPath: 'assets/sounds/notification_1.mp3', // Using available sound
          duration: Duration(hours: 2),
        ),
      ],
    ),
    SoundCategory(
      id: 'cozy',
      name: 'Cozy',
      icon: Icons.home,
      color: Colors.orange,
      sounds: [
        SoundItem(
          id: 'fireplace',
          name: 'Fireplace',
          description: 'Crackling fireplace',
          icon: Icons.fireplace,
          color: Colors.orange,
          audioPath: 'assets/sounds/notification_2.mp3', // Using available sound
          duration: Duration(hours: 1),
        ),
        SoundItem(
          id: 'coffee_shop',
          name: 'Coffee Shop',
          description: 'Cozy cafe ambiance',
          icon: Icons.local_cafe,
          color: Colors.brown,
          audioPath: 'assets/sounds/notification_3.mp3', // Using available sound
          duration: Duration(minutes: 45),
        ),
        SoundItem(
          id: 'library',
          name: 'Library',
          description: 'Quiet library atmosphere',
          icon: Icons.library_books,
          color: Colors.teal,
          audioPath: 'assets/sounds/notification_4.mp3', // Using available sound
          duration: Duration(minutes: 30),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    
    // Add audio player listeners
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      print('🎵 Audio player state changed: $state');
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        setState(() {
          _isPlaying = false;
          _currentSound = '';
        });
        _waveController.stop();
        _pulseController.stop();
      }
    });
    
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      print('⏱️ Audio duration: $duration');
    });
    
    _audioPlayer.onPositionChanged.listen((Duration position) {
      // Optional: You can add position tracking here if needed
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  List<SoundItem> get _allSounds {
    return _categories.expand((category) => category.sounds).toList();
  }

  List<SoundItem> get _favoriteSounds {
    return _allSounds.where((sound) => _favoritesSounds.contains(sound.id)).toList();
  }

  void _playSound(SoundItem sound) async {
    try {
      if (_isPlaying && _currentSound == sound.id) {
        // Stop currently playing sound
        await _audioPlayer.stop();
        _waveController.stop();
        _pulseController.stop();
        setState(() {
          _isPlaying = false;
          _currentSound = '';
        });
        print('🔇 Stopped playing: ${sound.name}');
      } else {
        // Stop any currently playing sound first
        await _audioPlayer.stop();
        
        // Update UI state
        setState(() {
          _isPlaying = true;
          _currentSound = sound.id;
        });
        
        // Start animations
        _waveController.repeat();
        _pulseController.repeat();
        
        // Play the actual audio file
        print('🎵 Attempting to play: ${sound.name} from ${sound.audioPath}');
        await _audioPlayer.play(AssetSource(sound.audioPath.replaceFirst('assets/', '')));
        await _audioPlayer.setVolume(_volume);
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        
        print('✅ Successfully started playing: ${sound.name}');
      }
    } catch (e) {
      print('❌ Audio playback error for ${sound.name}: $e');
      // Reset state on error
      setState(() {
        _isPlaying = false;
        _currentSound = '';
      });
      _waveController.stop();
      _pulseController.stop();
      
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to play ${sound.name}: Audio file not found'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleFavorite(String soundId) {
    setState(() {
      if (_favoritesSounds.contains(soundId)) {
        _favoritesSounds.remove(soundId);
      } else {
        _favoritesSounds.add(soundId);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _stopAllSounds() async {
    await _audioPlayer.stop();
    _waveController.stop();
    _pulseController.stop();
    setState(() {
      _isPlaying = false;
      _currentSound = '';
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
          _buildTabItem('Sounds', 0, Icons.music_note),
          _buildTabItem('Mix', 1, Icons.tune),
          _buildTabItem('Favorites', 2, Icons.favorite),
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

  Widget _buildSoundsTab() {
    return Column(
      children: [
        // Category Selector
        Container(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Container(
                width: 80,
                margin: EdgeInsets.only(right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                        size: 24,
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Sounds Grid
        Expanded(
          child: AnimationLimiter(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: _allSounds.length,
              itemBuilder: (context, index) {
                final sound = _allSounds[index];
                final isCurrentlyPlaying = _isPlaying && _currentSound == sound.id;
                final isFavorite = _favoritesSounds.contains(sound.id);
                
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => _playSound(sound),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isCurrentlyPlaying
                                    ? sound.color.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.2),
                                blurRadius: isCurrentlyPlaying ? 20 : 10,
                                spreadRadius: isCurrentlyPlaying ? 2 : 0,
                                offset: Offset(0, 5),
                              ),
                            ],
                            border: isCurrentlyPlaying
                                ? Border.all(color: sound.color, width: 2)
                                : null,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedBuilder(
                                    animation: _waveController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: isCurrentlyPlaying
                                            ? 1.0 + (_waveController.value * 0.1)
                                            : 1.0,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: sound.color.withOpacity(0.2),
                                          ),
                                          child: Icon(
                                            isCurrentlyPlaying
                                                ? Icons.pause
                                                : sound.icon,
                                            size: 40,
                                            color: sound.color,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    sound.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    sound.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        _formatDuration(sound.duration),
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isCurrentlyPlaying)
                                    Container(
                                      margin: EdgeInsets.only(top: 8),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: sound.color,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Playing',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ).animate().fade().scale(),
                                ],
                              ),
                              
                              // Favorite Button
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () => _toggleFavorite(sound.id),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: isFavorite 
                                          ? Colors.red.withOpacity(0.2)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                      size: 16,
                                    ),
                                  ),
                                ),
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

  Widget _buildMixTab() {
    return Column(
      children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Your Perfect Mix',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Blend different sounds to create your ideal ambiance',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _allSounds.length,
            itemBuilder: (context, index) {
              final sound = _allSounds[index];
              final mixVolume = _soundMix[sound.id] ?? 0.0;
              
              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: sound.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        sound.icon,
                        color: sound.color,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sound.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
                              thumbColor: sound.color,
                              activeTrackColor: sound.color,
                              inactiveTrackColor: Colors.grey.shade300,
                            ),
                            child: Slider(
                              value: mixVolume,
                              onChanged: (value) {
                                setState(() {
                                  _soundMix[sound.id] = value;
                                });
                              },
                              min: 0.0,
                              max: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    if (_favoriteSounds.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No Favorites Yet',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the heart icon on sounds you love',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: _favoriteSounds.length,
      itemBuilder: (context, index) {
        final sound = _favoriteSounds[index];
        final isCurrentlyPlaying = _isPlaying && _currentSound == sound.id;
        
        return GestureDetector(
          onTap: () => _playSound(sound),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isCurrentlyPlaying
                      ? sound.color.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.2),
                  blurRadius: isCurrentlyPlaying ? 20 : 10,
                  spreadRadius: isCurrentlyPlaying ? 2 : 0,
                  offset: Offset(0, 5),
                ),
              ],
              border: isCurrentlyPlaying
                  ? Border.all(color: sound.color, width: 2)
                  : null,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isCurrentlyPlaying
                              ? 1.0 + (_waveController.value * 0.1)
                              : 1.0,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: sound.color.withOpacity(0.2),
                            ),
                            child: Icon(
                              isCurrentlyPlaying
                                  ? Icons.pause
                                  : sound.icon,
                              size: 40,
                              color: sound.color,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      sound.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      sound.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                
                // Remove from favorites
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(sound.id),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimerTab() {
    return Column(
      children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sleep Timer',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Set a timer to automatically stop sounds',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _formatDuration(_timerDuration),
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Timer Controls
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimerButton('5m', Duration(minutes: 5)),
                  _buildTimerButton('10m', Duration(minutes: 10)),
                  _buildTimerButton('15m', Duration(minutes: 15)),
                  _buildTimerButton('30m', Duration(minutes: 30)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimerButton('45m', Duration(minutes: 45)),
                  _buildTimerButton('1h', Duration(hours: 1)),
                  _buildTimerButton('2h', Duration(hours: 2)),
                  _buildTimerButton('Off', Duration.zero),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerButton(String label, Duration duration) {
    bool isSelected = _timerDuration == duration;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _timerDuration = duration;
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return 'Off';
    
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
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
          'Calming Sounds',
          style: GoogleFonts.inter(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isPlaying)
            IconButton(
              icon: Icon(Icons.stop, color: Colors.red),
              onPressed: _stopAllSounds,
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
            // Volume Control
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.volume_up, color: theme.colorScheme.primary),
                      SizedBox(width: 8),
                      Text(
                        'Volume',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${(_volume * 100).round()}%',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SliderTheme(
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
                        _audioPlayer.setVolume(value);
                      },
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ],
              ),
            ).animate().slideY(begin: -1, duration: 600.ms).fade(),
            
            // Tab Bar
            _buildTabBar(),
            
            // Tab Content
            Expanded(
              child: IndexedStack(
                index: _currentTabIndex,
                children: [
                  _buildSoundsTab(),
                  _buildMixTab(),
                  _buildFavoritesTab(),
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

class SoundCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<SoundItem> sounds;

  SoundCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.sounds,
  });
}

class SoundItem {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String audioPath;
  final Duration duration;

  SoundItem({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.audioPath,
    required this.duration,
  });
}
