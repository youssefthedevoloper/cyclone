import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cyclone/features/airport/presentation/screens/airport_map_screen.dart';
import 'package:cyclone/features/authentication/presentation/providers/auth_provider.dart';
import 'package:cyclone/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:cyclone/features/authentication/presentation/screens/login_screen.dart';
import 'package:cyclone/features/authentication/presentation/screens/onboarding_screen.dart';
import 'package:cyclone/features/authentication/presentation/screens/otp_verification_screen.dart';
import 'package:cyclone/features/authentication/presentation/screens/register_screen.dart';
import 'package:cyclone/features/authentication/presentation/screens/splash_screen.dart';
import 'package:cyclone/features/authentication/presentation/screens/traveler_setup_screen.dart';
import 'package:cyclone/features/flight/presentation/screens/flights_screen.dart';
import 'package:cyclone/features/home/presentation/screens/home_screen.dart';
import 'package:cyclone/features/navigation/presentation/widgets/main_shell.dart';
import 'package:cyclone/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:cyclone/features/profile/presentation/screens/profile_screen.dart';
import 'package:cyclone/features/services/presentation/screens/services_screen.dart';
import 'package:cyclone/features/settings/presentation/screens/settings_screen.dart';
import 'package:cyclone/features/assistant/presentation/screens/ai_assistant_screen.dart';
import 'package:cyclone/features/translator/presentation/screens/translator_screen.dart';
import 'package:cyclone/features/lost_found/presentation/screens/lost_and_found_screen.dart';
import 'package:cyclone/features/promotions/presentation/screens/promotions_screen.dart';
import 'package:cyclone/features/accessibility/presentation/screens/accessibility_screen.dart';
import 'package:cyclone/features/airport_support/presentation/screens/airport_support_screen.dart';
import 'package:cyclone/features/lounge/presentation/screens/lounge_screen.dart';
import 'package:cyclone/features/taxi/presentation/screens/taxi_screen.dart';
import 'package:cyclone/features/common/presentation/screens/placeholder_screen.dart';

import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );

      final isAuthRoute = state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.onboarding ||
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation.startsWith('/forgot-password') ||
          state.matchedLocation.startsWith('/otp-verification');

      if (state.matchedLocation == AppRoutes.splash) return null;

      if (!isAuthenticated) {
        if (isAuthRoute) return null;
        return AppRoutes.login;
      }

      if (state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.travelerSetup) {
        return null;
      }

      if (isAuthenticated && isAuthRoute && state.matchedLocation != AppRoutes.splash) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: AppRoutes.otpVerification, builder: (context, state) => OtpVerificationScreen(email: state.uri.queryParameters['email'] ?? '')),
      GoRoute(path: AppRoutes.travelerSetup, builder: (context, state) => const TravelerSetupScreen()),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.home, pageBuilder: (context, state) => CustomTransitionPage(key: state.pageKey, child: const HomeScreen(), transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child))),
          GoRoute(path: AppRoutes.flights, builder: (context, state) => const FlightsScreen(), routes: [
            GoRoute(path: ':id', builder: (context, state) => FlightDetailsScreen(flightId: state.pathParameters['id']!), routes: [
              GoRoute(path: 'boarding-pass', builder: (context, state) => BoardingPassScreen(flightId: state.pathParameters['id']!)),
            ]),
          ]),
          GoRoute(path: AppRoutes.airportMap, builder: (context, state) => const AirportMapScreen()),
          GoRoute(path: AppRoutes.airportNavigation, builder: (context, state) => const AirportNavigationScreen()),
          GoRoute(path: AppRoutes.services, builder: (context, state) => const ServicesScreen()),
          GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
          GoRoute(path: AppRoutes.lounge, builder: (context, state) => const LoungeScreen()),
          GoRoute(path: AppRoutes.aiAssistant, builder: (context, state) => const AiAssistantScreen()),
          GoRoute(path: AppRoutes.translator, builder: (context, state) => const TranslatorScreen()),
          GoRoute(path: AppRoutes.promotions, builder: (context, state) => const PromotionsScreen()),
          GoRoute(path: AppRoutes.lostAndFound, builder: (context, state) => const LostAndFoundScreen()),
          GoRoute(path: AppRoutes.accessibility, builder: (context, state) => const AccessibilityScreen()),
          GoRoute(path: AppRoutes.airportSupport, builder: (context, state) => const AirportSupportScreen()),
          GoRoute(path: AppRoutes.prayerRooms, builder: (context, state) => const PlaceholderScreen(title: 'Prayer Rooms')),
          GoRoute(path: AppRoutes.restrooms, builder: (context, state) => const PlaceholderScreen(title: 'Restrooms')),
          GoRoute(path: AppRoutes.chargingStations, builder: (context, state) => const PlaceholderScreen(title: 'Charging Stations')),
          GoRoute(path: AppRoutes.currencyConverter, builder: (context, state) => const PlaceholderScreen(title: 'Currency Converter')),
          GoRoute(path: AppRoutes.currencyExchange, builder: (context, state) => const PlaceholderScreen(title: 'Currency Exchange')),
          GoRoute(path: AppRoutes.embassy, builder: (context, state) => const PlaceholderScreen(title: 'Embassy')),
          GoRoute(path: AppRoutes.visaInfo, builder: (context, state) => const PlaceholderScreen(title: 'Visa Information')),
          GoRoute(path: AppRoutes.passportReminder, builder: (context, state) => const PlaceholderScreen(title: 'Passport Reminder')),
          GoRoute(path: AppRoutes.travelChecklist, builder: (context, state) => const PlaceholderScreen(title: 'Travel Checklist')),
          GoRoute(path: AppRoutes.medicalAssistance, builder: (context, state) => const PlaceholderScreen(title: 'Medical Assistance')),
          GoRoute(path: AppRoutes.taxi, builder: (context, state) => const TaxiScreen()),
          GoRoute(path: AppRoutes.dining, builder: (context, state) => const PlaceholderScreen(title: 'Dining')),
          GoRoute(path: AppRoutes.shopping, builder: (context, state) => const PlaceholderScreen(title: 'Shopping')),
          GoRoute(path: AppRoutes.weather, builder: (context, state) => const PlaceholderScreen(title: 'Weather')),
          GoRoute(path: AppRoutes.qrLostRecovery, builder: (context, state) => const PlaceholderScreen(title: 'QR Lost Recovery')),
        ],
      ),
      GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: AppRoutes.notifications, builder: (context, state) => const NotificationsScreen()),
    ],
  );
});
