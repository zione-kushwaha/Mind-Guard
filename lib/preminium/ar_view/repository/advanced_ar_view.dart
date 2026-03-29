import 'package:ar_flutter_plugin_updated/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_hittest_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ar_flutter_plugin_updated/widgets/ar_view.dart';
import 'package:ar_flutter_plugin_updated/datatypes/node_types.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin_updated/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin_updated/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

class AdvancedARViewScreen extends StatefulWidget {
  final String modelUrl;
  final String word;
  final VoidCallback onBack;

  const AdvancedARViewScreen({
    super.key,
    required this.modelUrl,
    required this.word,
    required this.onBack,
  });

  @override
  State<AdvancedARViewScreen> createState() => _AdvancedARViewScreenState();
}

class _AdvancedARViewScreenState extends State<AdvancedARViewScreen>
    with TickerProviderStateMixin {
  // AR Managers
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  // Animation Controllers
  late AnimationController _controlsAnimationController;
  late AnimationController _feedbackAnimationController;
  late AnimationController _pulseAnimationController;

  // Animations
  late Animation<double> _controlsAnimation;
  late Animation<double> _feedbackAnimation;
  late Animation<double> _pulseAnimation;

  // TTS
  final FlutterTts tts = FlutterTts();

  // AR Objects
  List<ARNode> placedNodes = [];
  ARNode? selectedNode;
  int nodeCounter = 0;

  // State
  bool isLoading = false;
  bool showControls = false;
  bool showInstructions = true;
  String? errorMessage;
  String? feedbackMessage;
  int tapCount = 0; // Debug tap counter

  // Gesture State
  double currentScale = 0.15;
  double currentRotationY = 0.0;
  vector.Vector3 currentPosition = vector.Vector3.zero();
  bool isGestureActive = false;
  double _baseScale = 0.15;
  double _baseRotation = 0.0;

  // Movement State
  bool isMovementMode = false;
  double moveStep = 0.05; // 5cm movement steps

  // UI State
  bool _isControlsVisible = true;
  bool _isInfoPanelVisible = false;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupTTS();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      final cameraStatus = await Permission.camera.status;
      print('Camera permission status: $cameraStatus');
      
      if (cameraStatus.isDenied) {
        final result = await Permission.camera.request();
        print('Camera permission request result: $result');
        
        if (result.isGranted) {
          setState(() {
            _hasPermissions = true;
          });
          _showInitialInstructions();
        } else {
          setState(() {
            errorMessage = 'Camera permission is required for AR features';
          });
        }
      } else if (cameraStatus.isGranted) {
        setState(() {
          _hasPermissions = true;
        });
        _showInitialInstructions();
      } else {
        setState(() {
          errorMessage = 'Camera permission is required for AR features';
        });
      }
    } catch (e) {
      print('Permission check error: $e');
      setState(() {
        errorMessage = 'Failed to check camera permissions: $e';
      });
    }
  }

  void _setupAnimations() {
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _feedbackAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _controlsAnimation = CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.easeInOut,
    );

    _feedbackAnimation = CurvedAnimation(
      parent: _feedbackAnimationController,
      curve: Curves.elasticOut,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _pulseAnimationController.repeat(reverse: true);
  }

  Future<void> _setupTTS() async {
    await tts.setLanguage("en-US");
    await tts.setPitch(0.9);
    await tts.setSpeechRate(0.6);
  }

  void _showInitialInstructions() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _speak(
        "Tap on a flat surface to place your ${widget.word.split(' - ')[1]}. Use gestures to control it!",
      );
    });
  }

  Future<void> _speak(String text) async {
    await tts.speak(text);
  }

  @override
  void dispose() {
    _controlsAnimationController.dispose();
    _feedbackAnimationController.dispose();
    _pulseAnimationController.dispose();
    arSessionManager.dispose();
    tts.stop();
    super.dispose();
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    print('=== AR View Created ===');
    
    try {
      arSessionManager = sessionManager;
      arObjectManager = objectManager;

      print('Initializing AR session...');
      arSessionManager.onInitialize(
        showFeaturePoints: false,
        showPlanes: true,
        handleTaps: true, // Re-enable tap handling for object placement
        handlePans: false, // Keep pan handling disabled
        handleRotation: false, // Keep rotation handling disabled
        showAnimatedGuide: true,
      );

      print('Setting onPlaneOrPointTap callback...');
      arSessionManager.onPlaneOrPointTap = _onPlaneTapped;
      print('AR session initialization complete');
      
      // Clear any previous error messages
      setState(() {
        errorMessage = null;
      });
      
    } catch (e) {
      print('AR initialization error: $e');
      setState(() {
        errorMessage = 'Failed to initialize AR: $e';
      });
    }
  }

  Future<void> _onPlaneTapped(List<ARHitTestResult> hitTestResults) async {
    tapCount++; // Increment tap counter
    print('=== Plane Tapped (#$tapCount) ===');
    print('Hit test results count: ${hitTestResults.length}');
    print('Is loading: $isLoading');
    print('Model URL: ${widget.modelUrl}');
    
    // Update UI to show tap was detected
    setState(() {});
    
    if (hitTestResults.isEmpty || isLoading) {
      print('Exiting early - no hit results or loading');
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      showInstructions = false;
    });

    try {
      nodeCounter++;
      final hitResult = hitTestResults.first;
      final position = hitResult.worldTransform.getTranslation();
      
      print('Creating node at position: x=${position.x}, y=${position.y}, z=${position.z}');
      print('Node counter: $nodeCounter');
      print('Current scale: $currentScale');
      
      final newNode = ARNode(
        type: NodeType.webGLB,
        uri: widget.modelUrl,
        scale: vector.Vector3.all(currentScale),
        position: position,
        name: 'node_$nodeCounter',
      );

      print('Node created, attempting to add to AR manager...');
      
      // Track the position
      currentPosition = newNode.position;

      final success = await arObjectManager.addNode(newNode);
      
      print('Add node result: $success');

      setState(() {
        if (success == true) {
          placedNodes.add(newNode);
          selectedNode = newNode;
          showControls = true;
          _showSuccessFeedback();
          HapticFeedback.mediumImpact();
          print('Node successfully added! Total nodes: ${placedNodes.length}');
        } else {
          errorMessage = 'Failed to load the 3D model. Check model URL.';
          HapticFeedback.heavyImpact();
          print('Failed to add node to AR manager');
        }
        isLoading = false;
      });

      if (success == true) {
        _controlsAnimationController.forward();
        _speak(
          "Object placed! Use gestures to control it or tap to place more.",
        );
      }
    } catch (e) {
      print('Exception in _onPlaneTapped: $e');
      setState(() {
        errorMessage = 'Error loading model: ${e.toString()}';
        isLoading = false;
      });
      HapticFeedback.heavyImpact();
    }
  }

  void _showSuccessFeedback([String? customMessage]) {
    setState(() {
      feedbackMessage = customMessage ?? "Object placed successfully!";
    });
    _feedbackAnimationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _feedbackAnimationController.reverse();
          setState(() {
            feedbackMessage = null;
          });
        }
      });
    });
  }

  Future<void> _updateSelectedNode({double? scale, double? rotation}) async {
    if (selectedNode == null) return;

    try {
      // Store the current transform values
      bool needsUpdate = false;

      if (scale != null) {
        final clampedScale = scale.clamp(0.05, 3.0);
        if ((clampedScale - currentScale).abs() > 0.001) {
          currentScale = clampedScale;
          selectedNode!.scale = vector.Vector3.all(currentScale);
          needsUpdate = true;
          print('Scale updated to: $currentScale');
        }
      }

      if (rotation != null && (rotation - currentRotationY).abs() > 0.001) {
        currentRotationY = rotation;
        final rotationMatrix = vector.Matrix3.rotationY(currentRotationY);
        selectedNode!.rotation = rotationMatrix;
        needsUpdate = true;
        print('Rotation updated to: $currentRotationY');
      }

      // Only update if there's actually a change
      if (needsUpdate) {
        await arObjectManager.removeNode(selectedNode!);
        await arObjectManager.addNode(selectedNode!);

        // Update UI state
        setState(() {
          // Trigger UI rebuild to show updated values
        });
      }
    } catch (e) {
      print('Error updating object transform: $e');
      setState(() {
        errorMessage = 'Failed to update object';
      });
    }
  }

  Future<void> _duplicateSelectedNode() async {
    if (selectedNode == null) return;

    try {
      nodeCounter++;

      // Calculate smart positioning for the duplicated object
      final random = math.Random();
      final offsetX =
          (random.nextDouble() - 0.5) *
          0.3; // Random offset between -0.15 to 0.15
      final offsetZ =
          (random.nextDouble() - 0.5) *
          0.3; // Random offset between -0.15 to 0.15
      final offsetY = 0.02; // Slight elevation to avoid z-fighting

      final duplicatedNode = ARNode(
        type: NodeType.webGLB,
        uri: widget.modelUrl,
        scale: selectedNode!.scale,
        position:
            selectedNode!.position + vector.Vector3(offsetX, offsetY, offsetZ),
        name: 'node_$nodeCounter',
      );

      // Apply the same rotation as the original
      final rotationMatrix = vector.Matrix3.rotationY(currentRotationY);
      duplicatedNode.rotation = rotationMatrix;

      final success = await arObjectManager.addNode(duplicatedNode);

      if (success == true) {
        setState(() {
          placedNodes.add(duplicatedNode);
          selectedNode = duplicatedNode; // Select the new duplicate
        });

        // Show visual feedback
        _showSuccessFeedback("Object duplicated! Total: ${placedNodes.length}");
        _speak("Object duplicated! Total: ${placedNodes.length}");
        HapticFeedback.mediumImpact();

        // Animate the controls to show the update
        if (_isControlsVisible) {
          _controlsAnimationController.reverse().then((_) {
            _controlsAnimationController.forward();
          });
        }
      } else {
        _speak("Failed to duplicate object");
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      print('Error duplicating object: $e');
      _speak("Error duplicating object");
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _removeSelectedNode() async {
    if (selectedNode == null) return;

    await arObjectManager.removeNode(selectedNode!);
    setState(() {
      placedNodes.remove(selectedNode);
      selectedNode = placedNodes.isNotEmpty ? placedNodes.last : null;

      if (placedNodes.isEmpty) {
        showControls = false;
        showInstructions = true;
      }
    });

    _speak("Object removed!");
    HapticFeedback.mediumImpact();

    if (placedNodes.isEmpty) {
      _controlsAnimationController.reverse();
    }
  }

  Future<void> _clearAllNodes() async {
    for (var node in placedNodes) {
      await arObjectManager.removeNode(node);
    }

    setState(() {
      placedNodes.clear();
      selectedNode = null;
      showControls = false;
      showInstructions = true;
    });

    _controlsAnimationController.reverse();
    _speak("All objects cleared!");
    HapticFeedback.heavyImpact();
  }

  void _toggleControlsVisibility() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });

    if (_isControlsVisible) {
      _controlsAnimationController.forward();
    } else {
      _controlsAnimationController.reverse();
    }
  }

  void _toggleInfoPanel() {
    setState(() {
      _isInfoPanelVisible = !_isInfoPanelVisible;
    });
  }

  void _selectNextObject() {
    if (placedNodes.isEmpty) return;

    final currentIndex = selectedNode != null
        ? placedNodes.indexOf(selectedNode!)
        : -1;
    final nextIndex = (currentIndex + 1) % placedNodes.length;

    setState(() {
      selectedNode = placedNodes[nextIndex];
      // Update current tracking values
      currentScale = selectedNode!.scale.x;
      currentPosition = selectedNode!.position;
      // Extract rotation from transformation matrix if available
      currentRotationY = 0.0; // Reset rotation tracking
    });

    HapticFeedback.selectionClick();
    _speak("Selected object ${nextIndex + 1} of ${placedNodes.length}");
  }

  void _selectPreviousObject() {
    if (placedNodes.isEmpty) return;

    final currentIndex = selectedNode != null
        ? placedNodes.indexOf(selectedNode!)
        : -1;
    final previousIndex = currentIndex <= 0
        ? placedNodes.length - 1
        : currentIndex - 1;

    setState(() {
      selectedNode = placedNodes[previousIndex];
      // Update current tracking values
      currentScale = selectedNode!.scale.x;
      currentPosition = selectedNode!.position;
      // Extract rotation from transformation matrix if available
      currentRotationY = 0.0; // Reset rotation tracking
    });

    HapticFeedback.selectionClick();
    _speak("Selected object ${previousIndex + 1} of ${placedNodes.length}");
  }

  Future<void> _moveSelectedNode({vector.Vector3? deltaPosition}) async {
    if (selectedNode == null || deltaPosition == null) return;

    try {
      // Update the current position
      currentPosition = selectedNode!.position + deltaPosition;

      // Remove and re-add the node with new position
      await arObjectManager.removeNode(selectedNode!);
      selectedNode!.position = currentPosition;
      await arObjectManager.addNode(selectedNode!);

      HapticFeedback.lightImpact();
    } catch (e) {
      print('Error moving object: $e');
    }
  }

  void _moveObjectForward() {
    _moveSelectedNode(deltaPosition: vector.Vector3(0, 0, -moveStep));
  }

  void _moveObjectBackward() {
    _moveSelectedNode(deltaPosition: vector.Vector3(0, 0, moveStep));
  }

  void _moveObjectLeft() {
    _moveSelectedNode(deltaPosition: vector.Vector3(-moveStep, 0, 0));
  }

  void _moveObjectRight() {
    _moveSelectedNode(deltaPosition: vector.Vector3(moveStep, 0, 0));
  }

  void _moveObjectUp() {
    _moveSelectedNode(deltaPosition: vector.Vector3(0, moveStep, 0));
  }

  void _moveObjectDown() {
    _moveSelectedNode(deltaPosition: vector.Vector3(0, -moveStep, 0));
  }

  void _toggleMovementMode() {
    setState(() {
      isMovementMode = !isMovementMode;
    });

    HapticFeedback.mediumImpact();
    _speak(
      isMovementMode ? "Movement mode activated" : "Movement mode deactivated",
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show permission request screen if no permissions
    if (!_hasPermissions) {
      return Scaffold(
        body: Container(
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Camera Permission Required',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    errorMessage ?? 'AR features require camera access to work properly.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: widget.onBack,
                        icon: Icon(Icons.arrow_back),
                        label: Text('Go Back'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _checkPermissions,
                        icon: Icon(Icons.refresh),
                        label: Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Enhanced AR View with Gesture Detection
          _buildGestureDetector(),

          // Top App Bar
          _buildTopAppBar(),

          // Loading Indicator
          if (isLoading) _buildLoadingIndicator(),

          // Error Display
          if (errorMessage != null) _buildErrorDisplay(),

          // Instructions
          if (showInstructions && !isLoading) _buildInstructions(),

          // Success Feedback
          if (feedbackMessage != null) _buildSuccessFeedback(),

          // Enhanced Controls Panel
          if (showControls) _buildEnhancedControlsPanel(),

          // Info Panel
          if (_isInfoPanelVisible) _buildInfoPanel(),

          // Quick Action Buttons
          _buildQuickActionButtons(),
        ],
      ),
    );
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
      onTap: () {
        print('Single tap detected');
        // Single tap cycles through objects if multiple exist
        if (placedNodes.length > 1) {
          _selectNextObject();
        } else if (placedNodes.isNotEmpty) {
          // Select the only object if it's not selected
          setState(() {
            selectedNode = placedNodes.first;
          });
          print('Selected object: ${selectedNode?.name}');
        }
      },

      onScaleStart: (details) {
        print('Scale gesture started - fingers: ${details.pointerCount}');
        
        // Allow gesture even if no object is selected yet, but need at least one object
        if (placedNodes.isEmpty) {
          print('No objects to scale');
          return;
        }
        
        // Auto-select first object if none selected
        if (selectedNode == null && placedNodes.isNotEmpty) {
          selectedNode = placedNodes.first;
          setState(() {});
          print('Auto-selected first object for scaling');
        }

        isGestureActive = true;
        _baseScale = currentScale;
        _baseRotation = currentRotationY;
        
        print('Gesture started - Base scale: $_baseScale, fingers: ${details.pointerCount}');
        HapticFeedback.lightImpact();
        
        // Update UI to show gesture is active
        setState(() {});
      },

      onScaleUpdate: (details) {
        if (selectedNode == null || !isGestureActive || placedNodes.isEmpty) return;

        // Handle scaling (pinch gesture) with better sensitivity
        if (details.pointerCount >= 2) {
          // Calculate scale factor relative to initial scale
          final scaleFactor = details.scale;
          final newScale = (_baseScale * scaleFactor).clamp(0.05, 3.0);

          // Debug output
          print('Pinch update - Scale: ${details.scale}, Factor: $scaleFactor, Base: $_baseScale, New: $newScale');

          // Update scale with better threshold for smoother scaling
          if ((newScale - currentScale).abs() > 0.005) {
            currentScale = newScale;
            _updateSelectedNode(scale: currentScale);
            
            // Provide haptic feedback for scaling (but not too frequent)
            if ((newScale - _baseScale).abs() > 0.02) {
              HapticFeedback.selectionClick();
            }
            print('Scale applied: $currentScale');
          }

          // Handle rotation (two-finger twist) - only with 2 fingers
          if (details.rotation != 0.0 && details.rotation.abs() > 0.02) {
            final newRotation = _baseRotation + details.rotation;

            print('Twist detected - Rotation: ${details.rotation}, New: $newRotation');

            if ((newRotation - currentRotationY).abs() > 0.02) {
              currentRotationY = newRotation;
              _updateSelectedNode(rotation: currentRotationY);
              
              // Provide haptic feedback for rotation
              HapticFeedback.selectionClick();
            }
          }
        }
      },

      onScaleEnd: (details) {
        if (!isGestureActive) return;
        
        isGestureActive = false;
        print('Gesture ended - Final scale: $currentScale');
        HapticFeedback.lightImpact();

        // Update UI to show gesture is no longer active
        setState(() {});

        // Snap to nearest 15-degree angle for rotation
        final snapAngle =
            (currentRotationY / (math.pi / 12)).round() * (math.pi / 12);
        if ((snapAngle - currentRotationY).abs() < 0.2) {
          currentRotationY = snapAngle;
          _updateSelectedNode(rotation: currentRotationY);
          print('Rotation snapped to: $currentRotationY');
        }
      },

      onDoubleTap: () {
        if (selectedNode != null) {
          print('Double tap - resetting object');
          // Reset to default scale, rotation, and explain what reset means
          currentScale = 0.15;
          currentRotationY = 0.0;
          // Note: Position is NOT reset - object stays where it is
          _updateSelectedNode(scale: currentScale, rotation: currentRotationY);
          _speak(
            "Object reset! Size back to normal, rotation to zero. Position unchanged.",
          );
          HapticFeedback.mediumImpact();
        }
      },

      onLongPress: () {
        if (selectedNode != null) {
          print('Long press - duplicating object');
          HapticFeedback.heavyImpact();
          _duplicateSelectedNode();
        }
      },

      child: ARView(
        onARViewCreated: onARViewCreated,
        planeDetectionConfig: PlaneDetectionConfig.horizontal,
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: widget.onBack,
                ),
                Expanded(
                  child: Text(
                    widget.word,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Gesture indicator
                if (isGestureActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PINCH',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Text(
                  '${placedNodes.length}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (tapCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'T:$tapCount',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _isInfoPanelVisible ? Icons.info : Icons.info_outline,
                    color: Colors.white,
                  ),
                  onPressed: _toggleInfoPanel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.blue.withOpacity(0.8),
                          Colors.blue.withOpacity(0.2),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.view_in_ar,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Loading ${widget.word.split(' - ')[1]}...',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorDisplay() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Model URL: ${widget.modelUrl}',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  errorMessage = null;
                  showInstructions = true;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: const Icon(
                    Icons.touch_app,
                    size: 48,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Ready to place your ${widget.word.split(' - ')[1]}?',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap surfaces to place • Pinch to resize after placing',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildGestureHints(),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureHints() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Gesture Controls:',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildGestureHint(Icons.touch_app, 'Tap to place and select objects'),
          _buildGestureHint(Icons.zoom_out_map, '🤏 Pinch to scale objects'),
          _buildGestureHint(Icons.rotate_right, '🌀 Twist to rotate objects'),
          _buildGestureHint(Icons.open_with, 'Use move controls for positioning'),
          _buildGestureHint(Icons.refresh, 'Double-tap to reset size & rotation'),
          _buildGestureHint(Icons.content_copy, 'Long press to duplicate'),
        ],
      ),
    );
  }

  Widget _buildGestureHint(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessFeedback() {
    return AnimatedBuilder(
      animation: _feedbackAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _feedbackAnimation.value,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    feedbackMessage!,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedControlsPanel() {
    return AnimatedBuilder(
      animation: _controlsAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 20 + (100 * (1 - _controlsAnimation.value)),
          left: 20,
          right: 20,
          child: Opacity(
            opacity: _controlsAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Object Controls',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${placedNodes.length} objects',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          IconButton(
                            onPressed: _toggleControlsVisibility,
                            icon: Icon(
                              _isControlsVisible
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (_isControlsVisible) ...[
                    const SizedBox(height: 16),

                    // Scale Controls
                    _buildControlRow(
                      'Size',
                      '${(currentScale * 100).round()}%',
                      [
                        _buildControlButton(
                          Icons.remove,
                          () => _updateSelectedNode(scale: currentScale - 0.05),
                        ),
                        _buildControlButton(
                          Icons.add,
                          () => _updateSelectedNode(scale: currentScale + 0.05),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Rotation Controls
                    _buildControlRow(
                      'Rotation',
                      '${(currentRotationY * 180 / math.pi).round()}°',
                      [
                        _buildControlButton(
                          Icons.rotate_left,
                          () => _updateSelectedNode(
                            rotation: currentRotationY - 0.5,
                          ),
                        ),
                        _buildControlButton(
                          Icons.rotate_right,
                          () => _updateSelectedNode(
                            rotation: currentRotationY + 0.5,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Movement Controls
                    _buildMovementControlsSection(),

                    const SizedBox(height: 12),

                    // Object Selection Controls (if multiple objects)
                    if (placedNodes.length > 1) ...[
                      _buildControlRow(
                        'Selection',
                        '${placedNodes.indexOf(selectedNode!) + 1}/${placedNodes.length}',
                        [
                          _buildControlButton(
                            Icons.skip_previous,
                            _selectPreviousObject,
                          ),
                          _buildControlButton(
                            Icons.skip_next,
                            _selectNextObject,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    const SizedBox(height: 16),

                    // Movement Controls
                    _buildControlRow('Movement', '', [
                      _buildControlButton(
                        Icons.arrow_forward,
                        _moveObjectForward,
                      ),
                      _buildControlButton(
                        Icons.arrow_back,
                        _moveObjectBackward,
                      ),
                      _buildControlButton(Icons.arrow_left, _moveObjectLeft),
                      _buildControlButton(Icons.arrow_right, _moveObjectRight),
                      _buildControlButton(Icons.arrow_upward, _moveObjectUp),
                      _buildControlButton(
                        Icons.arrow_downward,
                        _moveObjectDown,
                      ),
                    ]),

                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            'Duplicate',
                            Icons.content_copy,
                            Colors.blue,
                            _duplicateSelectedNode,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionButton(
                            'Remove',
                            Icons.delete,
                            Colors.red,
                            _removeSelectedNode,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionButton(
                            'Clear All',
                            Icons.clear_all,
                            Colors.orange,
                            _clearAllNodes,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlRow(String label, String value, List<Widget> controls) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        ...controls,
      ],
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: color.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Positioned(
      top: 100,
      right: 20,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'AR Info',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _toggleInfoPanel,
                  icon: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoItem('Object', widget.word.split(' - ')[1]),
            _buildInfoItem('Total', '${placedNodes.length}'),
            _buildInfoItem('Scale', '${(currentScale * 100).round()}%'),
            _buildInfoItem(
              'Rotation',
              '${(currentRotationY * 180 / math.pi).round()}°',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButtons() {
    return Positioned(
      top: 120,
      left: 20,
      child: Column(
        children: [
          _buildQuickActionButton(
            Icons.volume_up,
            'Voice',
            Colors.purple,
            () => _speak(
              "You have ${placedNodes.length} ${widget.word.split(' - ')[1]} objects",
            ),
          ),
          const SizedBox(height: 8),
          if (placedNodes.isNotEmpty)
            _buildQuickActionButton(
              isMovementMode ? Icons.pan_tool : Icons.open_with,
              'Move',
              isMovementMode ? Colors.orange : Colors.indigo,
              _toggleMovementMode,
            ),
          const SizedBox(height: 8),
          if (placedNodes.isNotEmpty)
            _buildQuickActionButton(
              Icons.content_copy,
              'Copy',
              Colors.blue,
              _duplicateSelectedNode,
            ),
          const SizedBox(height: 8),
          if (placedNodes.isNotEmpty)
            _buildQuickActionButton(Icons.refresh, 'Reset', Colors.green, () {
              currentScale = 0.15;
              currentRotationY = 0.0;
              _updateSelectedNode(
                scale: currentScale,
                rotation: currentRotationY,
              );
              _speak("Size and rotation reset! Position stays the same.");
            }),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: color.withOpacity(0.9),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovementControlsSection() {
    return Column(
      children: [
        // Movement mode toggle
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Position',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    isMovementMode ? 'Move Mode ON' : 'Move Mode OFF',
                    style: GoogleFonts.poppins(
                      color: isMovementMode
                          ? Colors.green
                          : Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _buildControlButton(
              isMovementMode ? Icons.pan_tool : Icons.open_with,
              _toggleMovementMode,
            ),
          ],
        ),

        if (isMovementMode) ...[
          const SizedBox(height: 12),

          // Directional movement controls
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                // Forward/Backward
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMovementButton(
                      Icons.keyboard_arrow_up,
                      'Forward',
                      _moveObjectForward,
                    ),
                    _buildMovementButton(
                      Icons.keyboard_arrow_down,
                      'Back',
                      _moveObjectBackward,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Left/Right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMovementButton(
                      Icons.keyboard_arrow_left,
                      'Left',
                      _moveObjectLeft,
                    ),
                    _buildMovementButton(
                      Icons.keyboard_arrow_right,
                      'Right',
                      _moveObjectRight,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Up/Down
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMovementButton(
                      Icons.expand_less,
                      'Up',
                      _moveObjectUp,
                    ),
                    _buildMovementButton(
                      Icons.expand_more,
                      'Down',
                      _moveObjectDown,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMovementButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.blue.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
}
