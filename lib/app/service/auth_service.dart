import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/auth_model.dart';
import 'token_storage_service.dart';

class AuthService {
  static const String _baseUrl = 'http://pleasing-guppy-hardy.ngrok-free.app';
  static const String _loginEndpoint = '/api/login/';
  static const String _registerEndpoint = '/auth/registration/';
  static const String _refreshEndpoint = '/auth/token/refresh/';
  static const String _logoutEndpoint = '/auth/logout/';

  // Login with username and password
  static Future<Map<String, dynamic>> login(LoginRequest request) async {
    print('🌐 AuthService.login - Starting API call');
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_loginEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true', // Skip ngrok browser warning
        },
        body: jsonEncode(request.toJson()),
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');
      
      // Handle redirects or empty responses
      if (response.statusCode == 307 || response.statusCode == 301 || response.statusCode == 302) {
        final location = response.headers['location'];
        if (location != null) {
          print('🔄 Following redirect to: $location');
          // Try the redirect URL
          final redirectResponse = await http.post(
            Uri.parse(location),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode(request.toJson()),
          );
          print('� Redirect response status: ${redirectResponse.statusCode}');
          print('� Redirect response body: ${redirectResponse.body}');
          
          if (redirectResponse.statusCode == 200 && redirectResponse.body.isNotEmpty) {
            final data = jsonDecode(redirectResponse.body);
            return await _processLoginResponse(data);
          }
        }
        
        throw AuthException(
          message: 'Server redirect error. Please check your connection.',
          code: 'redirect_error',
          statusCode: response.statusCode,
        );
      }
      
