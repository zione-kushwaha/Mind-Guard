import 'package:usnepal/preminium/ar_view/view/ar_view.dart';
import 'package:usnepal/web/game_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';
import '../../app/view/word_reading_camera_screen.dart';
import '../model/image_data.dart';


class ExpandedContentWidget extends StatefulWidget {
  final imageData location;
  final bool istapped;

  const ExpandedContentWidget({required this.location, required this.istapped});

  @override
  State<ExpandedContentWidget> createState() => _ExpandedContentWidgetState();
}

class _ExpandedContentWidgetState extends State<ExpandedContentWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeInOut,
    );
    
    if (widget.istapped) {
      _controller.forward();
    }
  }
  
  @override
  void didUpdateWidget(ExpandedContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.istapped != oldWidget.istapped) {
      if (widget.istapped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Get activity-specific content
  List<Widget> _getActivityContent() {
    final theme = Theme.of(context);
    
    switch(widget.location.name) {


      case 'LEARN ALPHABETS':
        return [
        
          _buildFeatureItem(
            icon: Icons.abc, 
            title: 'Learn the Alphabet',
            description: 'Practice all 26 letters with fun sounds',
            color: Colors.blue,
          ),
          _buildFeatureItem(
            icon: Icons.volume_up, 
            title: 'Letter Sounds',
            description: 'Hear how each letter sounds',
            color: Colors.green,
          ),
          _buildFeatureItem(
            icon: Icons.draw, 
            title: 'Practice Writing',
            description: 'Trace letters with your finger',
            color: Colors.orange,
          ),
        ];
        
      case 'PRACTICE SPEAKING':
        return [
          _buildFeatureItem(
            icon: Icons.mic, 
            title: 'Speech Practice',
            description: 'Practice words with fun exercises',
            color: Colors.red,
          ),
          _buildFeatureItem(
            icon: Icons.record_voice_over, 
            title: 'Voice Games',
            description: 'Play fun games using your voice',
            color: Colors.purple,
          ),
          _buildFeatureItem(
            icon: Icons.graphic_eq, 
            title: 'Speech Patterns',
            description: 'See your progress with clear visuals',
            color: Colors.teal,
          ),
        ];
        
      case 'SCAN TEXT':
        return [
          _buildFeatureItem(
            icon: Icons.qr_code_scanner, 
            title: 'Magic Reader',
            description: 'Point your camera at text to read it',
            color: Colors.indigo,
          ),
          _buildFeatureItem(
            icon: Icons.translate, 
            title: 'Word Helper',
            description: 'Get help with difficult words',
            color: Colors.deepOrange,
          ),
          _buildFeatureItem(
            icon: Icons.menu_book, 
            title: 'Story Time',
            description: 'Turn any book into an adventure',
            color: Colors.lightBlue,
          ),
        ];
        
      case 'ORIENTATION TEST':
        return [
          _buildFeatureItem(
            icon: Icons.psychology, 
            title: 'Brain Games',
            description: 'Fun puzzles to exercise your brain',
            color: Colors.amber,
          ),
          _buildFeatureItem(
            icon: Icons.timer, 
            title: 'Quick Challenges',
            description: 'Test your speed with exciting games',
            color: Colors.deepPurple,
          ),
          _buildFeatureItem(
            icon: Icons.emoji_events, 
            title: 'Win Rewards',
            description: 'Earn stars and badges for your progress',
            color: Colors.brown,
          ),
        ];
        
      default:
        return [
          _buildFeatureItem(
            icon: Icons.star, 
            title: 'Fun Activity',
            description: 'Try this exciting activity!',
            color: theme.colorScheme.primary,
          ),
        ];
    }
  }

  Widget _buildFeatureItem({
    required IconData icon, 
    required String title, 
    required String description,
    required Color color,
  }) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'OpenDyslexicRegular',
                        fontSize: 12,
                        color: Colors.black54,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.7),
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.9),
          ], 
          end: Alignment.bottomCenter, 
          begin: Alignment.topCenter
        ),
        borderRadius: BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Activity title
          if (widget.istapped)
            FadeTransition(
              opacity: _animation,
              child: Text(
                _getActivityTitle(),
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            
          // Activity features
          if (widget.istapped)
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: _getActivityContent(),
                  ),
                ),
              ),
            ),
            
          // Start button
          if (widget.istapped)
            FadeTransition(
              opacity: _animation,
              child: InkWell(
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  if (widget.location.name == 'Do Yoga') {
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) => WebViewExample(),
                    // ));

                    url_launcher.launchUrl(
                      Uri.parse('https://pleasing-guppy-hardy.ngrok-free.app/api/yoga/'),
                      mode: LaunchMode.inAppBrowserView,
                    );

                    
                  //   Navigator.push(...)
                  } else if (widget.location.name == 'Augmented Reality') {
                      Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ARExperienceScreen(),
                    ));
                  //   Navigator.push(...)
                  } else if (widget.location.name == 'Today\'s Mood') {
                    await url_launcher.launchUrl(
                      Uri.parse('https://deer-hack-2025.vercel.app/'),
                      mode: LaunchMode.platformDefault,
                    );
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> WordReadingCameraScreen()));
                  //   Navigator.push(...)
                  } else if (widget.location.name == 'PRACTICE SPEAKING') {
                  //   Navigator.push(...)
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Container(),
                    ));
                  }else if(widget.location.name == "AR"){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => Container(),
                    ));
                  } 
                  else if(widget.location.name == "Dot Game"){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => game_dot(),
                    ));
                  }  
                  else {
                    
                    // Handle other activities or show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Activity not implemented yet!')),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'START NOW',
                        style: GoogleFonts.fredoka(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  String _getActivityTitle() {
    switch(widget.location.name) {
      case 'LEARN ALPHABETS':
        return '🎯 ABC Learning Adventure!';
      case 'PRACTICE SPEAKING':
        return '🎤 Speaking Fun Zone!';
      case 'SCAN TEXT':
        return '📷 Magic Reading Helper!';
      case 'ORIENTATION TEST':
        return '🎮 Brain Puzzle Challenge!';
      default:
        return widget.location.name;
    }
  }
}
