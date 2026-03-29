import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/auth_model.dart';

/// Service for storing and retrieving authentication tokens using SharedPreferences
/// This ensures persistent storage across app sessions
class TokenStorageService {
  static const String _tokenKey = 'auth_tokens';
  static const String _userKey = 'auth_user';
  static const String _isAuthenticatedKey = 'is_authenticated';

  /// Store authentication tokens
  static Future<void> storeTokens(AuthTokens tokens) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenJson = jsonEncode(tokens.toJson());
      await prefs.setString(_tokenKey, tokenJson);
      await prefs.setBool(_isAuthenticatedKey, true);
      print('✅ Tokens stored successfully in SharedPreferences');
    } catch (e) {
      print('❌ Error storing tokens: $e');
      throw Exception('Failed to store tokens: $e');
    }
  }

  /// Retrieve stored authentication tokens
  static Future<AuthTokens?> getTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tokenJson = prefs.getString(_tokenKey);
      
      if (tokenJson != null) {
        final tokenMap = jsonDecode(tokenJson) as Map<String, dynamic>;
        final tokens = AuthTokens.fromJson(tokenMap);
        print('✅ Tokens retrieved successfully from SharedPreferences');
        return tokens;
      }
      log(tokenJson??"");
  
      print('ℹ️ No tokens found in SharedPreferences');
      return null;
    } catch (e) {
      print('❌ Error retrieving tokens: $e');
      return null;
    }
  }

  /// Store user information
  static Future<void> storeUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
      print('✅ User data stored successfully in SharedPreferences');
    } catch (e) {
      print('❌ Error storing user data: $e');
      throw Exception('Failed to store user data: $e');
    }
  }

  /// Retrieve stored user information
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = User.fromJson(userMap);
        print('✅ User data retrieved successfully from SharedPreferences');
        return user;
      }
      
      print('ℹ️ No user data found in SharedPreferences');
      return null;
    } catch (e) {
      print('❌ Error retrieving user data: $e');
      return null;
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuth = prefs.getBool(_isAuthenticatedKey) ?? false;
      
      if (!isAuth) {
        print('ℹ️ User not authenticated according to SharedPreferences');
        return false;
      }

      // Also check if we have valid tokens
      final tokens = await getTokens();
      if (tokens == null) {
        print('ℹ️ No tokens found, user not authenticated');
        await setAuthenticationStatus(false);
        return false;
      }

      // Check if tokens are expired
      if (tokens.isExpired) {
        print('⚠️ Tokens expired, user needs to re-authenticate');
        await clearAllData();
        return false;
      }

      print('✅ User is authenticated with valid tokens');
      return true;
    } catch (e) {
      print('❌ Error checking authentication status: $e');
      return false;
    }
  }

  /// Set authentication status
  static Future<void> setAuthenticationStatus(bool isAuthenticated) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isAuthenticatedKey, isAuthenticated);
      print('✅ Authentication status set to: $isAuthenticated');
    } catch (e) {
      print('❌ Error setting authentication status: $e');
    }
  }

  /// Get current access token for API requests
  static Future<String?> getAccessToken() async {
    try {
      final tokens = await getTokens();
      log("message ${tokens?.accessToken}");
      if (tokens != null && !tokens.isExpired) {
        log(tokens.accessToken, name: 'Access Token');
        return tokens.accessToken;
      }
      return null;
    } catch (e) {
      print('❌ Error getting access token: $e');
      return null;
    }
  }

  /// Get authorization header for API requests
  static Future<Map<String, String>> getAuthHeaders() async {
    try {
      final token = await getAccessToken();
      if (token != null) {
        return {
          'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
          // 'Accept': 'application/json',
          // 'ngrok-skip-browser-warning': 'true',
        };
      }
      
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };
    } catch (e) {
      print('❌ Error getting auth headers: $e');
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };
    }
  }

  /// Clear all stored authentication data
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
      await prefs.setBool(_isAuthenticatedKey, false);
      print('✅ All authentication data cleared from SharedPreferences');
    } catch (e) {
      print('❌ Error clearing authentication data: $e');
    }
  }

  /// Update stored tokens (for token refresh)
  static Future<void> updateTokens(AuthTokens newTokens) async {
    await storeTokens(newTokens);
    print('✅ Tokens updated successfully');
  }

  /// Check if tokens need refreshing (within 5 minutes of expiry)
  static Future<bool> needsTokenRefresh() async {
    try {
      final tokens = await getTokens();
      if (tokens == null) return false;
      
      final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
      return tokens.expiresAt.isBefore(fiveMinutesFromNow);
    } catch (e) {
      print('❌ Error checking token refresh need: $e');
      return false;
    }
  }
}
