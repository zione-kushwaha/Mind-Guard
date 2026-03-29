import 'dart:convert';
import 'dart:developer';
import 'api_service.dart';

class StoryService {
  static Future<List<dynamic>> fetchStory({
    required String language,
    required String wordCount,
    required String genre,
  }) async {
    try {
      // Build query string for the GET request
      
      final response = await ApiService.get('/today-story');
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        
        // Handle different response structures
        if (responseBody is Map<String, dynamic>) {
          if (responseBody.containsKey('story') && responseBody['story'] is List) {
            return responseBody['story'];
          }
          // If the response is a map but doesn't have 'story' key, wrap it in a list
          return [responseBody];
        } else if (responseBody is List) {
          return responseBody;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch story: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching story: $e');
    }
  }
}
