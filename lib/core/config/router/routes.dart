abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String home = '/home';
  static const String flights = '/flights';
  static const String flightDetails = '/flights/:id';
  static const String boardingPass = '/flights/:id/boarding-pass';
  static const String airportMap = '/airport/map';
  static const String airportNavigation = '/airport/navigation';
  static const String services = '/services';
  static const String profile = '/profile';

  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String travelerSetup = '/traveler-setup';


  // Services / Assistant
  static const String aiAssistant = '/assistant';
  static const String translator = '/assistant/translator';
  static const String lostAndFound = '/lost-and-found';
  static const String promotions = '/promotions';
  static const String accessibility = '/accessibility';
  static const String airportSupport = '/airport-support';
}
