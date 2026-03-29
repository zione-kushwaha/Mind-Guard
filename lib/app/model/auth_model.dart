class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName = '',
    this.lastName = '',
  });

  String get fullName {
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      return '$firstName $lastName'.trim();
    }
    return username;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    // Your API returns 'access' and 'refresh' tokens
    // Set expiration to 1 hour from now (typical for access tokens)
    final expirationTime = DateTime.now().add(const Duration(hours: 1));
    
    return AuthTokens(
      accessToken: json['access'] ?? '',
      refreshToken: json['refresh'] ?? '',
      expiresAt: expirationTime,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isExpiringSoon => DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));
  bool get isValid => accessToken.isNotEmpty && refreshToken.isNotEmpty && !isExpired;
}

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String username;
  final String email;
  final String password1;
  final String password2;

  RegisterRequest({
    required this.username,
    required this.email,
    required this.password1,
    required this.password2,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password1': password1,
      'password2': password2,
    };
  }
}

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthException implements Exception {
  final String message;
  final String? code;
  final int? statusCode;

  AuthException({
    required this.message,
    this.code,
    this.statusCode,
  });

  @override
  String toString() => 'AuthException: $message';
}
