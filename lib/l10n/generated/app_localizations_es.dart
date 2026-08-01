// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navHome => 'Inicio';

  @override
  String get navFlights => 'Vuelos';

  @override
  String get navMap => 'Mapa';

  @override
  String get navServices => 'Servicios';

  @override
  String get navProfile => 'Perfil';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSearchHint => 'Buscar en ajustes...';

  @override
  String get settingsGroupAppearance => 'Apariencia';

  @override
  String get settingsGroupAccessibility => 'Accesibilidad';

  @override
  String get settingsGroupLanguage => 'Idioma y región';

  @override
  String get settingsGroupSecurity => 'Seguridad y privacidad';

  @override
  String get settingsGroupData => 'Datos y almacenamiento';

  @override
  String get settingsGroupSupport => 'Soporte e información';

  @override
  String get settingDarkMode => 'Modo oscuro';

  @override
  String get settingDarkModeDesc =>
      'Cambiar al tema oscuro para una mejor visión nocturna';

  @override
  String get settingHighContrast => 'Alto contraste';

  @override
  String get settingHighContrastDesc =>
      'Aumentar el contraste visual para mejor accesibilidad';

  @override
  String get settingTextSize => 'Tamaño del texto';

  @override
  String get settingTextSizeDesc =>
      'Ajusta el tamaño del texto para una lectura cómoda';

  @override
  String get settingSimpleMode => 'Modo simple';

  @override
  String get settingSimpleModeDesc =>
      'Interfaz simplificada para una navegación más fácil';

  @override
  String get settingVoiceAssistant => 'Asistente de voz';

  @override
  String get settingVoiceAssistantDesc => 'Habilitar guía y anuncios por voz';

  @override
  String get settingAppLanguage => 'Idioma de la aplicación';

  @override
  String get settingAppLanguageDesc => 'Elige tu idioma preferido';

  @override
  String get settingBiometricLogin => 'Inicio de sesión biométrico';

  @override
  String get settingBiometricLoginDesc =>
      'Usa huella digital o reconocimiento facial para iniciar sesión';

  @override
  String get settingLocationServices => 'Servicios de ubicación';

  @override
  String get settingLocationServicesDesc =>
      'Requerido para navegación interior y servicios';

  @override
  String get settingNotifications => 'Notificaciones';

  @override
  String get settingNotificationsDesc =>
      'Gestionar alertas de vuelo y notificaciones de la aplicación';

  @override
  String get settingSyncSettings => 'Sincronizar ajustes';

  @override
  String get settingSyncSettingsDesc =>
      'Haz una copia de seguridad de tus preferencias en la nube';

  @override
  String get settingClearCache => 'Borrar caché';

  @override
  String get settingClearCacheDesc =>
      'Libera espacio de almacenamiento en tu dispositivo';

  @override
  String get settingAppVersion => 'Versión de la aplicación';

  @override
  String get settingAppVersionDesc => 'Versión 1.0.0 (Build 100)';

  @override
  String get settingPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingPrivacyPolicyDesc => 'Aprende cómo protegemos tus datos';

  @override
  String get settingTermsOfService => 'Términos del servicio';

  @override
  String get settingTermsOfServiceDesc => 'Lee nuestros términos y condiciones';

  @override
  String get settingContactSupport => 'Contactar soporte';

  @override
  String get settingContactSupportDesc =>
      'Obtén ayuda con cualquier pregunta o problema';

  @override
  String get settingsClearCacheTitle => 'Borrar caché';

  @override
  String get settingsClearCacheBody =>
      'Esto borrará todos los datos en caché y liberará espacio de almacenamiento. ¿Continuar?';

  @override
  String get settingsCacheCleared => 'Caché borrado con éxito';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonClear => 'Borrar';

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
  String get homeGoodMorning => 'Buenos días';

  @override
  String get homeGoodAfternoon => 'Buenas tardes';

  @override
  String get homeGoodEvening => 'Buenas noches';

  @override
  String get homeTraveler => 'Viajero';

  @override
  String get homeFlightStatus => 'Estado de vuelos';

  @override
  String get homeSeeAll => 'Ver todo';

  @override
  String get homeNotifications => 'Notificaciones';

  @override
  String get homeViewAll => 'Ver todo';

  @override
  String get homeUpcomingFlight => 'Próximo vuelo';

  @override
  String homeGate(Object gate) {
    return 'Puerta $gate';
  }

  @override
  String homeSeat(Object seat) {
    return 'Asiento $seat';
  }

  @override
  String homeTerminal(Object terminal) {
    return 'Terminal $terminal';
  }

  @override
  String get homeAirportMap => 'Mapa del aeropuerto';

  @override
  String get homeBoardingPass => 'Tarjeta de embarque';

  @override
  String get homeDining => 'Restaurantes';

  @override
  String get homeHelp => 'Ayuda';

  @override
  String get homeTravelTips => 'Consejos de viaje';

  @override
  String get homeTipCheckInEarly => 'Llegar temprano';

  @override
  String get homeTipCheckInEarlyBody =>
      'Llega 2 a 3 horas antes para vuelos internacionales y evita retrasos en seguridad.';

  @override
  String get homeTipLiquidsRule => 'Regla de líquidos';

  @override
  String get homeTipLiquidsRuleBody =>
      'Mantén todos los líquidos bajo 100 ml en una bolsa transparente sellable por seguridad.';

  @override
  String get homeTipFreeWifi => 'WiFi gratuito del aeropuerto';

  @override
  String get homeTipFreeWifiBody =>
      'Conéctate a \"JFK-FreeWiFi\" para internet gratuito en toda la terminal.';

  @override
  String get homeTipBaggage => 'Consejo de equipaje';

  @override
  String get homeTipBaggageBody =>
      'Toma una foto de tu equipaje antes del check-in para identificarlo fácilmente.';

  @override
  String get homeQuickConverter => 'Conversor rápido';

  @override
  String get homeWeatherDesc => 'Parcialmente nublado · Brisa ligera';

  @override
  String homeFeels(Object temp) {
    return 'Sensación $temp°';
  }

  @override
  String get homeEmergencyContacts => 'Contactos de emergencia';

  @override
  String get homeEmergency => 'Emergencia';

  @override
  String get homeMedical => 'Médico';

  @override
  String get homeFire => 'Incendio';

  @override
  String get homeAirportHelp => 'Ayuda del aeropuerto';

  @override
  String homeCalling(Object number, Object title) {
    return 'Llamando a $title: $number';
  }
}
