// FULL WORKING CODE IN SINGLE FILE

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

// ---------------------- API SERVICE ------------------------
class ApiService {
  static const String baseUrl = 'http://pleasing-guppy-hardy.ngrok-free.app';
  static const String token = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNTI3MzM3LCJpYXQiOjE3NTIzNDczMzcsImp0aSI6ImVmYTk4Y2U5MWM4ZDQ3N2RiNzU2OGNmMjYxYjE5MTZmIiwidXNlcl9pZCI6MSwiaXNfc3RhZmYiOnRydWUsImlzX3N1cGVydXNlciI6dHJ1ZX0.8085J3ZmXutHVGhXaqx-NxjQPuLU_iJ4YlXctTY1qOQ'; // Updated token

  static Future<http.Response> get(String endpoint) async {
    print('🌐 Making request to: $baseUrl$endpoint');
    print('🔑 Using token: ${token.substring(0, 50)}...');
    
    final response = await http.get(
      Uri.parse(baseUrl + endpoint),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-CSRFTOKEN': '75DFdIYWMfIFVPA168J2cELVNAFzkXDfRlTmjHiGW56ucEm2NPhA9GQBRltODesD',
      },
    );
    
    print('📡 Response Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('❌ Response Body: ${response.body}');
    }
    
    return response;
  }
}

// ---------------------- STORY SERVICE ------------------------
class StoryService {
  static Future<String> fetchTodayStory() async {
    try {
      final response = await ApiService.get('/api/today-story/');
      log(response.body, name: 'Today Story Response');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['story_text'] as String;
      } else {
        throw Exception('Failed to load story: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching story: $e');
    }
  }
}

// ---------------------- CAMERA STATE ------------------------
final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});

class CameraState {
  final CameraController? controller;
  final bool isInitialized;
  final bool isLoading;
  final String? error;

  CameraState({this.controller, this.isInitialized = false, this.isLoading = false, this.error});

