// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navFlights => 'Flights';

  @override
  String get navMap => 'Map';

  @override
  String get navServices => 'Services';

  @override
  String get navProfile => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSearchHint => 'Search settings...';

  @override
  String get settingsGroupAppearance => 'Appearance';

  @override
  String get settingsGroupAccessibility => 'Accessibility';

  @override
  String get settingsGroupLanguage => 'Language & Region';

  @override
  String get settingsGroupSecurity => 'Security & Privacy';

  @override
  String get settingsGroupData => 'Data & Storage';

  @override
  String get settingsGroupSupport => 'Support & About';

  @override
  String get settingDarkMode => 'Dark Mode';

  @override
  String get settingDarkModeDesc =>
      'Switch to dark theme for better night viewing';

  @override
  String get settingHighContrast => 'High Contrast';

  @override
  String get settingHighContrastDesc =>
      'Increase visual contrast for better accessibility';

  @override
  String get settingTextSize => 'Text Size';

  @override
  String get settingTextSizeDesc => 'Adjust text size for comfortable reading';

  @override
  String get settingSimpleMode => 'Simple Mode';

  @override
  String get settingSimpleModeDesc =>
      'Simplified interface for easier navigation';

  @override
  String get settingVoiceAssistant => 'Voice Assistant';

  @override
  String get settingVoiceAssistantDesc =>
      'Enable voice guidance and announcements';

  @override
  String get settingAppLanguage => 'App Language';

  @override
  String get settingAppLanguageDesc => 'Choose your preferred language';

  @override
  String get settingBiometricLogin => 'Biometric Login';

  @override
  String get settingBiometricLoginDesc =>
      'Use fingerprint or face ID to sign in';

  @override
  String get settingLocationServices => 'Location Services';

  @override
  String get settingLocationServicesDesc =>
      'Required for indoor navigation and services';

  @override
  String get settingNotifications => 'Notifications';

  @override
  String get settingNotificationsDesc =>
      'Manage flight alerts and app notifications';

  @override
  String get settingSyncSettings => 'Sync Settings';

  @override
  String get settingSyncSettingsDesc => 'Backup your preferences to the cloud';

  @override
  String get settingClearCache => 'Clear Cache';

  @override
  String get settingClearCacheDesc => 'Free up storage space on your device';

  @override
  String get settingAppVersion => 'App Version';

  @override
  String get settingAppVersionDesc => 'Version 1.0.0 (Build 100)';

  @override
  String get settingPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingPrivacyPolicyDesc => 'Learn how we protect your data';

  @override
  String get settingTermsOfService => 'Terms of Service';

  @override
  String get settingTermsOfServiceDesc => 'Read our terms and conditions';

  @override
  String get settingContactSupport => 'Contact Support';

  @override
  String get settingContactSupportDesc =>
      'Get help with any questions or issues';

  @override
  String get settingsClearCacheTitle => 'Clear Cache';

  @override
  String get settingsClearCacheBody =>
      'This will clear all cached data and free up storage space. Continue?';

  @override
  String get settingsCacheCleared => 'Cache cleared successfully';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClear => 'Clear';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get homeGoodMorning => 'Good morning';

  @override
  String get homeGoodAfternoon => 'Good afternoon';

  @override
  String get homeGoodEvening => 'Good evening';

  @override
  String get homeTraveler => 'Traveler';

  @override
  String get homeFlightStatus => 'Flight Status';

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homeNotifications => 'Notifications';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeUpcomingFlight => 'Upcoming Flight';

  @override
  String homeGate(Object gate) {
    return 'Gate $gate';
  }

  @override
  String homeSeat(Object seat) {
    return 'Seat $seat';
  }

  @override
  String homeTerminal(Object terminal) {
    return 'T$terminal';
  }

  @override
  String get homeAirportMap => 'Airport Map';

  @override
  String get homeBoardingPass => 'Boarding Pass';

  @override
  String get homeDining => 'Dining';

  @override
  String get homeHelp => 'Help';

  @override
  String get homeTravelTips => 'Travel Tips';

  @override
  String get homeTipCheckInEarly => 'Check-In Early';

  @override
  String get homeTipCheckInEarlyBody =>
      'Arrive 2–3 hours early for international flights to avoid delays at security.';

  @override
  String get homeTipLiquidsRule => 'Liquids Rule';

  @override
  String get homeTipLiquidsRuleBody =>
      'Keep all liquids under 100ml in a clear, resealable bag for security.';

  @override
  String get homeTipFreeWifi => 'Free Airport WiFi';

  @override
  String get homeTipFreeWifiBody =>
      'Connect to \"JFK-FreeWiFi\" for complimentary internet throughout the terminal.';

  @override
  String get homeTipBaggage => 'Baggage Tip';

  @override
  String get homeTipBaggageBody =>
      'Take a photo of your luggage before check-in for easy identification.';

  @override
  String get homeQuickConverter => 'Quick Converter';

  @override
  String get homeWeatherDesc => 'Partly Cloudy · Light breeze';

  @override
  String homeFeels(Object temp) {
    return 'Feels $temp°';
  }

  @override
  String get homeEmergencyContacts => 'Emergency Contacts';

  @override
  String get homeEmergency => 'Emergency';

  @override
  String get homeMedical => 'Medical';

  @override
  String get homeFire => 'Fire';

  @override
  String get homeAirportHelp => 'Airport Help';

  @override
  String homeCalling(Object number, Object title) {
    return 'Calling $title: $number';
  }
}
