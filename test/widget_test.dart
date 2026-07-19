// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cyclone/main.dart';
import 'package:cyclone/core/services/storage_service.dart';
import 'package:cyclone/features/authentication/presentation/providers/auth_provider.dart';
import 'package:cyclone/features/authentication/data/models/auth_state.dart';

import 'package:go_router/go_router.dart';

import 'package:cyclone/core/config/router/app_router.dart';
import 'package:cyclone/core/constants/app_constants.dart';

import 'package:cyclone/core/config/router/routes.dart';
import 'package:cyclone/core/services/secure_storage_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class _FakeSharedPreferences implements SharedPreferences {
  @override
  bool? getBool(String key) => null;

  @override
  double? getDouble(String key) => null;

  @override
  int? getInt(String key) => null;

  @override
  String? getString(String key) => null;

  @override
  List<String>? getStringList(String key) => null;

  @override
  Set<String> get keys => <String>{};

  @override
  dynamic get(String key) => null;

  @override
  Set<String> getKeys() => const <String>{};

  @override
  bool containsKey(String key) => false;

  @override
  Future<bool> commit() async => true;

  @override
  Future<void> reload() async {}

  @override
  Future<bool> setBool(String key, bool value) async => true;

  @override
  Future<bool> setDouble(String key, double value) async => true;

  @override
  Future<bool> setInt(String key, int value) async => true;

  @override
  Future<bool> setString(String key, String value) async => true;

  @override
  Future<bool> setStringList(String key, List<String> value) async => true;

  @override
  Future<bool> remove(String key) async => true;

  @override
  Future<bool> clear() async => true;

  @override
  Future<void> setAll(Map<String, Object> values) async {}

  @override
  Object? getInstanceName() => null;
}

class _FakeStorageService extends StorageService {
  _FakeStorageService() : super(_FakeSharedPreferences());
}

class AuthNotifierFake extends StateNotifier<AuthState> {
  AuthNotifierFake() : super(const AuthState.unauthenticated());
}


void main() {
  testWidgets('Cyclone app loads', (WidgetTester tester) async {
    final storage = _FakeStorageService();

    // Override required Riverpod providers so the app can build in isolation.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storage),
          secureStorageProvider.overrideWith((ref) => _FakeSecureStorageService()),

          // Prevent SplashScreen (which schedules a delayed navigation) from running in this smoke test.
          routerProvider.overrideWithValue(
            GoRouter(
              initialLocation: AppRoutes.home,
              routes: [
                GoRoute(
                  path: AppRoutes.home,
                  builder: (context, state) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Keep auth provider deterministic.
          authProvider.overrideWith((ref) {
            return AuthNotifier(ref.watch(authRepositoryProvider));
          }),
        ],
        child: const CycloneApp(),
      ),
    );

    // Let the widget tree settle.
    await tester.pump();

    // Some startup widgets (e.g. Splash) schedule delayed navigation/animations
    // using timers (flutter_animate). Advance time to avoid "Timer is still pending"
    // after test teardown.
    await tester.pump(const Duration(seconds: 3));

    // Splash screen starts navigation via delayed Future; for a simple
    // smoke test we only verify the root widget builds.
    expect(find.byType(CycloneApp), findsOneWidget);

  });
}

// Minimal secure storage fake to satisfy AuthRepository constructor.
class _FakeSecureStorageService extends SecureStorageService {
  _FakeSecureStorageService() : super(storage: null);

  @override
  Future<void> write(String key, String value) async {}

  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> deleteAll() async {}
}


