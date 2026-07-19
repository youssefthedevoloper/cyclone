import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/services/storage_service.dart';
import 'package:cyclone/features/authentication/presentation/providers/auth_provider.dart'
    show storageServiceProvider;

class AppSettings {
  const AppSettings({
    this.isDarkMode = false,
    this.language = 'en',
    this.textScale = 1.0,
    this.highContrast = false,
    this.simpleMode = false,
    this.voiceAssistant = false,
  });

  final bool isDarkMode;
  final String language;
  final double textScale;
  final bool highContrast;
  final bool simpleMode;
  final bool voiceAssistant;

  AppSettings copyWith({
    bool? isDarkMode,
    String? language,
    double? textScale,
    bool? highContrast,
    bool? simpleMode,
    bool? voiceAssistant,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
      textScale: textScale ?? this.textScale,
      highContrast: highContrast ?? this.highContrast,
      simpleMode: simpleMode ?? this.simpleMode,
      voiceAssistant: voiceAssistant ?? this.voiceAssistant,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._storage) : super(const AppSettings()) {
    _load();
  }

  final StorageService _storage;

  Future<void> _load() async {
    state = AppSettings(
      isDarkMode: _storage.getBool(AppConstants.darkModeKey) ?? false,
      language: _storage.getString(AppConstants.languageKey) ?? 'en',
      textScale: _storage.getDouble(AppConstants.textScaleKey) ?? 1.0,
      highContrast: _storage.getBool(AppConstants.highContrastKey) ?? false,
      simpleMode: _storage.getBool(AppConstants.simpleModeKey) ?? false,
      voiceAssistant: _storage.getBool(AppConstants.voiceAssistantKey) ?? false,
    );
  }

  Future<void> toggleDarkMode() async {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
    await _storage.setBool(AppConstants.darkModeKey, state.isDarkMode);
  }

  Future<void> setLanguage(String language) async {
    state = state.copyWith(language: language);
    await _storage.setString(AppConstants.languageKey, language);
  }

  Future<void> setTextScale(double scale) async {
    state = state.copyWith(textScale: scale);
    await _storage.setDouble(AppConstants.textScaleKey, scale);
  }

  Future<void> toggleHighContrast() async {
    state = state.copyWith(highContrast: !state.highContrast);
    await _storage.setBool(AppConstants.highContrastKey, state.highContrast);
  }

  Future<void> toggleSimpleMode() async {
    state = state.copyWith(simpleMode: !state.simpleMode);
    await _storage.setBool(AppConstants.simpleModeKey, state.simpleMode);
  }

  Future<void> toggleVoiceAssistant() async {
    state = state.copyWith(voiceAssistant: !state.voiceAssistant);
    await _storage.setBool(AppConstants.voiceAssistantKey, state.voiceAssistant);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(storageServiceProvider));
});
