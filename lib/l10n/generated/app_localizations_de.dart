// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navHome => 'Start';

  @override
  String get navFlights => 'Flüge';

  @override
  String get navMap => 'Karte';

  @override
  String get navServices => 'Dienste';

  @override
  String get navProfile => 'Profil';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSearchHint => 'Einstellungen durchsuchen...';

  @override
  String get settingsGroupAppearance => 'Erscheinungsbild';

  @override
  String get settingsGroupAccessibility => 'Barrierefreiheit';

  @override
  String get settingsGroupLanguage => 'Sprache und Region';

  @override
  String get settingsGroupSecurity => 'Sicherheit und Datenschutz';

  @override
  String get settingsGroupData => 'Daten und Speicher';

  @override
  String get settingsGroupSupport => 'Hilfe und Info';

  @override
  String get settingDarkMode => 'Dunkelmodus';

  @override
  String get settingDarkModeDesc =>
      'Zum dunklen Design wechseln für bessere Sicht bei Nacht';

  @override
  String get settingHighContrast => 'Hoher Kontrast';

  @override
  String get settingHighContrastDesc =>
      'Visuellen Kontrast für bessere Barrierefreiheit erhöhen';

  @override
  String get settingTextSize => 'Textgröße';

  @override
  String get settingTextSizeDesc => 'Textgröße für angenehmes Lesen anpassen';

  @override
  String get settingSimpleMode => 'Einfacher Modus';

  @override
  String get settingSimpleModeDesc =>
      'Vereinfachte Oberfläche für einfachere Navigation';

  @override
  String get settingVoiceAssistant => 'Sprachassistent';

  @override
  String get settingVoiceAssistantDesc =>
      'Sprachführung und Ansagen aktivieren';

  @override
  String get settingAppLanguage => 'App-Sprache';

  @override
  String get settingAppLanguageDesc => 'Wählen Sie Ihre bevorzugte Sprache';

  @override
  String get settingBiometricLogin => 'Biometrische Anmeldung';

  @override
  String get settingBiometricLoginDesc =>
      'Fingerabdruck oder Gesichtserkennung zum Anmelden verwenden';

  @override
  String get settingLocationServices => 'Standortdienste';

  @override
  String get settingLocationServicesDesc =>
      'Für Innenraumnavigation und Dienste erforderlich';

  @override
  String get settingNotifications => 'Benachrichtigungen';

  @override
  String get settingNotificationsDesc =>
      'Flugwarnungen und App-Benachrichtigungen verwalten';

  @override
  String get settingSyncSettings => 'Einstellungen synchronisieren';

  @override
  String get settingSyncSettingsDesc =>
      'Ihre Einstellungen in der Cloud sichern';

  @override
  String get settingClearCache => 'Cache leeren';

  @override
  String get settingClearCacheDesc => 'Speicherplatz auf Ihrem Gerät freigeben';

  @override
  String get settingAppVersion => 'App-Version';

  @override
  String get settingAppVersionDesc => 'Version 1.0.0 (Build 100)';

  @override
  String get settingPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingPrivacyPolicyDesc =>
      'Erfahren Sie, wie wir Ihre Daten schützen';

  @override
  String get settingTermsOfService => 'Nutzungsbedingungen';

  @override
  String get settingTermsOfServiceDesc => 'Lesen Sie unsere Bedingungen';

  @override
  String get settingContactSupport => 'Support kontaktieren';

  @override
  String get settingContactSupportDesc =>
      'Hilfe bei Fragen oder Problemen erhalten';

  @override
  String get settingsClearCacheTitle => 'Cache leeren';

  @override
  String get settingsClearCacheBody =>
      'Dadurch werden alle zwischengespeicherten Daten gelöscht und Speicherplatz freigegeben. Fortfahren?';

  @override
  String get settingsCacheCleared => 'Cache erfolgreich geleert';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonClear => 'Leeren';

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
  String get homeGoodMorning => 'Guten Morgen';

  @override
  String get homeGoodAfternoon => 'Guten Tag';

  @override
  String get homeGoodEvening => 'Guten Abend';

  @override
  String get homeTraveler => 'Reisender';

  @override
  String get homeFlightStatus => 'Flugstatus';

  @override
  String get homeSeeAll => 'Alle anzeigen';

  @override
  String get homeNotifications => 'Benachrichtigungen';

  @override
  String get homeViewAll => 'Alle anzeigen';

  @override
  String get homeUpcomingFlight => 'Nächster Flug';

  @override
  String homeGate(Object gate) {
    return 'Gate $gate';
  }

  @override
  String homeSeat(Object seat) {
    return 'Sitzplatz $seat';
  }

  @override
  String homeTerminal(Object terminal) {
    return 'Terminal $terminal';
  }

  @override
  String get homeAirportMap => 'Flughafenkarte';

  @override
  String get homeBoardingPass => 'Bordkarte';

  @override
  String get homeDining => 'Gastronomie';

  @override
  String get homeHelp => 'Hilfe';

  @override
  String get homeTravelTips => 'Reisetipps';

  @override
  String get homeTipCheckInEarly => 'Früh einchecken';

  @override
  String get homeTipCheckInEarlyBody =>
      'Kommen Sie bei internationalen Flügen 2–3 Stunden früher, um Verzögerungen an der Sicherheitskontrolle zu vermeiden.';

  @override
  String get homeTipLiquidsRule => 'Flüssigkeitsregel';

  @override
  String get homeTipLiquidsRuleBody =>
      'Halten Sie Flüssigkeiten unter 100 ml in einem durchsichtigen, wiederverschließbaren Beutel.';

  @override
  String get homeTipFreeWifi => 'Kostenloses Flughafen-WLAN';

  @override
  String get homeTipFreeWifiBody =>
      'Verbinden Sie sich mit \"JFK-FreeWiFi\" für kostenloses Internet im gesamten Terminal.';

  @override
  String get homeTipBaggage => 'Gepäcktipp';

  @override
  String get homeTipBaggageBody =>
      'Fotografieren Sie Ihr Gepäck vor dem Check-in zur einfachen Identifizierung.';

  @override
  String get homeQuickConverter => 'Schnellumrechner';

  @override
  String get homeWeatherDesc => 'Teilweise bewölkt · Leichte Brise';

  @override
  String homeFeels(Object temp) {
    return 'Gefühlt $temp°';
  }

  @override
  String get homeEmergencyContacts => 'Notfallkontakte';

  @override
  String get homeEmergency => 'Notfall';

  @override
  String get homeMedical => 'Medizinisch';

  @override
  String get homeFire => 'Feuer';

  @override
  String get homeAirportHelp => 'Flughafen-Hilfe';

  @override
  String homeCalling(Object number, Object title) {
    return 'Anrufen $title: $number';
  }
}
