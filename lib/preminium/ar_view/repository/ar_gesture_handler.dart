import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class ARGestureHandler extends StatefulWidget {
  final Widget child;
  final Function(double)? onScale;
  final Function(double)? onRotate;
  final Function(Offset)? onPan;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final bool enableHapticFeedback;

  const ARGestureHandler({
    super.key,
    required this.child,
    this.onScale,
    this.onRotate,
    this.onPan,
    this.onDoubleTap,
    this.onLongPress,
    this.enableHapticFeedback = true,
  });

  @override
  State<ARGestureHandler> createState() => _ARGestureHandlerState();
}

class _ARGestureHandlerState extends State<ARGestureHandler>
    with SingleTickerProviderStateMixin {
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  double _initialScale = 1.0;
  double _currentScale = 1.0;
  double _initialRotation = 0.0;
  double _currentRotation = 0.0;
  Offset _initialPanPosition = Offset.zero;
  
  bool _isScaling = false;
  bool _isRotating = false;
  bool _isPanning = false;

  @override
  void initState() {
    super.initState();
    _setupFeedbackAnimation();
  }

  void _setupFeedbackAnimation() {
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _feedbackAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _triggerHapticFeedback() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _triggerVisualFeedback() {
    _feedbackController.forward().then((_) {
      _feedbackController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _feedbackAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _feedbackAnimation.value,
          child: GestureDetector(
            // Single tap
            onTap: () {
              _triggerHapticFeedback();
              _triggerVisualFeedback();
            },

            // Double tap
            onDoubleTap: () {
              _triggerHapticFeedback();
              widget.onDoubleTap?.call();
            },

            // Long press
            onLongPress: () {
              HapticFeedback.mediumImpact();
              widget.onLongPress?.call();
            },

            // Scale gesture
            onScaleStart: (details) {
              _initialScale = _currentScale;
              _initialRotation = _currentRotation;
              _initialPanPosition = details.localFocalPoint;
              _isScaling = false;
              _isRotating = false;
              _isPanning = false;
            },

            onScaleUpdate: (details) {
              // Determine gesture type based on scale and pointer count
              if (details.pointerCount == 2) {
                // Two-finger gesture - could be scale or rotate
                final scaleDelta = (details.scale - 1.0).abs();
                final rotationDelta = details.rotation.abs();

                if (scaleDelta > 0.1 && !_isRotating) {
                  // Scaling gesture
                  if (!_isScaling) {
                    _isScaling = true;
                    _triggerHapticFeedback();
                  }
                  
                  final newScale = _initialScale * details.scale;
                  final clampedScale = newScale.clamp(0.1, 2.0);
                  
                  if ((clampedScale - _currentScale).abs() > 0.01) {
                    _currentScale = clampedScale;
                    widget.onScale?.call(_currentScale);
                  }
                } else if (rotationDelta > 0.1 && !_isScaling) {
                  // Rotation gesture
                  if (!_isRotating) {
                    _isRotating = true;
                    _triggerHapticFeedback();
                  }
                  
                  _currentRotation = _initialRotation + details.rotation;
                  widget.onRotate?.call(_currentRotation);
                }
              } else if (details.pointerCount == 1) {
                // Single finger - panning
                if (!_isPanning && !_isScaling && !_isRotating) {
                  _isPanning = true;
                }
                
                if (_isPanning) {
                  final panDelta = details.localFocalPoint - _initialPanPosition;
                  widget.onPan?.call(panDelta);
                }
              }
            },

            onScaleEnd: (details) {
              if (_isScaling || _isRotating || _isPanning) {
                _triggerHapticFeedback();
              }
              
              _isScaling = false;
              _isRotating = false;
              _isPanning = false;
            },

            child: widget.child,
          ),
        );
      },
    );
  }
}

// Advanced gesture recognizer for complex interactions
class ARAdvancedGestureDetector extends StatefulWidget {
  final Widget child;
  final Function(ARGestureEvent)? onGestureEvent;

  const ARAdvancedGestureDetector({
    super.key,
    required this.child,
    this.onGestureEvent,
  });

