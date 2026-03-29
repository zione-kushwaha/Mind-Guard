import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/image_data.dart';

class ImageWidget extends StatelessWidget {
  final imageData location;

  const ImageWidget({
    required this.location,
  });

  // Custom icons for each activity
  IconData _getActivityIcon() {
    switch(location.name) {
      case 'LEARN ALPHABETS':
        return Icons.abc;
      case 'PRACTICE SPEAKING':
        return Icons.record_voice_over;
      case 'SCAN TEXT':
        return Icons.document_scanner;
      case 'ORIENTATION TEST':
        return Icons.gamepad;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: size.height * 0.3,
      width: size.width * 0.6,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          child: Stack(
            children: [
              buildImage(context),
              // Colorful overlay gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.primary.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
              // Content inside card
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildTopText(theme),
                    // Activity description at bottom
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getActivityIcon(),
                              color: theme.colorScheme.primary,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _getActivityDescription(),
                                style: GoogleFonts.fredoka(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget buildImage(BuildContext context) => Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Image.asset(
            location.urlImage, 
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget buildTopText(ThemeData theme) => Container(
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getActivityIcon(),
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  _getSimplifiedName(),
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      
  // Convert activity names to more child-friendly versions
  String _getSimplifiedName() {
    switch(location.name) {
      case 'LEARN ALPHABETS':
        return 'ABC Fun!';
      case 'PRACTICE SPEAKING':
        return 'Let\'s Talk!';
      case 'SCAN TEXT':
        return 'Magic Reader';
      case 'ORIENTATION TEST':
        return 'Brain Games';
      default:
        return location.name;
    }
  }
  
  // Get child-friendly descriptions
  String _getActivityDescription() {
    switch(location.name) {
      case 'LEARN ALPHABETS':
        return 'Learn letters with fun sounds and pictures!';
      case 'PRACTICE SPEAKING':
        return 'Practice your words and make funny sounds!';
      case 'SCAN TEXT':
        return 'Point at words and watch them come alive!';
      case 'ORIENTATION TEST':
        return 'Play games that help your brain grow stronger!';
      default:
        return 'Tap to start a fun activity!';
    }
  }
}
