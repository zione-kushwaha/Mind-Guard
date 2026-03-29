import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

// Animation utilities for smooth AR interactions
class ARAnimationUtils {
  static AnimationController createBounceController(TickerProvider vsync) {
    return AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
  }

  static Animation<double> createBounceAnimation(AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );
  }

  static Animation<double> createPulseAnimation(AnimationController controller) {
    return Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  static Animation<Offset> createSlideAnimation(
    AnimationController controller,
    Offset begin,
    Offset end,
  ) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }
}

// Enhanced loading indicators for AR content
class ARLoadingIndicator extends StatefulWidget {
  final String message;
  final Color color;
  final double size;

  const ARLoadingIndicator({
    super.key,
    this.message = 'Loading AR content...',
    this.color = Colors.blue,
    this.size = 60,
  });

  @override
  State<ARLoadingIndicator> createState() => _ARLoadingIndicatorState();
}

class _ARLoadingIndicatorState extends State<ARLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
    _scale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotation.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          widget.color.withOpacity(0.8),
                          widget.color.withOpacity(0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.view_in_ar,
                      color: Colors.white,
                      size: widget.size * 0.4,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            widget.message,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Smart feedback system for user actions
class ARFeedbackManager {
  static void showSuccess(BuildContext context, String message) {
    _showFeedback(context, message, Colors.green, Icons.check_circle);
  }

  static void showError(BuildContext context, String message) {
    _showFeedback(context, message, Colors.red, Icons.error);
  }

  static void showInfo(BuildContext context, String message) {
    _showFeedback(context, message, Colors.blue, Icons.info);
  }

  static void showWarning(BuildContext context, String message) {
    _showFeedback(context, message, Colors.orange, Icons.warning);
  }

  static void _showFeedback(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => ARFeedbackWidget(
        message: message,
        color: color,
        icon: icon,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-remove after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      try {
        overlayEntry.remove();
      } catch (e) {
        // Overlay already removed
      }
    });
  }
}

class ARFeedbackWidget extends StatefulWidget {
  final String message;
  final Color color;
  final IconData icon;
  final VoidCallback onDismiss;

  const ARFeedbackWidget({
    super.key,
    required this.message,
    required this.color,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<ARFeedbackWidget> createState() => _ARFeedbackWidgetState();
}

class _ARFeedbackWidgetState extends State<ARFeedbackWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      right: 20,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onDismiss,
                        icon: const Icon(Icons.close, color: Colors.white),
                        iconSize: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Accessibility helpers for AR interfaces
class ARAccessibilityHelper {
  static void announceForScreenReader(String message) {
    debugPrint('Screen Reader: $message');
  }

  static Widget makeAccessible(Widget child, String label, {String? hint}) {
    return Semantics(
      label: label,
      hint: hint,
      child: child,
    );
  }

  static void provideHapticFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }
}

enum HapticFeedbackType { light, medium, heavy, selection }
