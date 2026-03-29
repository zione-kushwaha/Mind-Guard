import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'token_storage_service.dart';

/// Centralized API service that handles authentication for all HTTP requests
/// Automatically adds Bearer tokens to requests and handles token refresh
class ApiService {
  static const String baseUrl = 'http://pleasing-guppy-hardy.ngrok-free.app';

  /// Make authenticated GET request
  static Future<http.Response> get(String endpoint, {
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = await _getHeaders(additionalHeaders);
    final sharedInstance = await SharedPreferences.getInstance();
 
  
  const header2 = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNTAzMDA0LCJpYXQiOjE3NTIzMjMwMDQsImp0aSI6ImUxNWZiN2JjNzFlMzRhZGJhMzA4ZTg5NDgxMzkxNjczIiwidXNlcl9pZCI6MSwiaXNfc3RhZmYiOnRydWUsImlzX3N1cGVydXNlciI6dHJ1ZX0.y5eSwv_XxUs7JsztucYuJvW4aRh7etZXO7ifjAOpU8M";
  final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        "Authorization": header2,
        "Content-Type": "application/json",  // Recommended to add content type
        // "Accept": "application/json",       // Recommended to specify accept header
      },
    );
    
    print('📡 Response Status: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('❌ Response Body: ${response.body}');
    }
    
    return response;
  }

  /// Make authenticated POST request
  static Future<http.Response> post(String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = await _getHeaders(additionalHeaders);
    final url = Uri.parse('$baseUrl$endpoint');
    
    print('🌐 POST Request to: $url');
    print('🔑 Headers: ${headers.keys.join(', ')}');
    
    final response = await http.post(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    
    print('📡 Response Status: ${response.statusCode}');
    if (response.statusCode >= 400) {
      print('❌ Response Body: ${response.body}');
    }
    
    return response;
  }

  /// Make authenticated PUT request
  static Future<http.Response> put(String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = await _getHeaders(additionalHeaders);
    final url = Uri.parse('$baseUrl$endpoint');
    
    print('🌐 PUT Request to: $url');
    
    final response = await http.put(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    
    print('📡 Response Status: ${response.statusCode}');
    return response;
  }

  /// Make authenticated DELETE request
  static Future<http.Response> delete(String endpoint, {
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = await _getHeaders(additionalHeaders);
    final url = Uri.parse('$baseUrl$endpoint');
    
    print('🌐 DELETE Request to: $url');
    
    final response = await http.delete(url, headers: headers);
    
    print('📡 Response Status: ${response.statusCode}');
    return response;
  }

  /// Make authenticated multipart request (for file uploads)
  static Future<http.StreamedResponse> multipartRequest(
    String method,
    String endpoint, {
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
    Map<String, String>? additionalHeaders,
  }) async {
    final headers = await _getHeaders(additionalHeaders);
    final url = Uri.parse('$baseUrl$endpoint');
    
    print('🌐 $method Multipart Request to: $url');
    print('🔑 Headers: ${headers.keys.join(', ')}');
    
    final request = http.MultipartRequest(method, url);
    request.headers.addAll(headers);
    
    if (fields != null) {
      request.fields.addAll(fields);
    }
    
    if (files != null) {
      request.files.addAll(files);
    }
    
    final response = await request.send();
    
    print('📡 Response Status: ${response.statusCode}');
    return response;
  }

  /// Get headers with authentication token
  static Future<Map<String, String>> _getHeaders(
    Map<String, String>? additionalHeaders,
  ) async {
    final authHeaders = await TokenStorageService.getAuthHeaders();

    log(authHeaders.toString(), name: 'ApiService Headers');
    
    if (additionalHeaders != null) {
      authHeaders.addAll(additionalHeaders);
    }
    
    return authHeaders;
  }

  /// Handle API errors consistently
  static void handleApiError(http.Response response) {
    switch (response.statusCode) {
      case 401:
        throw ApiException('Unauthorized access. Please login again.', 401);
      case 403:
        throw ApiException('Access forbidden.', 403);
      case 404:
        throw ApiException('Resource not found.', 404);
      case 500:
        throw ApiException('Internal server error.', 500);
      default:
        if (response.statusCode >= 400) {
          throw ApiException(
            'Request failed with status ${response.statusCode}',
            response.statusCode,
          );
        }
    }
  }

  /// Parse JSON response safely
  static Map<String, dynamic> parseResponse(http.Response response) {
    handleApiError(response);
    
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ApiException('Failed to parse response: $e', response.statusCode);
    }
  }
}

/// Exception for API-related errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
