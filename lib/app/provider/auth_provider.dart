import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/auth_model.dart';
import '../service/auth_service.dart';
import '../service/token_manager.dart';

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _checkAuthState();
  }

  User? _currentUser;
  AuthTokens? _currentTokens;

  User? get currentUser => _currentUser;
  AuthTokens? get currentTokens => _currentTokens;

  Future<void> _checkAuthState() async {
    try {
      print('🔍 Checking authentication state...');
      final isAuth = await AuthService.isAuthenticated();
      
      if (isAuth) {
        _currentUser = await AuthService.getStoredUser();
        _currentTokens = await AuthService.getStoredTokens();
        
        if (_currentUser != null && _currentTokens != null) {
          print('✅ User authenticated: ${_currentUser!.username}');
          // Start automatic token refresh for existing session
          TokenManager.startTokenRefresh();
          state = AsyncValue.data(AuthState.authenticated);
        } else {
          print('❌ Missing user data or tokens');
          await AuthService.clearStoredData();
          state = const AsyncValue.data(AuthState.unauthenticated);
        }
      } else {
        print('❌ User not authenticated');
        _currentUser = null;
        _currentTokens = null;
        state = const AsyncValue.data(AuthState.unauthenticated);
      }
    } catch (e) {
      print('💥 Auth state check error: $e');
      _currentUser = null;
      _currentTokens = null;
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    print('🔐 Starting login process...');
    state = const AsyncValue.loading();

    try {
      final request = LoginRequest(
        username: username,
        password: password,
      );

      print('📡 Calling AuthService.login...');
      final result = await AuthService.login(request);
      print('✅ Login result: $result');
      
      if (result['success'] == true) {
        _currentUser = result['user'];
        _currentTokens = result['tokens'];
        print('👤 User set: ${_currentUser?.username}');
        print('🔑 Tokens set: ${_currentTokens?.accessToken.substring(0, 10)}...');
        
        // Start automatic token refresh
        TokenManager.startTokenRefresh();
        
        state = AsyncValue.data(AuthState.authenticated);
        print('🎉 Auth state set to authenticated');
        
        // Force a rebuild by using a brief delay
        await Future.delayed(const Duration(milliseconds: 100));
        print('🔄 Triggering state refresh...');
      } else {
        print('❌ Login failed - success not true');
        throw AuthException(
          message: 'Login failed',
          code: 'login_failed',
        );
      }
    } catch (e) {
      print('💥 Login error: $e');
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    print('📝 Starting registration process...');
    state = const AsyncValue.loading();

    try {
      final request = RegisterRequest(
        username: username,
        email: email,
        password1: password,
        password2: confirmPassword,
      );

      print('📡 Calling AuthService.register...');
      final result = await AuthService.register(request);
      print('✅ Registration result: $result');
      
      if (result['success'] == true) {
        _currentUser = result['user'];
        _currentTokens = result['tokens'];
        print('👤 User registered: ${_currentUser?.username}');
        print('🔑 Tokens set: ${_currentTokens?.accessToken.substring(0, 10)}...');
        
        // Start automatic token refresh
        TokenManager.startTokenRefresh();
        
        state = AsyncValue.data(AuthState.authenticated);
        print('🎉 Auth state set to authenticated');
        
        // Force a rebuild by using a brief delay
        await Future.delayed(const Duration(milliseconds: 100));
        print('🔄 Triggering state refresh...');
      } else {
        print('❌ Registration failed - success not true');
        throw AuthException(
          message: 'Registration failed',
          code: 'registration_failed',
        );
      }
    } catch (e) {
      print('💥 Registration error: $e');
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Stop token refresh
      TokenManager.stopTokenRefresh();
      
      await AuthService.logout();
      _currentUser = null;
      _currentTokens = null;
      state = const AsyncValue.data(AuthState.unauthenticated);
    } catch (e) {
      // Even if logout fails, clear local state
      TokenManager.stopTokenRefresh();
      _currentUser = null;
      _currentTokens = null;
      state = const AsyncValue.data(AuthState.unauthenticated);
    }
  }

  Future<void> refreshToken() async {
    try {
      final newTokens = await AuthService.refreshToken();
      _currentTokens = newTokens;
      
      // Restart token manager with new tokens
      TokenManager.startTokenRefresh();
    } catch (e) {
      // If refresh fails, logout
      await logout();
      rethrow;
    }
  }

  Future<void> refreshAuthState() async {
    await _checkAuthState();
  }

  bool get isAuthenticated {
    return state.value == AuthState.authenticated && _currentUser != null;
  }

  bool get isLoading {
    return state.isLoading;
  }

  String? get errorMessage {
    if (state.hasError) {
      final error = state.error;
      if (error is AuthException) {
        return error.message;
      }
      return error.toString();
    }
    return null;
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier();
});

// Convenience providers
final currentUserProvider = Provider<User?>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  return authNotifier.currentUser;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  final authNotifier = ref.watch(authProvider.notifier);
  
  // Check if the state is authenticated and we have a current user
  return authState.value == AuthState.authenticated && 
         authNotifier.currentUser != null &&
         authNotifier.currentTokens != null;
});

final authLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  return authNotifier.errorMessage;
});