  @override
  State<ARAdvancedGestureDetector> createState() => _ARAdvancedGestureDetectorState();
}

class _ARAdvancedGestureDetectorState extends State<ARAdvancedGestureDetector> {
  final Map<int, Offset> _pointerPositions = {};
  late DateTime _lastTapTime;

  @override
  void initState() {
    super.initState();
    _lastTapTime = DateTime.now();
  }

  void _handlePointerDown(PointerDownEvent event) {
    _pointerPositions[event.pointer] = event.localPosition;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (_pointerPositions.containsKey(event.pointer)) {
      _pointerPositions[event.pointer] = event.localPosition;
      
      // Detect multi-finger gestures
      if (_pointerPositions.length >= 2) {
        _detectMultiFingerGesture();
      }
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    _pointerPositions.remove(event.pointer);
    
    // Check for tap gestures
    final now = DateTime.now();
    final timeSinceLastTap = now.difference(_lastTapTime);
    
    if (timeSinceLastTap.inMilliseconds < 300) {
      // Double tap detected
      widget.onGestureEvent?.call(ARGestureEvent(
        type: ARGestureType.doubleTap,
        position: event.localPosition,
      ));
    } else {
      // Single tap
      widget.onGestureEvent?.call(ARGestureEvent(
        type: ARGestureType.tap,
        position: event.localPosition,
      ));
    }
    
    _lastTapTime = now;
  }

  void _detectMultiFingerGesture() {
    if (_pointerPositions.length == 2) {
      final positions = _pointerPositions.values.toList();
      final distance = (positions[0] - positions[1]).distance;
      final angle = math.atan2(
        positions[1].dy - positions[0].dy,
        positions[1].dx - positions[0].dx,
      );

      widget.onGestureEvent?.call(ARGestureEvent(
        type: ARGestureType.twoFingerGesture,
        position: (positions[0] + positions[1]) / 2,
        scale: distance / 100, // Normalize distance
        rotation: angle,
      ));
    } else if (_pointerPositions.length == 3) {
      // Three finger gesture - could be used for special actions
      final center = _pointerPositions.values.fold<Offset>(
        Offset.zero,
        (prev, pos) => prev + pos,
      ) / _pointerPositions.length.toDouble();

      widget.onGestureEvent?.call(ARGestureEvent(
        type: ARGestureType.threeFingerGesture,
        position: center,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      child: widget.child,
    );
  }
}

// Gesture event data structure
class ARGestureEvent {
  final ARGestureType type;
  final Offset position;
  final double? scale;
  final double? rotation;
  final Offset? delta;

  ARGestureEvent({
    required this.type,
    required this.position,
    this.scale,
    this.rotation,
    this.delta,
  });
}

enum ARGestureType {
  tap,
  doubleTap,
  longPress,
  pan,
  scale,
  rotate,
  twoFingerGesture,
  threeFingerGesture,
}

// Predefined gesture patterns for common AR interactions
class ARGesturePatterns {
  static const Map<ARGestureType, String> descriptions = {
    ARGestureType.tap: 'Tap to place object',
    ARGestureType.doubleTap: 'Double tap to reset',
    ARGestureType.longPress: 'Long press for options',
    ARGestureType.pan: 'Drag to move',
    ARGestureType.scale: 'Pinch to resize',
    ARGestureType.rotate: 'Twist to rotate',
    ARGestureType.twoFingerGesture: 'Two fingers for precise control',
    ARGestureType.threeFingerGesture: 'Three fingers for special actions',
  };

  static String getGestureDescription(ARGestureType type) {
    return descriptions[type] ?? 'Unknown gesture';
  }

  static List<ARGestureType> getBasicGestures() {
    return [
      ARGestureType.tap,
      ARGestureType.doubleTap,
      ARGestureType.pan,
      ARGestureType.scale,
    ];
  }

  static List<ARGestureType> getAdvancedGestures() {
    return [
      ARGestureType.longPress,
      ARGestureType.rotate,
      ARGestureType.twoFingerGesture,
      ARGestureType.threeFingerGesture,
    ];
  }
}
