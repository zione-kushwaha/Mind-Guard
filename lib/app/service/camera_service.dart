import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/camera_model.dart';
import '../service/api_service.dart';

class CameraService {
  static const String _getCameraTextEndpoint = '/api/today-story/';
  static const String _detectEmotionEndpoint = '/api/detect/';

  /// Get text to display on camera screen
  static Future<CameraTextResponse> getCameraText() async {
    try {
      final response = await ApiService.get(_getCameraTextEndpoint,);

      if (response.statusCode == 200) {
        final data = ApiService.parseResponse(response);

        return CameraTextResponse.fromJson(data);

      } else {
        throw CameraException(
          message: 'Failed to get camera text',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is CameraException) rethrow;
      throw CameraException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  static Future<CameraTextResponse> fetchTodayStory() async {
    const url = 'https://pleasing-guppy-hardy.ngrok-free.app/api/today-story/';
    const authToken = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNTA0NTY2LCJpYXQiOjE3NTIzMjQ1NjYsImp0aSI6IjBiMmQ0OTc3NDcwNTRiMDc5YWMyMGQ0ZGVjYmMyYjM2IiwidXNlcl9pZCI6MSwiaXNfc3RhZmYiOnRydWUsImlzX3N1cGVydXNlciI6dHJ1ZX0.sF7h6nN2qe7g14sRfc-dLV8AZpqpV1r10iaTSxNevHY';
    // const csrfToken = 'vUf5c0t7pQjq8DkeQYyk2YJFkXXTkDIHfavMiZNRzGHfps6fxF6SZ0OloIL8DUx5';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'Authorization': authToken,
          // 'X-CSRFTOKEN': csrfToken,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CameraTextResponse.fromJson(data);
      } else {
        throw CameraException(
          message: 'Error: ${response.statusCode} - ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw CameraException(
        message: 'Exception: $e',
        statusCode: 0,
      );
    }
  }

  /// Detect emotion from photo
  static Future<EmotionDetectionResponse> detectEmotion({
    required File photoFile,
    String? sessionId,
    Map<String, String>? metadata,
  }) async {
    try {
      // Prepare form fields
      final fields = <String, String>{
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      if (sessionId != null) {
        fields['session_id'] = sessionId;
      }
      
      if (metadata != null) {
        fields['metadata'] = jsonEncode(metadata);
      }

      // Prepare file
      final files = [
        await http.MultipartFile.fromPath(
          'image', // Use 'image' field name for emotion detection
          photoFile.path,
          filename: 'emotion_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ),
      ];

      // Make multipart request
      final response = await ApiService.multipartRequest(
        'POST',
        _detectEmotionEndpoint,
        fields: fields,
        files: files,
      );

      final responseBody = await response.stream.bytesToString();

      print('🎭 Emotion detection response status: ${response.statusCode}');
      print('🎭 Emotion detection response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseBody);
        return EmotionDetectionResponse.fromJson(data);
      } else {
        throw CameraException(
          message: 'Failed to detect emotion',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is CameraException) rethrow;
      throw CameraException(
        message: 'Emotion detection error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Test camera API connectivity
  static Future<bool> testCameraAPI() async {
    try {
      final response = await ApiService.get('/api/camera/status/');
      return response.statusCode == 200;
    } catch (e) {
      print('Camera API test failed: $e');
      return false;
    }
  }
}
