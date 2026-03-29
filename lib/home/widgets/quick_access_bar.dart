import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickAccessBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    final quickAccessItems = [
      {
        'icon': Icons.air,
        'label': 'Breathe',
        'color': theme.colorScheme.primary,
        'route': '/breathing',
      },
      {
        'icon': Icons.self_improvement,
        'label': 'Ground',
        'color': theme.colorScheme.secondary,
        'route': '/grounding',
      },
      {
        'icon': Icons.music_note,
        'label': 'Sounds',
        'color': theme.colorScheme.tertiary,
        'route': '/audio',
      },
      {
        'icon': Icons.edit_note,
        'label': 'Journal',
        'color': Colors.orange,
        'route': '/journal',
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flash_on,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Quick Access',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: quickAccessItems.map((item) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _navigateToFeature(context, item['route'] as String),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        decoration: BoxDecoration(
                          color: (item['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (item['color'] as Color).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: item['color'] as Color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              item['label'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: item['color'] as Color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _navigateToFeature(BuildContext context, String route) {
    // This would navigate to the specific feature
    // For now, show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $route'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
