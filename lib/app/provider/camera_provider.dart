import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart' hide CameraException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import '../model/camera_model.dart';
import '../service/camera_service.dart';

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  CameraController? get controller => _controller;

  /// Check and request camera permission
  Future<bool> _checkCameraPermission() async {
    final permission = Permission.camera;
    final status = await permission.status;
    
    if (status == PermissionStatus.granted) {
      return true;
    }
    
    if (status == PermissionStatus.denied) {
      final result = await permission.request();
      return result == PermissionStatus.granted;
    }
    
    // Permission permanently denied
    return false;
  }

  /// Initialize camera
  Future<void> initializeCamera() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Check camera permission first
      final hasPermission = await _checkCameraPermission();
      if (!hasPermission) {
        throw CameraException(
          message: 'Camera permission is required to use this feature',
          statusCode: 0,
        );
      }

      // Get available cameras
      _cameras = await availableCameras();
      
      if (_cameras.isEmpty) {
        throw CameraException(
          message: 'No cameras available on this device',
          statusCode: 0,
        );
      }

      // Prefer front camera for selfies, fallback to any available camera
      CameraDescription selectedCamera;
      
      final frontCameras = _cameras.where(
        (camera) => camera.lensDirection == CameraLensDirection.front
      ).toList();
      
      if (frontCameras.isNotEmpty) {
        selectedCamera = frontCameras.first;
        log('Using front camera: ${selectedCamera.name}');
      } else {
        selectedCamera = _cameras.first;
        log('Front camera not available, using: ${selectedCamera.name}');
      }

      // Dispose existing controller if any
      await _controller?.dispose();

      // Initialize camera controller with optimized settings
      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium, // Medium resolution for better quality
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      
      log('Camera initialized successfully: ${selectedCamera.lensDirection}');

      // Get camera text from API
      final cameraText = await CameraService.fetchTodayStory();
      log('Camera text loaded: ${cameraText.text}');

      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        cameraText: cameraText,
      );
    } catch (e) {
      log('Camera initialization error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Camera error: ${e.toString()}',
      );
    }
  }

  /// Capture photo and upload to API for emotion detection
  Future<void> captureAndDetectEmotion() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      state = state.copyWith(error: 'Camera not initialized');
      return;
    }

    try {
      state = state.copyWith(isCapturing: true, error: null);

      // Take picture
      final XFile photo = await _controller!.takePicture();
      
      // Process image to reduce size
      final processedPhoto = await _processImage(File(photo.path));

      // Send to emotion detection API
      final emotionResponse = await CameraService.detectEmotion(
        photoFile: processedPhoto,
        sessionId: state.cameraText?.sessionId ?? 'session_${DateTime.now().millisecondsSinceEpoch}',
        metadata: {
          'timestamp': DateTime.now().toIso8601String(),
          'camera_type': 'front',
          'resolution': 'low',
        },
      );

      state = state.copyWith(
        isCapturing: false,
        lastEmotionDetection: emotionResponse,
      );

      // Clean up temporary file
      await processedPhoto.delete();

    } catch (e) {
      state = state.copyWith(
        isCapturing: false,
        error: e.toString(),
      );
    }
  }

  /// Process image to reduce resolution and file size
  Future<File> _processImage(File originalFile) async {
    try {
      // Read the image
      final bytes = await originalFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw CameraException(
          message: 'Failed to decode image',
          statusCode: 0,
        );
      }

      // Resize to very low resolution (e.g., 240x320)
      final resized = img.copyResize(
        image,
        width: 240,
        height: 320,
        interpolation: img.Interpolation.linear,
      );

      // Compress as JPEG with low quality
      final compressedBytes = img.encodeJpg(resized, quality: 30);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/compressed_photo_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      throw CameraException(
        message: 'Image processing failed: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Refresh camera text from API
  Future<void> refreshCameraText() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final cameraTextResponse = await CameraService.fetchTodayStory();

      state = state.copyWith(
        isLoading: false,
        cameraText: cameraTextResponse,
        
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Switch between front and back camera
  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    try {
      state = state.copyWith(isLoading: true, error: null);

      final currentLens = _controller?.description.lensDirection;
      final newCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection != currentLens,
        orElse: () => _cameras.first,
      );

      await _controller?.dispose();
      
      _controller = CameraController(
        newCamera,
        ResolutionPreset.low,
        enableAudio: false,
      );

      await _controller!.initialize();

      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Dispose camera controller
  @override
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    super.dispose();
  }

}

// Providers
final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});

final cameraControllerProvider = Provider<CameraController?>((ref) {
  final notifier = ref.watch(cameraProvider.notifier);
  return notifier.controller;
});

final cameraTextProvider = Provider<String?>((ref) {
  final cameraState = ref.watch(cameraProvider);
  return cameraState.cameraText?.text;
});

final cameraInstructionProvider = Provider<String?>((ref) {
  final cameraState = ref.watch(cameraProvider);
  return cameraState.cameraText?.instruction;
});

final emotionDetectionProvider = Provider<EmotionDetectionResponse?>((ref) {
  final cameraState = ref.watch(cameraProvider);
  return cameraState.lastEmotionDetection;
});

final dominantEmotionProvider = Provider<String?>((ref) {
  final emotionData = ref.watch(emotionDetectionProvider);
  return emotionData?.dominantEmotion;
});

final emotionConfidenceProvider = Provider<String?>((ref) {
  final emotionData = ref.watch(emotionDetectionProvider);
  return emotionData?.confidencePercentage;
});