  CameraState copyWith({
    CameraController? controller,
    bool? isInitialized,
    bool? isLoading,
    String? error,
  }) {
    return CameraState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  Future<void> initializeCamera() async {
    try {
      state = state.copyWith(isLoading: true);
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(frontCamera, ResolutionPreset.medium, enableAudio: false);
      await controller.initialize();
      state = state.copyWith(controller: controller, isInitialized: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  @override
  void dispose() {
    state.controller?.dispose();
    super.dispose();
  }
}

final storyProvider = FutureProvider<String>((ref) async {
  return StoryService.fetchTodayStory();
});

// ---------------------- MAIN SCREEN ------------------------
class WordReadingCameraScreen extends ConsumerStatefulWidget {
  const WordReadingCameraScreen({super.key});

  @override
  ConsumerState<WordReadingCameraScreen> createState() => _WordReadingCameraScreenState();
}

class _WordReadingCameraScreenState extends ConsumerState<WordReadingCameraScreen> with WidgetsBindingObserver {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isComplete = false;
  String _recognizedText = '';
  List<String> _words = [];
  List<bool> _completed = [];
  int _currentIndex = 0;

  // Audio players
  late AudioPlayer _backgroundPlayer;
  late AudioPlayer _effectPlayer;
  late AudioPlayer _successPlayer;
  bool _isMusicPlaying = false;

  // Audio asset paths
  final List<String> _backgroundMusic = [
    'assets/music/ocean.wav',
    'assets/music/ocean.wav',
    'assets/music/ocean.wav',
    'assets/music/ocean.wav',
    'assets/music/ocean.wav',
  ];

  final List<String> _successSounds = [
    'assets/sounds/notification_1.mp3',
    'assets/sounds/notification_2.mp3',
    'assets/sounds/notification_3.mp3',
    'assets/sounds/notification_4.mp3',
    'assets/sounds/notification_5.mp3',
  ];

  @override
  void initState() {
    super.initState();
    _initAudio();
    _initSpeech();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraProvider.notifier).initializeCamera();
      _startBackgroundMusic();
    });
  }

  // Initialize audio players
  void _initAudio() {
    _backgroundPlayer = AudioPlayer();
    _effectPlayer = AudioPlayer();
    _successPlayer = AudioPlayer();
  }

  // Start background music
  void _startBackgroundMusic() async {
    try {
      if (!_isMusicPlaying) {
        final randomMusic = _backgroundMusic[DateTime.now().millisecond % _backgroundMusic.length];
        await _backgroundPlayer.play(AssetSource(randomMusic.replaceFirst('assets/', '')));
        await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
        await _backgroundPlayer.setVolume(0.3); // Low volume for background
        setState(() => _isMusicPlaying = true);
        print('🎵 Playing background music: $randomMusic');
      }
    } catch (e) {
      print('❌ Error playing background music: $e');
    }
  }

  // Stop background music
  void _stopBackgroundMusic() async {
    try {
      await _backgroundPlayer.stop();
      setState(() => _isMusicPlaying = false);
      print('🔇 Background music stopped');
    } catch (e) {
      print('❌ Error stopping background music: $e');
    }
  }

  // Play success sound when word is completed
  void _playSuccessSound() async {
    try {
      final randomSound = _successSounds[DateTime.now().millisecond % _successSounds.length];
      await _effectPlayer.play(AssetSource(randomSound.replaceFirst('assets/', '')));
      await _effectPlayer.setVolume(0.7);
      print('🔔 Playing success sound: $randomSound');
    } catch (e) {
      print('❌ Error playing success sound: $e');
    }
  }

  // Play completion celebration sound
  void _playCompletionSound() async {
    try {
      final celebrationSound = _successSounds.first;
      await _successPlayer.play(AssetSource(celebrationSound.replaceFirst('assets/', '')));
      await _successPlayer.setVolume(1.0);
      print('🎉 Playing completion sound: $celebrationSound');
    } catch (e) {
      print('❌ Error playing completion sound: $e');
    }
  }

  void _initSpeech() async {
    _speech = stt.SpeechToText();
    await _speech.initialize(onStatus: (s) {
      if (s == 'done') setState(() => _isListening = false);
    });
  }

  void _startListening() async {
    if (!_speech.isAvailable || _isComplete) return;
    setState(() => _isListening = true);
    await _speech.listen(onResult: (r) {
      _recognizedText = r.recognizedWords.toLowerCase();
      _matchWord();
    });
  }

  void _matchWord() {
    final spoken = _recognizedText.split(' ');
    final target = _words[_currentIndex].toLowerCase();
    if (spoken.contains(target)) {
      setState(() {
        _completed[_currentIndex] = true;
        _currentIndex++;
        // Play success sound for each word completed
        _playSuccessSound();
        
        if (_currentIndex >= _words.length) {
          _isComplete = true;
          _speech.stop();
          // Play completion celebration sound
          _playCompletionSound();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _speech.stop();
    // Dispose audio players
    _backgroundPlayer.dispose();
    _effectPlayer.dispose();
    _successPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraProvider);
    final storyAsync = ref.watch(storyProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (cameraState.isInitialized && cameraState.controller != null)
              CameraPreview(cameraState.controller!)
            else
              const Center(child: CircularProgressIndicator()),

            // Audio control floating button
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    heroTag: "music_control",
                    mini: true,
                    backgroundColor: _isMusicPlaying ? Colors.orange : Colors.blue,
                    onPressed: () {
                      if (_isMusicPlaying) {
                        _stopBackgroundMusic();
                      } else {
                        _startBackgroundMusic();
                      }
                    },
                    child: Icon(_isMusicPlaying ? Icons.music_off : Icons.music_note),
                  ),
                  const SizedBox(height: 10),
                  // Test sound button
                  FloatingActionButton(
                    heroTag: "test_sound",
                    mini: true,
                    backgroundColor: Colors.green,
                    onPressed: _playSuccessSound,
                    child: const Icon(Icons.notifications),
                  ),
                ],
              ),
            ),

            storyAsync.when(
              data: (story) {
                if (_words.isEmpty) {
                  _words = story.split(' ').take(15).toList();
                  _completed = List.filled(_words.length, false);
                  Future.delayed(const Duration(seconds: 1), _startListening);
                }
                return Positioned(
                  bottom: 50,
                  left: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Wrap(
                        children: _words.asMap().entries.map((entry) {
                          final index = entry.key;
                          final word = entry.value;
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: Chip(
                              label: Text(word, style: TextStyle(color: Colors.white)),
                              backgroundColor: _completed[index] ? Colors.green : Colors.grey,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _isComplete ? null : _startListening,
                            child: Text(_isListening ? 'Listening...' : 'Start Again'),
                          ),
                          // Audio control button
                          ElevatedButton.icon(
                            onPressed: () {
                              if (_isMusicPlaying) {
                                _stopBackgroundMusic();
                              } else {
                                _startBackgroundMusic();
                              }
                            },
                            icon: Icon(_isMusicPlaying ? Icons.volume_off : Icons.volume_up),
                            label: Text(_isMusicPlaying ? 'Mute' : 'Music'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isMusicPlaying ? Colors.orange : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      if (_isComplete)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('Great job!', style: TextStyle(color: Colors.green, fontSize: 24)),
                        ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ],
        ),
      ),
    );
  }
}
