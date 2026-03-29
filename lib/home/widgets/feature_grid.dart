import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/providers/app_providers.dart';
import '/home/model/image_data.dart';
import '/games/games_page.dart';
import '/games/breathing_game.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class FeatureGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filteredFeatures = ref.watch(filteredFeaturesProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedFilter = ref.watch(featuresFilterProvider);

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
                Icons.apps,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Support Tools',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          // Category filter
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text('All'),
                      selected: selectedFilter == null,
                      onSelected: (selected) {
                        ref.read(featuresFilterProvider.notifier).state = null;
                      },
                      selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                      checkmarkColor: theme.colorScheme.primary,
                    ),
                  );
                }
                
                final category = categories[index - 1];
                return Container(
                  margin: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: selectedFilter == category,
                    onSelected: (selected) {
                      ref.read(featuresFilterProvider.notifier).state = selected ? category : null;
                    },
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: theme.colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 16),
          
          // Features grid
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: filteredFeatures.length,
              itemBuilder: (context, index) {
                final feature = filteredFeatures[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: FeatureCard(feature: feature),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends ConsumerWidget {
  final PTSDFeature feature;

  const FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ref.read(userPreferencesProvider.notifier).addLastUsedFeature(feature.id);
          _navigateToFeature(context, feature);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: feature.isEmergency 
                ? Colors.red.shade50
                : theme.colorScheme.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: feature.isEmergency 
                  ? Colors.red.shade200
                  : theme.colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: feature.isEmergency 
                          ? Colors.red.shade600
                          : theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        feature.emoji,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Spacer(),
                  if (feature.isEmergency)
                    Icon(
                      Icons.emergency,
                      color: Colors.red.shade600,
                      size: 16,
                    ),
                  if (feature.requiresAuth)
                    Icon(
                      Icons.lock_outline,
                      color: theme.colorScheme.outline,
                      size: 16,
                    ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                feature.name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                feature.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  feature.category,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFeature(BuildContext context, PTSDFeature feature) {
    switch (feature.id) {
      case 'mind_games':
      case 'trauma_games':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GamesPage(),
          ),
        );
        break;
      case 'breathing_exercises':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BreathingGamePage(),
          ),
        );
        break;
      case 'emergency_support':
        _showEmergencyDialog(context);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening ${feature.name}'),
            duration: Duration(seconds: 1),
          ),
        );
    }
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('🆘 Emergency Support'),
        content: Text('Emergency features will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
