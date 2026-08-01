// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navHome => 'Accueil';

  @override
  String get navFlights => 'Vols';

  @override
  String get navMap => 'Carte';

  @override
  String get navServices => 'Services';

  @override
  String get navProfile => 'Profil';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSearchHint => 'Rechercher dans les paramètres...';

  @override
  String get settingsGroupAppearance => 'Apparence';

  @override
  String get settingsGroupAccessibility => 'Accessibilité';

  @override
  String get settingsGroupLanguage => 'Langue et région';

  @override
  String get settingsGroupSecurity => 'Sécurité et confidentialité';

  @override
  String get settingsGroupData => 'Données et stockage';

  @override
  String get settingsGroupSupport => 'Assistance et informations';

  @override
  String get settingDarkMode => 'Mode sombre';

  @override
  String get settingDarkModeDesc =>
      'Passer au thème sombre pour une meilleure visibilité la nuit';

  @override
  String get settingHighContrast => 'Contraste élevé';

  @override
  String get settingHighContrastDesc =>
      'Augmenter le contraste visuel pour une meilleure accessibilité';

  @override
  String get settingTextSize => 'Taille du texte';

  @override
  String get settingTextSizeDesc =>
      'Ajuster la taille du texte pour une lecture confortable';

  @override
  String get settingSimpleMode => 'Mode simple';

  @override
  String get settingSimpleModeDesc =>
      'Interface simplifiée pour une navigation plus facile';

  @override
  String get settingVoiceAssistant => 'Assistant vocal';

  @override
  String get settingVoiceAssistantDesc =>
      'Activer les guides et annonces vocaux';

  @override
  String get settingAppLanguage => 'Langue de l\'application';

  @override
  String get settingAppLanguageDesc => 'Choisissez votre langue préférée';

  @override
  String get settingBiometricLogin => 'Connexion biométrique';

  @override
  String get settingBiometricLoginDesc =>
      'Utiliser l\'empreinte ou la reconnaissance faciale pour se connecter';

  @override
  String get settingLocationServices => 'Services de localisation';

  @override
  String get settingLocationServicesDesc =>
      'Requis pour la navigation intérieure et les services';

  @override
  String get settingNotifications => 'Notifications';

  @override
  String get settingNotificationsDesc =>
      'Gérer les alertes de vol et les notifications de l\'application';

  @override
  String get settingSyncSettings => 'Synchroniser les paramètres';

  @override
  String get settingSyncSettingsDesc =>
      'Sauvegarder vos préférences dans le cloud';

  @override
  String get settingClearCache => 'Vider le cache';

  @override
  String get settingClearCacheDesc =>
      'Libérer de l\'espace de stockage sur votre appareil';

  @override
  String get settingAppVersion => 'Version de l\'application';

  @override
  String get settingAppVersionDesc => 'Version 1.0.0 (Build 100)';

  @override
  String get settingPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingPrivacyPolicyDesc =>
      'Découvrez comment nous protégeons vos données';

  @override
  String get settingTermsOfService => 'Conditions d\'utilisation';

  @override
  String get settingTermsOfServiceDesc => 'Lisez nos conditions générales';

  @override
  String get settingContactSupport => 'Contacter l\'assistance';

  @override
  String get settingContactSupportDesc =>
      'Obtenez de l\'aide pour toute question ou problème';

  @override
  String get settingsClearCacheTitle => 'Vider le cache';

  @override
  String get settingsClearCacheBody =>
      'Cela effacera toutes les données en cache et libérera de l\'espace. Continuer ?';

  @override
  String get settingsCacheCleared => 'Cache vidé avec succès';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonClear => 'Vider';

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
  String get homeGoodMorning => 'Bonjour';

  @override
  String get homeGoodAfternoon => 'Bon après-midi';

  @override
  String get homeGoodEvening => 'Bonsoir';

  @override
  String get homeTraveler => 'Voyageur';

  @override
  String get homeFlightStatus => 'État des vols';

  @override
  String get homeSeeAll => 'Voir tout';

  @override
  String get homeNotifications => 'Notifications';

  @override
  String get homeViewAll => 'Tout voir';

  @override
  String get homeUpcomingFlight => 'Prochain vol';

  @override
  String homeGate(Object gate) {
    return 'Porte $gate';
  }

  @override
  String homeSeat(Object seat) {
    return 'Siège $seat';
  }

  @override
  String homeTerminal(Object terminal) {
    return 'Terminal $terminal';
  }

  @override
  String get homeAirportMap => 'Plan de l\'aéroport';

  @override
  String get homeBoardingPass => 'Carte d\'embarquement';

  @override
  String get homeDining => 'Restauration';

  @override
  String get homeHelp => 'Aide';

  @override
  String get homeTravelTips => 'Conseils de voyage';

  @override
  String get homeTipCheckInEarly => 'Enregistrement anticipé';

  @override
  String get homeTipCheckInEarlyBody =>
      'Arrivez 2 à 3 heures à l\'avance pour les vols internationaux afin d\'éviter les retards à la sécurité.';

  @override
  String get homeTipLiquidsRule => 'Règle des liquides';

  @override
  String get homeTipLiquidsRuleBody =>
      'Gardez tous les liquides sous 100 ml dans un sac transparent refermable pour la sécurité.';

  @override
  String get homeTipFreeWifi => 'WiFi gratuit de l\'aéroport';

  @override
  String get homeTipFreeWifiBody =>
      'Connectez-vous à \"JFK-FreeWiFi\" pour un accès internet gratuit dans tout le terminal.';

  @override
  String get homeTipBaggage => 'Conseil bagages';

  @override
  String get homeTipBaggageBody =>
      'Prenez une photo de vos bagages avant l\'enregistrement pour une identification facile.';

  @override
  String get homeQuickConverter => 'Convertisseur rapide';

  @override
  String get homeWeatherDesc => 'Partiellement nuageux · Brise légère';

  @override
  String homeFeels(Object temp) {
    return 'Ressenti $temp°';
  }

  @override
  String get homeEmergencyContacts => 'Contacts d\'urgence';

  @override
  String get homeEmergency => 'Urgence';

  @override
  String get homeMedical => 'Médical';

  @override
  String get homeFire => 'Incendie';

  @override
  String get homeAirportHelp => 'Aide aéroport';

  @override
  String homeCalling(Object number, Object title) {
    return 'Appel de $title : $number';
  }
}