      // Check for empty response body
      if (response.body.isEmpty) {
        throw AuthException(
          message: 'Empty response from server',
          code: 'empty_response',
          statusCode: response.statusCode,
        );
      }
      
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return await _processLoginResponse(data);
      } else {
        throw AuthException(
          message: data['detail'] ?? data['message'] ?? 'Login failed',
          code: data['code'] ?? 'login_error',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Network error: ${e.toString()}',
        code: 'network_error',
      );
    }
  }

  // Helper method to process login response
  static Future<Map<String, dynamic>> _processLoginResponse(Map<String, dynamic> data) async {
    print('✅ Login API successful');
    final tokens = AuthTokens.fromJson(data);
    final user = User.fromJson(data['user']);
    
    print('👤 Parsed user: ${user.username}');
    print('🔑 Parsed tokens: ${tokens.accessToken.substring(0, 10)}...');
    
    await _storeTokens(tokens);
    await _storeUser(user);
    
    print('💾 Tokens and user stored');
    
    return {
      'success': true,
      'user': user,
      'tokens': tokens,
    };
  }

  // Register new user
  static Future<Map<String, dynamic>> register(RegisterRequest request) async {
    print('🌐 AuthService.register - Starting API call');
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_registerEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true', // Skip ngrok browser warning
        },
        body: jsonEncode(request.toJson()),
      );

      print('📡 Register response status: ${response.statusCode}');
      print('📡 Register response body: ${response.body}');
      
      // Handle redirects or empty responses
      if (response.statusCode == 307 || response.statusCode == 301 || response.statusCode == 302) {
        final location = response.headers['location'];
        if (location != null) {
          print('🔄 Following redirect to: $location');
          // Try the redirect URL
          final redirectResponse = await http.post(
            Uri.parse(location),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'ngrok-skip-browser-warning': 'true',
            },
            body: jsonEncode(request.toJson()),
          );
          print('📡 Redirect response status: ${redirectResponse.statusCode}');
          print('📡 Redirect response body: ${redirectResponse.body}');
          
          if ((redirectResponse.statusCode == 200 || redirectResponse.statusCode == 201) && redirectResponse.body.isNotEmpty) {
            final data = jsonDecode(redirectResponse.body);
            return await _processLoginResponse(data);
          }
        }
        
        throw AuthException(
          message: 'Server redirect error. Please check your connection.',
          code: 'redirect_error',
          statusCode: response.statusCode,
        );
      }
      
      // Check for empty response body
      if (response.body.isEmpty) {
        throw AuthException(
          message: 'Empty response from server',
          code: 'empty_response',
          statusCode: response.statusCode,
        );
      }
      
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return await _processLoginResponse(data);
      } else {
        throw AuthException(
          message: data['detail'] ?? data['message'] ?? 'Registration failed',
          code: data['code'] ?? 'registration_error',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Network error: ${e.toString()}',
        code: 'network_error',
      );
    }
  }

  // Refresh token
  static Future<AuthTokens> refreshToken() async {
    try {
      final currentTokens = await getStoredTokens();
      if (currentTokens == null) {
        throw AuthException(
          message: 'No refresh token available',
          code: 'no_refresh_token',
        );
      }

      final response = await http.post(
        Uri.parse('$_baseUrl$_refreshEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refresh': currentTokens.refreshToken,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final newTokens = AuthTokens.fromJson(data);
        await _storeTokens(newTokens);
        return newTokens;
      } else {
        throw AuthException(
          message: data['message'] ?? 'Token refresh failed',
          code: data['code'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(
        message: 'Token refresh error: ${e.toString()}',
        code: 'token_refresh_error',
      );
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      final tokens = await getStoredTokens();
      
      if (tokens != null) {
        // Try to logout from server
        try {
          await http.post(
            Uri.parse('$_baseUrl$_logoutEndpoint'),
            headers: {
              'Authorization': 'Bearer ${tokens.accessToken}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'refresh': tokens.refreshToken,
            }),
          );
        } catch (e) {
          // Continue even if server logout fails
          print('Server logout failed: $e');
        }
      }
      
      // Clear stored data
      await clearStoredData();
    } catch (e) {
      // Even if logout fails, clear local data
      await clearStoredData();
    }
  }

  // Store tokens securely using SharedPreferences
  static Future<void> _storeTokens(AuthTokens tokens) async {
    await TokenStorageService.storeTokens(tokens);
  }

  // Store user data securely using SharedPreferences
  static Future<void> _storeUser(User user) async {
    await TokenStorageService.storeUser(user);
  }

  // Get stored tokens
  static Future<AuthTokens?> getStoredTokens() async {
    return await TokenStorageService.getTokens();
  }

  // Get stored user
  static Future<User?> getStoredUser() async {
    return await TokenStorageService.getUser();
  }

  // Clear all stored data
  static Future<void> clearStoredData() async {
    await TokenStorageService.clearAllData();
  }

  // Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    return await TokenStorageService.isAuthenticated();
  }

  // Make authenticated HTTP request
  static Future<http.Response> authenticatedRequest(
    String url, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    AuthTokens? tokens = await getStoredTokens();
    
    if (tokens == null) {
      throw AuthException(
        message: 'No access token available',
        code: 'no_access_token',
      );
    }

    // Refresh token if expiring soon
    if (tokens.isExpiringSoon) {
      tokens = await refreshToken();
    }

    final requestHeaders = {
      'Authorization': 'Bearer ${tokens.accessToken}',
      'Content-Type': 'application/json',
      ...?headers,
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(Uri.parse(url), headers: requestHeaders);
      case 'POST':
        return await http.post(
          Uri.parse(url),
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          Uri.parse(url),
          headers: requestHeaders,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(Uri.parse(url), headers: requestHeaders);
      default:
        throw AuthException(
          message: 'Unsupported HTTP method: $method',
          code: 'unsupported_method',
        );
    }
  }

  // Test method to verify API connectivity
  static Future<void> testConnection() async {
    try {
      print('🧪 Testing API connection...');
      final response = await http.get(
        Uri.parse('$_baseUrl/api/'),
        headers: {
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );
      print('🧪 Test response status: ${response.statusCode}');
      print('🧪 Test response body: ${response.body}');
    } catch (e) {
      print('🧪 Test connection error: $e');
    }
  }
}
