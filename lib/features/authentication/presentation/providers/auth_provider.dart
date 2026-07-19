import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/failures.dart';
import '../../data/models/auth_state.dart';
import '../../data/repositories/auth_repository.dart';

final secureStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final storageServiceProvider = Provider<StorageService>(
  (ref) => throw UnimplementedError('StorageService must be overridden'),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    secureStorage: ref.watch(secureStorageProvider),
    storage: ref.watch(storageServiceProvider),
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  final AuthRepository _repository;

  Future<void> _checkAuthStatus() async {
    state = const AuthState.loading();
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<bool> isOnboardingComplete() => _repository.isOnboardingComplete();

  Future<void> completeOnboarding() => _repository.setOnboardingComplete();

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      state = AuthState.authenticated(user);
    } on Failure catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      state = AuthState.authenticated(user);
    } on Failure catch (e) {
      state = AuthState.error(e.message);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> sendOtp(String email) async {
    state = const AuthState.loading();
    try {
      await _repository.sendOtp(email);
      state = AuthState.otpSent(email);
    } on Failure catch (e) {
      state = AuthState.error(e.message);
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.verifyOtp(email: email, otp: otp);
      state = AuthState.authenticated(user);
    } on Failure catch (e) {
      state = AuthState.error(e.message);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AuthState.loading();
    try {
      await _repository.sendPasswordReset(email);
      state = AuthState.passwordResetSent(email);
    } on Failure catch (e) {
      state = AuthState.error(e.message);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }

  Future<bool> authenticateWithBiometric() async {
    return _repository.authenticateWithBiometric();
  }
}
