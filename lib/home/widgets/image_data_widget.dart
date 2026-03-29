import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/image_data.dart';
import 'expanded_widget.dart';
import 'image_widget.dart';

class LocationWidget extends StatefulWidget {
  final imageData location;

  const LocationWidget({super.key, 
    required this.location,
  });

  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _rotationAnimation = Tween<double>(begin: 0, end: 0.02).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating bubbles background effect
          if (isExpanded) ..._buildBubbles(),
          
          // Expanded content background
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            bottom: isExpanded ? 20 : 100,
            width: isExpanded ? size.width * 0.5 : size.width * 0.4,
            height: isExpanded ? size.height * 0.3 : size.height * 0.28,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ExpandedContentWidget(
                location: widget.location,
                istapped: isExpanded,
              ),
            ),
          ),
          
          // Main card with image
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            bottom: isExpanded ? 125 : 75,
            child: GestureDetector(
              onPanUpdate: onPanUpdate,
              onTap: () {
                HapticFeedback.mediumImpact(); // Add haptic feedback
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isExpanded ? 1.0 : _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: isExpanded ? 0 : _rotationAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Hero(
                  tag: 'activity_${widget.location.name}',
                  child: ImageWidget(location: widget.location),
                ),
              ),
            ),
          ),
          
          // Hint arrow when not expanded
          if (!isExpanded)
            Positioned(
              bottom: 70,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 10),
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, -value),
                    child: child,
                  );
                },
                child: Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: theme.colorScheme.secondary,
                  size: 36,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Create decorative floating bubbles effect
  List<Widget> _buildBubbles() {
    final random = DateTime.now().millisecondsSinceEpoch;
    final colors = [
      Theme.of(context).colorScheme.primary.withOpacity(0.2),
      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
      Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
    ];
    
    return List.generate(
      5,
      (index) => Positioned(
        bottom: 50.0 + (index * 70),
        right: (index % 2 == 0) ? 30.0 + (random % 50) : null,
        left: (index % 2 == 1) ? 30.0 + (random % 50) : null,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(seconds: 2 + index),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: 0.7 * value,
              child: Transform.translate(
                offset: Offset(0, -20 * value),
                child: child,
              ),
            );
          },
          child: Container(
            width: 20.0 + (index * 10),
            height: 20.0 + (index * 10),
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (details.delta.dy < -3) {
      if (!isExpanded) {
        HapticFeedback.lightImpact(); 
        setState(() {
          isExpanded = true;
        });
      }
    } else if (details.delta.dy > 3) {
      if (isExpanded) {
        HapticFeedback.lightImpact();
        setState(() {
          isExpanded = false;
        });
      }
    }
  }
}
