import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '/home/data/image_data.dart';
import '/home/model/image_data.dart';
import '/features/breathing/breathing_exercise_page.dart';
import '/features/grounding/grounding_exercise_page.dart';
import '/features/sounds/calm_sounds_page.dart';
import '/features/yoga/yoga_movement_page.dart';
import '/features/games/mind_relaxation_game.dart';
import '/features/neural_beats/neural_beats_page.dart';
import '/features/journal/secure_journal_page.dart';
import '/features/meditation/meditation_page.dart';
import 'package:google_fonts/google_fonts.dart';

class templateWidget extends StatefulWidget {
  @override
  _templateWidgetState createState() => _templateWidgetState();
}

class _templateWidgetState extends State<templateWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _floatController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Create bouncing animation for welcome text
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _navigateToFeature(PTSDFeature feature) {
    Widget page;
    switch (feature.id) {
      case 'breathing_exercises':
        page = BreathingExercisePage();
        break;
      case 'grounding_exercises':
        page = GroundingExercisePage();
        break;
      case 'soothing_audio':
        page = CalmSoundsPage();
        break;
      case 'yoga_movement':
        page = YogaMovementPage();
        break;
      case 'neural_beats':
        page = NeuralBeatsPage();
        break;
      case 'journaling':
        page = SecureJournalPage();
        break;
      case 'mind_games':
        page = MindRelaxationGame();
        break;
      case 'emergency_support':
        _showEmergencyDialog();
        return;
      case 'trauma_games':
        page = MindRelaxationGame(); // For now, use same as mind games
        break;
      case 'meditation_stories':
        page = MeditationPage();
        break;
      case 'community':
        _showComingSoonDialog('Peer Support');
        return;
      case 'professional_help':
        _showComingSoonDialog('Therapist Directory');
        return;
      default:
        _showComingSoonDialog(feature.name);
        return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Emergency Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone, color: Colors.red),
              title: Text('National Suicide Prevention Lifeline'),
              subtitle: Text('988'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.red),
              title: Text('Crisis Text Line'),
              subtitle: Text('Text HOME to 741741'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.red),
              title: Text('PTSD Foundation'),
              subtitle: Text('877-717-PTSD'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Coming Soon'),
        content: Text('$featureName is coming soon! We\'re working hard to bring you this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Sort features by priority (emergency first, then alphabetically)
    final sortedFeatures = [...ptsdFeatures];
    sortedFeatures.sort((a, b) {
      if (a.isEmergency == true && b.isEmergency != true) return -1;
      if (b.isEmergency == true && a.isEmergency != true) return 1;
      return a.name.compareTo(b.name);
    });
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            theme.colorScheme.primary.withOpacity(0.02),
            theme.colorScheme.secondary.withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScaleTransition(
                  scale: Tween<double>(begin: 0.95, end: 1.0).animate(_animation),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'user_avatar',
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.person,
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
                              'Welcome back! 👋',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Your healing journey continues here',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Container(
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose what feels right for you:',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              'All tools are designed for your comfort and safety',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // PTSD Features Grid
          Expanded(
            child: AnimationLimiter(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: sortedFeatures.length,
                itemBuilder: (context, index) {
                  final feature = sortedFeatures[index];
                  
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            _navigateToFeature(feature);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: feature.isEmergency == true
                                      ? Colors.red.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                              border: feature.isEmergency == true
                                  ? Border.all(color: Colors.red, width: 2)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Feature Icon
                                AnimatedBuilder(
                                  animation: _floatController,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: Offset(0, _floatController.value * 5),
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              _getFeatureColor(feature).withOpacity(0.2),
                                              _getFeatureColor(feature).withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            feature.emoji,
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                SizedBox(height: 12),
                                
                                // Feature Name
                                Text(
                                  feature.name,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: feature.isEmergency == true
                                        ? Colors.red[700]
                                        : Colors.grey[800],
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                SizedBox(height: 8),
                                
                                // Feature Description
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    feature.description,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                SizedBox(height: 12),
                                
                                // Category Badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getFeatureColor(feature).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (feature.isEmergency == true)
                                        Icon(
                                          Icons.warning,
                                          size: 12,
                                          color: Colors.red,
                                        ),
                                      if (feature.isEmergency == true)
                                        SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          feature.category,
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: _getFeatureColor(feature),
                                          ),
                                        ),
                                      ),
                                    ],
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
      ),
    );
  }

  Color _getFeatureColor(PTSDFeature feature) {
    switch (feature.category) {
      case 'Emergency':
        return Colors.red;
      case 'Mindfulness':
        return Colors.blue;
      case 'Relaxation':
        return Colors.green;
      case 'Audio':
        return Colors.purple;
      case 'Movement':
        return Colors.orange;
      case 'Reflection':
        return Colors.teal;
      case 'Cognitive':
        return Colors.indigo;
      case 'Therapeutic':
        return Colors.pink;
      case 'Community':
        return Colors.cyan;
      case 'Professional':
        return Colors.brown;
      case 'Analytics':
        return Colors.deepPurple;
      case 'Planning':
        return Colors.amber;
      case 'Sleep':
        return Colors.deepOrange;
      case 'Training':
        return Colors.lightBlue;
      case 'Education':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }
}
