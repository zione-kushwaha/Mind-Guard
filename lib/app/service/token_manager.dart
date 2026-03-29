import 'dart:async';
import 'auth_service.dart';
import 'token_storage_service.dart';

class TokenManager {
  static Timer? _refreshTimer;
  static bool _isRefreshing = false;

  /// Start automatic token refresh
  static void startTokenRefresh() {
    _refreshTimer?.cancel();
    _scheduleNextRefresh();
  }

  /// Stop automatic token refresh
  static void stopTokenRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Schedule the next token refresh
  static void _scheduleNextRefresh() async {
    try {
      final tokens = await TokenStorageService.getTokens();
      if (tokens == null || tokens.isExpired) {
        print('🔄 No valid tokens to refresh');
        return;
      }

      // Calculate when to refresh (5 minutes before expiration)
      final refreshTime = tokens.expiresAt.subtract(const Duration(minutes: 5));
      final now = DateTime.now();
      
      if (refreshTime.isBefore(now)) {
        // Token expires soon, refresh immediately
        await _performTokenRefresh();
      } else {
        // Schedule refresh for later
        final delay = refreshTime.difference(now);
        print('🕐 Scheduling token refresh in ${delay.inMinutes} minutes');
        
        _refreshTimer = Timer(delay, () {
          _performTokenRefresh();
        });
      }
    } catch (e) {
      print('❌ Error scheduling token refresh: $e');
    }
  }

  /// Perform the actual token refresh
  static Future<void> _performTokenRefresh() async {
    if (_isRefreshing) {
      print('🔄 Token refresh already in progress');
      return;
    }

    _isRefreshing = true;
    try {
      print('🔄 Performing automatic token refresh...');
      await AuthService.refreshToken();
      print('✅ Automatic token refresh successful');
      
      // Schedule the next refresh
      _scheduleNextRefresh();
    } catch (e) {
      print('❌ Automatic token refresh failed: $e');
      // If refresh fails, user will need to login again
      await AuthService.clearStoredData();
    } finally {
      _isRefreshing = false;
    }
  }

  /// Check if tokens need refresh and do it if necessary
  static Future<bool> ensureValidTokens() async {
    try {
      final tokens = await AuthService.getStoredTokens();
      if (tokens == null) {
        return false;
      }

      if (tokens.isExpired) {
        print('🔄 Tokens expired, attempting refresh...');
        await AuthService.refreshToken();
        return true;
      }

      if (tokens.isExpiringSoon && !_isRefreshing) {
        print('🔄 Tokens expiring soon, refreshing...');
        await _performTokenRefresh();
        return true;
      }

      return true;
    } catch (e) {
      print('❌ Token validation failed: $e');
      return false;
    }
  }

  /// Get valid access token for API calls
  static Future<String?> getValidAccessToken() async {
    try {
      if (await ensureValidTokens()) {
        final tokens = await AuthService.getStoredTokens();
        return tokens?.accessToken;
      }
    } catch (e) {
      print('❌ Error getting valid access token: $e');
    }
    return null;
  }
}
