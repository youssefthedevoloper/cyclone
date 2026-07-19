import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/failures.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository({
    required this._secureStorage,
    required this._storage,
  });

  final SecureStorageService _secureStorage;
  final StorageService _storage;

  static const _mockUsers = {
    'demo@cyclone.app': {
      'password': 'password123',
      'user': {
        'id': 'user_001',
        'email': 'demo@cyclone.app',
        'firstName': 'Alex',
        'lastName': 'Traveler',
        'phone': '+1 555 0123',
        'nationality': 'United States',
        'preferredLanguage': 'en',
      },
    },
  };

  Future<UserModel?> getCurrentUser() async {
    final token = await _secureStorage.read(AppConstants.authTokenKey);
    if (token == null) return null;

    final userJson = await _secureStorage.read('user_data');
    if (userJson == null) return null;

    return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  Future<bool> isOnboardingComplete() async {
    return _storage.getBool(AppConstants.onboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    await _storage.setBool(AppConstants.onboardingCompleteKey, true);
  }

  Future<bool> isRememberMeEnabled() async {
    return _storage.getBool(AppConstants.rememberMeKey) ?? false;
  }

  Future<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    final mockUser = _mockUsers[email.toLowerCase()];
    if (mockUser == null || mockUser['password'] != password) {
      throw const AuthFailure(message: 'Invalid email or password');
    }

    final user = UserModel.fromJson(mockUser['user']! as Map<String, dynamic>);
    await _saveSession(user, rememberMe: rememberMe);
    return user;
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (_mockUsers.containsKey(email.toLowerCase())) {
      throw const AuthFailure(message: 'An account with this email already exists');
    }

    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      createdAt: DateTime.now(),
    );

    await _saveSession(user);
    return user;
  }

  Future<void> sendOtp(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!email.contains('@')) {
      throw const ValidationFailure(message: 'Invalid email address');
    }
  }

  Future<UserModel> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (otp != '123456') {
      throw const AuthFailure(message: 'Invalid OTP. Try 123456 for demo.');
    }

    final mockUser = _mockUsers[email.toLowerCase()];
    if (mockUser != null) {
      final user = UserModel.fromJson(mockUser['user']! as Map<String, dynamic>);
      await _saveSession(user);
      return user;
    }

    throw const AuthFailure(message: 'User not found');
  }

  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!email.contains('@')) {
      throw const ValidationFailure(message: 'Invalid email address');
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(AppConstants.authTokenKey);
    await _secureStorage.delete(AppConstants.refreshTokenKey);
    await _secureStorage.delete('user_data');
  }

  Future<bool> authenticateWithBiometric() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final user = await getCurrentUser();
    return user != null;
  }

  Future<void> _saveSession(UserModel user, {bool rememberMe = false}) async {
    await _secureStorage.write(AppConstants.authTokenKey, 'mock_token_${user.id}');
    await _secureStorage.write(
      'user_data',
      jsonEncode({
        'id': user.id,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phone': user.phone,
        'avatarUrl': user.avatarUrl,
        'nationality': user.nationality,
        'passportNumber': user.passportNumber,
        'preferredLanguage': user.preferredLanguage,
        'biometricEnabled': user.biometricEnabled,
      }),
    );
    await _storage.setBool(AppConstants.rememberMeKey, rememberMe);
  }
}
