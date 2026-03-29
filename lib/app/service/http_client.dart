import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

/// Generic HTTP client with authentication support
/// Use this class for making any HTTP requests in the app
class HttpClient {
  /// Make GET request with automatic authentication
  static Future<T> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await ApiService.get(endpoint, additionalHeaders: headers);
    
    if (response.statusCode == 200) {
      final data = ApiService.parseResponse(response);
      return fromJson != null ? fromJson(data) : data as T;
    } else {
      ApiService.handleApiError(response);
      throw Exception('Request failed');
    }
  }

  /// Make POST request with automatic authentication
  static Future<T> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await ApiService.post(
      endpoint,
      body: body,
      additionalHeaders: headers,
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = ApiService.parseResponse(response);
      return fromJson != null ? fromJson(data) : data as T;
    } else {
      ApiService.handleApiError(response);
      throw Exception('Request failed');
    }
  }

  /// Make PUT request with automatic authentication
  static Future<T> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await ApiService.put(
      endpoint,
      body: body,
      additionalHeaders: headers,
    );
    
    if (response.statusCode == 200) {
      final data = ApiService.parseResponse(response);
      return fromJson != null ? fromJson(data) : data as T;
    } else {
      ApiService.handleApiError(response);
      throw Exception('Request failed');
    }
  }

  /// Make DELETE request with automatic authentication
  static Future<void> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final response = await ApiService.delete(endpoint, additionalHeaders: headers);
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      ApiService.handleApiError(response);
    }
  }

  /// Upload file with automatic authentication
  static Future<T> uploadFile<T>(
    String endpoint, {
    required String fieldName,
    required String filePath,
    Map<String, String>? fields,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final files = [
      await http.MultipartFile.fromPath(fieldName, filePath),
    ];

    final response = await ApiService.multipartRequest(
      'POST',
      endpoint,
      fields: fields,
      files: files,
      additionalHeaders: headers,
    );

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      return fromJson != null ? fromJson(data) : data as T;
    } else {
      throw ApiException(
        'Upload failed with status ${response.statusCode}',
        response.statusCode,
      );
    }
  }
}

/// Example usage class showing how to use HttpClient for any API
class ExampleApiUsage {
  /// Example: Get user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    return await HttpClient.get<Map<String, dynamic>>('/api/user/profile/');
  }

  /// Example: Update user profile
  static Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> userData) async {
    return await HttpClient.put<Map<String, dynamic>>(
      '/api/user/profile/',
      body: userData,
    );
  }

  /// Example: Upload profile picture
  static Future<Map<String, dynamic>> uploadProfilePicture(String filePath) async {
    return await HttpClient.uploadFile<Map<String, dynamic>>(
      '/api/user/avatar/',
      fieldName: 'avatar',
      filePath: filePath,
    );
  }

  /// Example: Get posts with custom model parsing
  static Future<List<Post>> getPosts() async {
    final response = await HttpClient.get<Map<String, dynamic>>('/api/posts/');
    final List<dynamic> posts = response['results'] ?? [];
    return posts.map((post) => Post.fromJson(post)).toList();
  }
}

/// Example model class
class Post {
  final String id;
  final String title;
  final String content;

  Post({required this.id, required this.title, required this.content});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
