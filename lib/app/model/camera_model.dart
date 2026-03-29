class CameraTextResponse {
  final String text;
  final String? instruction;
  final String? sessionId;
  final Map<String, dynamic>? styling;

  CameraTextResponse({
    required this.text,
    this.instruction,
    this.sessionId,
    this.styling,
  });

  factory CameraTextResponse.fromJson(Map<String, dynamic> json) {
    return CameraTextResponse(
      text: json['story'] ?? json['text'] ?? 'Say cheese! 📸',
      instruction: json['instruction'],
      sessionId: json['session_id'],
      styling: json['styling'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'instruction': instruction,
      'session_id': sessionId,
      'styling': styling,
    };
  }
}

class PhotoUploadResponse {
  final bool success;
  final String? photoId;
  final String? message;
  final String? analysisResult;
  final Map<String, dynamic>? metadata;

  PhotoUploadResponse({
    required this.success,
    this.photoId,
    this.message,
    this.analysisResult,
    this.metadata,
  });

  factory PhotoUploadResponse.fromJson(Map<String, dynamic> json) {
    return PhotoUploadResponse(
      success: json['success'] ?? false,
      photoId: json['photo_id'],
      message: json['message'],
      analysisResult: json['analysis_result'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'photo_id': photoId,
      'message': message,
      'analysis_result': analysisResult,
      'metadata': metadata,
    };
  }
}

class EmotionDetectionResponse {
  final String dominantEmotion;
  final Map<String, double> scores;
  final bool success;
  final String? message;

  EmotionDetectionResponse({
    required this.dominantEmotion,
    required this.scores,
    this.success = true,
    this.message,
  });

  factory EmotionDetectionResponse.fromJson(Map<String, dynamic> json) {
    // Handle the emotion scores
    final scoresMap = <String, double>{};
    if (json['scores'] != null) {
      final scores = json['scores'] as Map<String, dynamic>;
      scores.forEach((key, value) {
        scoresMap[key] = (value as num).toDouble();
      });
    }

    return EmotionDetectionResponse(
      dominantEmotion: json['dominant_emotion'] ?? 'neutral',
      scores: scoresMap,
      success: json['success'] ?? true,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dominant_emotion': dominantEmotion,
      'scores': scores,
      'success': success,
      'message': message,
    };
  }

  /// Get confidence percentage for dominant emotion
  double get dominantEmotionConfidence {
    return scores[dominantEmotion] ?? 0.0;
  }

  /// Get confidence percentage as string
  String get confidencePercentage {
    return '${(dominantEmotionConfidence * 100).toStringAsFixed(1)}%';
  }

  /// Get emoji for dominant emotion
  String get dominantEmotionEmoji {
    switch (dominantEmotion.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'angry':
        return '😠';
      case 'fear':
        return '😨';
      case 'surprise':
        return '😲';
      case 'disgust':
        return '🤢';
      case 'neutral':
        return '😐';
      default:
        return '🙂';
    }
  }

  /// Get color for emotion
  String get emotionColorHex {
    switch (dominantEmotion.toLowerCase()) {
      case 'happy':
        return '#4CAF50'; // Green
      case 'sad':
        return '#2196F3'; // Blue
      case 'angry':
        return '#F44336'; // Red
      case 'fear':
        return '#9C27B0'; // Purple
      case 'surprise':
        return '#FF9800'; // Orange
      case 'disgust':
        return '#795548'; // Brown
      case 'neutral':
        return '#9E9E9E'; // Grey
      default:
        return '#607D8B'; // Blue Grey
    }
  }
}

class CameraException implements Exception {
  final String message;
  final int statusCode;
  final String? code;

  CameraException({
    required this.message,
    required this.statusCode,
    this.code,
  });

  @override
  String toString() {
    return 'CameraException: $message (Status: $statusCode)';
  }
}

class CameraState {
  final bool isInitialized;
  final bool isLoading;
  final bool isCapturing;
  final String? error;
  final CameraTextResponse? cameraText;
  final PhotoUploadResponse? lastUpload;
  final EmotionDetectionResponse? lastEmotionDetection;

  CameraState({
    this.isInitialized = false,
    this.isLoading = false,
    this.isCapturing = false,
    this.error,
    this.cameraText,
    this.lastUpload,
    this.lastEmotionDetection,
  });

  CameraState copyWith({
    bool? isInitialized,
    bool? isLoading,
    bool? isCapturing,
    String? error,
    CameraTextResponse? cameraText,
    PhotoUploadResponse? lastUpload,
    EmotionDetectionResponse? lastEmotionDetection,
  }) {
    return CameraState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      isCapturing: isCapturing ?? this.isCapturing,
      error: error ?? this.error,
      cameraText: cameraText ?? this.cameraText,
      lastUpload: lastUpload ?? this.lastUpload,
      lastEmotionDetection: lastEmotionDetection ?? this.lastEmotionDetection,
    );
  }
}
