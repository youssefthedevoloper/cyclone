import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navFlights.
  ///
  /// In en, this message translates to:
  /// **'Flights'**
  String get navFlights;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get navServices;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search settings...'**
  String get settingsSearchHint;

  /// No description provided for @settingsGroupAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsGroupAppearance;

  /// No description provided for @settingsGroupAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsGroupAccessibility;

  /// No description provided for @settingsGroupLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get settingsGroupLanguage;

  /// No description provided for @settingsGroupSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get settingsGroupSecurity;

  /// No description provided for @settingsGroupData.
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get settingsGroupData;

  /// No description provided for @settingsGroupSupport.
  ///
  /// In en, this message translates to:
  /// **'Support & About'**
  String get settingsGroupSupport;

  /// No description provided for @settingDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settingDarkMode;

  /// No description provided for @settingDarkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme for better night viewing'**
  String get settingDarkModeDesc;

  /// No description provided for @settingHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get settingHighContrast;

  /// No description provided for @settingHighContrastDesc.
  ///
  /// In en, this message translates to:
  /// **'Increase visual contrast for better accessibility'**
  String get settingHighContrastDesc;

  /// No description provided for @settingTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get settingTextSize;

  /// No description provided for @settingTextSizeDesc.
  ///
  /// In en, this message translates to:
  /// **'Adjust text size for comfortable reading'**
  String get settingTextSizeDesc;

  /// No description provided for @settingSimpleMode.
  ///
  /// In en, this message translates to:
  /// **'Simple Mode'**
  String get settingSimpleMode;

  /// No description provided for @settingSimpleModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Simplified interface for easier navigation'**
  String get settingSimpleModeDesc;

  /// No description provided for @settingVoiceAssistant.
  ///
  /// In en, this message translates to:
  /// **'Voice Assistant'**
  String get settingVoiceAssistant;

  /// No description provided for @settingVoiceAssistantDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable voice guidance and announcements'**
  String get settingVoiceAssistantDesc;

  /// No description provided for @settingAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get settingAppLanguage;

  /// No description provided for @settingAppLanguageDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get settingAppLanguageDesc;

  /// No description provided for @settingBiometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get settingBiometricLogin;

  /// No description provided for @settingBiometricLoginDesc.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face ID to sign in'**
  String get settingBiometricLoginDesc;

  /// No description provided for @settingLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Location Services'**
  String get settingLocationServices;

  /// No description provided for @settingLocationServicesDesc.
  ///
  /// In en, this message translates to:
  /// **'Required for indoor navigation and services'**
  String get settingLocationServicesDesc;

  /// No description provided for @settingNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingNotifications;

  /// No description provided for @settingNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage flight alerts and app notifications'**
  String get settingNotificationsDesc;

  /// No description provided for @settingSyncSettings.
  ///
  /// In en, this message translates to:
  /// **'Sync Settings'**
  String get settingSyncSettings;

  /// No description provided for @settingSyncSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Backup your preferences to the cloud'**
  String get settingSyncSettingsDesc;

  /// No description provided for @settingClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingClearCache;

  /// No description provided for @settingClearCacheDesc.
  ///
  /// In en, this message translates to:
  /// **'Free up storage space on your device'**
  String get settingClearCacheDesc;

  /// No description provided for @settingAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settingAppVersion;

  /// No description provided for @settingAppVersionDesc.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0 (Build 100)'**
  String get settingAppVersionDesc;

  /// No description provided for @settingPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingPrivacyPolicy;

  /// No description provided for @settingPrivacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Learn how we protect your data'**
  String get settingPrivacyPolicyDesc;

  /// No description provided for @settingTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingTermsOfService;

  /// No description provided for @settingTermsOfServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Read our terms and conditions'**
  String get settingTermsOfServiceDesc;

  /// No description provided for @settingContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get settingContactSupport;

  /// No description provided for @settingContactSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Get help with any questions or issues'**
  String get settingContactSupportDesc;

  /// No description provided for @settingsClearCacheTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCacheTitle;

  /// No description provided for @settingsClearCacheBody.
  ///
  /// In en, this message translates to:
  /// **'This will clear all cached data and free up storage space. Continue?'**
  String get settingsClearCacheBody;

  /// No description provided for @settingsCacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get settingsCacheCleared;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @homeGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get homeGoodMorning;

  /// No description provided for @homeGoodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get homeGoodAfternoon;

  /// No description provided for @homeGoodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get homeGoodEvening;

  /// No description provided for @homeTraveler.
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get homeTraveler;

  /// No description provided for @homeFlightStatus.
  ///
  /// In en, this message translates to:
  /// **'Flight Status'**
  String get homeFlightStatus;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get homeSeeAll;

  /// No description provided for @homeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get homeNotifications;

  /// No description provided for @homeViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get homeViewAll;

  /// No description provided for @homeUpcomingFlight.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Flight'**
  String get homeUpcomingFlight;

  /// No description provided for @homeGate.
  ///
  /// In en, this message translates to:
  /// **'Gate {gate}'**
  String homeGate(Object gate);

  /// No description provided for @homeSeat.
  ///
  /// In en, this message translates to:
  /// **'Seat {seat}'**
  String homeSeat(Object seat);

  /// No description provided for @homeTerminal.
  ///
  /// In en, this message translates to:
  /// **'T{terminal}'**
  String homeTerminal(Object terminal);

  /// No description provided for @homeAirportMap.
  ///
  /// In en, this message translates to:
  /// **'Airport Map'**
  String get homeAirportMap;

  /// No description provided for @homeBoardingPass.
  ///
  /// In en, this message translates to:
  /// **'Boarding Pass'**
  String get homeBoardingPass;

  /// No description provided for @homeDining.
  ///
  /// In en, this message translates to:
  /// **'Dining'**
  String get homeDining;

  /// No description provided for @homeHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get homeHelp;

  /// No description provided for @homeTravelTips.
  ///
  /// In en, this message translates to:
  /// **'Travel Tips'**
  String get homeTravelTips;

  /// No description provided for @homeTipCheckInEarly.
  ///
  /// In en, this message translates to:
  /// **'Check-In Early'**
  String get homeTipCheckInEarly;

  /// No description provided for @homeTipCheckInEarlyBody.
  ///
  /// In en, this message translates to:
  /// **'Arrive 2–3 hours early for international flights to avoid delays at security.'**
  String get homeTipCheckInEarlyBody;

  /// No description provided for @homeTipLiquidsRule.
  ///
  /// In en, this message translates to:
  /// **'Liquids Rule'**
  String get homeTipLiquidsRule;

  /// No description provided for @homeTipLiquidsRuleBody.
  ///
  /// In en, this message translates to:
  /// **'Keep all liquids under 100ml in a clear, resealable bag for security.'**
  String get homeTipLiquidsRuleBody;

  /// No description provided for @homeTipFreeWifi.
  ///
  /// In en, this message translates to:
  /// **'Free Airport WiFi'**
  String get homeTipFreeWifi;

  /// No description provided for @homeTipFreeWifiBody.
  ///
  /// In en, this message translates to:
  /// **'Connect to \"JFK-FreeWiFi\" for complimentary internet throughout the terminal.'**
  String get homeTipFreeWifiBody;

  /// No description provided for @homeTipBaggage.
  ///
  /// In en, this message translates to:
  /// **'Baggage Tip'**
  String get homeTipBaggage;

  /// No description provided for @homeTipBaggageBody.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of your luggage before check-in for easy identification.'**
  String get homeTipBaggageBody;

  /// No description provided for @homeQuickConverter.
  ///
  /// In en, this message translates to:
  /// **'Quick Converter'**
  String get homeQuickConverter;

  /// No description provided for @homeWeatherDesc.
  ///
  /// In en, this message translates to:
  /// **'Partly Cloudy · Light breeze'**
  String get homeWeatherDesc;

  /// No description provided for @homeFeels.
  ///
  /// In en, this message translates to:
  /// **'Feels {temp}°'**
  String homeFeels(Object temp);

  /// No description provided for @homeEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get homeEmergencyContacts;

  /// No description provided for @homeEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get homeEmergency;

  /// No description provided for @homeMedical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get homeMedical;

  /// No description provided for @homeFire.
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get homeFire;

  /// No description provided for @homeAirportHelp.
  ///
  /// In en, this message translates to:
  /// **'Airport Help'**
  String get homeAirportHelp;

  /// No description provided for @homeCalling.
  ///
  /// In en, this message translates to:
  /// **'Calling {title}: {number}'**
  String homeCalling(Object number, Object title);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
