# TODO

## Plan to fix failing widget tests

1. Fix ProviderScope missing during tests by adding a `test`-friendly `ProviderScope` in `test/widget_test.dart`.
2. Ensure Riverpod providers used by `CycloneApp` (at least `storageServiceProvider`, `routerProvider`, `settingsProvider`, `authProvider`) have overrides in tests.
3. Provide a fake/empty `StorageService` implementation for tests so `SettingsNotifier` can load synchronously without real `SharedPreferences`.
4. Provide a fake `AuthNotifier`/repository or override `authProvider` to avoid network/secure-storage access during test.
5. Re-run `flutter test` and iterate on any remaining provider/runtime errors.

