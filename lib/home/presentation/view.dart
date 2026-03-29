import 'dart:convert';

import 'package:usnepal/home/widgets/temp_2.dart';
import 'package:http/http.dart' as http;
import '/core/providers/app_providers.dart';
import '/home/widgets/emergency_button.dart';
import '/home/widgets/mood_check_widget.dart';
import '/home/widgets/quick_access_bar.dart';
import '/home/widgets/templete_widget.dart';
import '/home/widgets/welcome_header.dart';
import '/pages/journal/journal_page.dart';
import '/pages/profile/profile_page.dart';
import '/demo/assessment_demo_page.dart';
import '/app/view/word_reading_camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animationController.forward();
    _pulseController.repeat(reverse: true);
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentPageIndex = ref.watch(pageIndexProvider);
    final emergencyMode = ref.watch(emergencyModeProvider);
    
    return Scaffold(
      backgroundColor: emergencyMode 
          ? Colors.red.shade50
          : theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: emergencyMode 
            ? Colors.red.shade700
            : Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              child: Icon(
                Icons.shield_outlined,
                color: emergencyMode 
                    ? Colors.white
                    : theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: 8),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'MindGuard',
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: emergencyMode 
                        ? Colors.white
                        : theme.colorScheme.primary,
                  ),
                  colors: emergencyMode 
                      ? [Colors.white, Colors.red.shade100, Colors.white]
                      : [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                          theme.colorScheme.tertiary,
                          theme.colorScheme.primary,
                        ],
                ),
              ],
              isRepeatingAnimation: true,
              totalRepeatCount: 3,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
         
          // Emergency button
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: emergencyMode ? 1.0 + (_pulseController.value * 0.1) : 1.0,
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: emergencyMode 
                        ? Colors.white.withOpacity(0.2)
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      emergencyMode ? Icons.emergency : Icons.emergency_outlined,
                      color: emergencyMode 
                          ? Colors.white
                          : Colors.red.shade600,
                    ),
                    onPressed: () {
                      ref.read(emergencyModeProvider.notifier).state = !emergencyMode;
                    },
                  ),
                ),
              );
            },
          ),
          // Settings button
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: emergencyMode 
                  ? Colors.white.withOpacity(0.2)
                  : theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: emergencyMode 
                    ? Colors.white
                    : theme.colorScheme.primary,
              ),
              onPressed: () {
                // Navigate to settings
              },
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: emergencyMode 
              ? LinearGradient(
                  colors: [Colors.red.shade100, Colors.red.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.background,
                    theme.colorScheme.primary.withOpacity(0.02),
                    theme.colorScheme.secondary.withOpacity(0.02),
                  ],
                ),
        ),
        child: Column(
          children: [
            // Emergency banner
            if (emergencyMode)
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Emergency Mode Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            
            Expanded(
              child: [
                // Home Page
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Hero Section with Gradient
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.8),
                              theme.colorScheme.secondary.withOpacity(0.6),
                              theme.colorScheme.tertiary.withOpacity(0.4),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Floating particles
                            ...List.generate(8, (index) {
                              return Positioned(
                                left: (index * 50.0) % 300,
                                top: (index * 30.0) % 150,
                                child: AnimatedBuilder(
                                  animation: _floatController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(
                                        0,
                                        sin(_floatController.value * 2 * pi + index) * 10,
                                      ),
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                            
                            // Main content
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 40),
                                  Row(
                                    children: [
                                      Hero(
                                        tag: 'main_icon',
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                          child: Icon(
                                            Icons.psychology,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Welcome to MindGuard',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              'Your mental wellness companion',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white.withOpacity(0.9),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Today\'s Focus: Self-Care & Healing',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white.withValues(alpha: .9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    value: 0.6,
                                    backgroundColor: Colors.white.withValues(alpha: .3),
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().slideY(begin: -1, duration: 800.ms).fade(),
                      
                      // Quick Stats Cards
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Sessions',
                                '12',
                                Icons.self_improvement,
                                Colors.blue,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Streak',
                                '7 days',
                                Icons.local_fire_department,
                                Colors.orange,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Progress',
                                '85%',
                                Icons.trending_up,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Assessment Button
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssessmentDemoPage(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF6366F1),
                                  Color(0xFF8B5CF6),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF6366F1).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.assessment,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Take PTSD Assessment',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Get personalized insights and recommendations',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                    
                      
                      // Emergency Section
                      if (emergencyMode) ...[
                        Container(
                          margin: EdgeInsets.all(16),
                          child: EmergencyButton(),
                        ),
                      ],
                      
                      // Main Features Section
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Therapeutic Tools',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Choose what feels right for you today',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                         
                            
                            // Main Template Widget
                            temp2()
                            
                          ],
                        ),
                      ),
                      
                      // Additional Widgets
                      SizedBox(height: 20),
                      WelcomeHeader(),
                      SizedBox(height: 20),
                      MoodCheckWidget(),
                      SizedBox(height: 20),
                      QuickAccessBar(),
                      SizedBox(height: 20),
                      // FeatureGrid(),
                      Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: templateWidget(),
                            ),
                      SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
                
                // // Journal Page
                JournalPage(),
                
                // // Profile Page
                ProfilePage(),
              ][currentPageIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildBottomNavigation() {
    final theme = Theme.of(context);
    final currentPageIndex = ref.watch(pageIndexProvider);
    final emergencyMode = ref.watch(emergencyModeProvider);
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ConvexAppBar(
        style: TabStyle.react,
        curve: Curves.easeInOutCubic,
        shadowColor: Colors.black.withOpacity(0.2),
        backgroundColor: emergencyMode 
            ? Colors.red.shade700
            : theme.colorScheme.primary,
        activeColor: Colors.white,
        color: Colors.white70,
        height: 65,
        elevation: 12,
        items: [
          TabItem(
            icon: FontAwesomeIcons.house,
            title: 'Home',
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                FontAwesomeIcons.house,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          TabItem(
            icon: FontAwesomeIcons.bookOpen,
            title: 'Journal',
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                FontAwesomeIcons.bookOpen,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          TabItem(
            icon: FontAwesomeIcons.user,
            title: 'Profile',
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                FontAwesomeIcons.user,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
        initialActiveIndex: currentPageIndex,
        onTap: (int index) {
          ref.read(pageIndexProvider.notifier).state = index;
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 1, duration: 600.ms).fade();
  }
}
