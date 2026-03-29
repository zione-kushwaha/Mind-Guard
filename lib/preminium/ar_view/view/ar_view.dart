import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repository/advanced_ar_view.dart';

class Constants {
  static const Map<String, String> arModels = {
    "C - Cockroach":"https://btazsnvvvrufscmmhrps.supabase.co/storage/v1/object/public/arassets//giant_cockroach.glb",
    "L - Lizard": "https://btazsnvvvrufscmmhrps.supabase.co/storage/v1/object/public/arassets//iguana.glb",
    "S - Spider":"https://btazsnvvvrufscmmhrps.supabase.co/storage/v1/object/public/arassets//animated_spider.glb",
    
  };
}

class ARExperienceScreen extends StatefulWidget {
  const ARExperienceScreen({super.key});

  @override
  State<ARExperienceScreen> createState() => _ARExperienceScreenState();
}

class _ARExperienceScreenState extends State<ARExperienceScreen> with SingleTickerProviderStateMixin {
  final FlutterTts tts = FlutterTts();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  ScreenMode currentScreen = ScreenMode.welcome;
  String? selectedModelUrl;
  String? selectedWord;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _speakWelcome();
    _animationController.forward();
  }

  Future<void> _speakWelcome() async {
    await tts.awaitSpeakCompletion(true);
    await tts.setPitch(0.88); // Lower pitch for slower, deeper voice
    await tts.setSpeechRate(0.5); // Optional: slow down the speech rate
    await tts.speak("Welcome to Advanced AR Experience! Let's explore 3D objects");
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      currentScreen = ScreenMode.categorySelection;
    });
  }

  @override
  void dispose() {
    tts.stop();
    _animationController.dispose();
    super.dispose();
  }

  void _selectModel(String word, String url) {
    setState(() {
      selectedWord = word;
      selectedModelUrl = url;
      currentScreen = ScreenMode.arView;
    });
    tts.speak("Tap on a flat surface to place ${word.split(' - ')[1]}");
  }

  void _backToCategories() {
    setState(() {
      currentScreen = ScreenMode.categorySelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background for all screens
          _buildBackground(),
          
          // Current Screen Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildCurrentScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade900,
            Colors.purple.shade800,
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (currentScreen) {
      case ScreenMode.welcome:
        return _buildWelcomeScreen();
      case ScreenMode.categorySelection:
        return _buildCategoryScreen();
      case ScreenMode.arView:
        return AdvancedARViewScreen(
          modelUrl: selectedModelUrl!,
          word: selectedWord!,
          onBack: _backToCategories,
        );
    }
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            const SizedBox(height: 30),
            
            // Title with gradient text
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.cyan, Colors.pinkAccent],
              ).createShader(bounds),
              child: Text(
                'Advanced AR Experience',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Subtitle
            Text(
              'Explore 3D objects with powerful gesture controls',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 50),
            
            // Get Started Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
                shadowColor: Colors.blueAccent.withOpacity(0.5),
              ),
              onPressed: () {
                _animationController.reset();
                _animationController.forward();
                setState(() {
                  currentScreen = ScreenMode.categorySelection;
                });
              },
              child: Text(
                'Start AR Experience',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Footer note
            Text(
              'Enhanced AR Controls • Optimized for all devices',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryScreen() {
    return Column(
      children: [
        // Custom App Bar
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900,
                Colors.purple.shade800,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        currentScreen = ScreenMode.welcome;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Choose a Letter',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.search, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        
        // Category Grid
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 0.5, 0.9],
                colors: [
                  Colors.blue.shade900.withOpacity(0.8),
                  Colors.purple.shade800.withOpacity(0.6),
                  Colors.deepPurple.shade900.withOpacity(0.8),
                ],
              ),
            ),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowIndicator();
                return true;
              },
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.9,
                ),
                itemCount: Constants.arModels.length,
                itemBuilder: (context, index) {
                  final word = Constants.arModels.keys.elementAt(index);
                  return _buildCategoryCard(word, Constants.arModels.values.elementAt(index));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String word, String modelUrl) {
    final letter = word.split(' - ')[0];
    final object = word.split(' - ')[1];
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getColorForLetter(letter).withOpacity(0.8),
            _getColorForLetter(letter).withOpacity(0.5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _selectModel(word, modelUrl),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Letter with decorative background
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 15),
                
                // Object name
                Text(
                  object,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // View label with icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View in AR',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForLetter(String letter) {
    final colors = [
      Colors.blueAccent,
      Colors.pinkAccent,
      Colors.amber,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.cyan,
      Colors.deepOrangeAccent,
      Colors.lightGreen,
    ];
    return colors[letter.codeUnitAt(0) % colors.length];
  }

  // Custom star shape for confetti
  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }
}

enum ScreenMode {
  welcome,
  categorySelection,
  arView,
}