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
import 'package:cyclone/features/flight/presentation/screens/flights_screen.dart';
import 'package:cyclone/features/home/presentation/screens/home_screen.dart';
import 'package:cyclone/features/navigation/presentation/widgets/main_shell.dart';
import 'package:cyclone/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:cyclone/features/profile/presentation/screens/profile_screen.dart';
import 'package:cyclone/features/settings/presentation/screens/settings_screen.dart';
import 'package:cyclone/features/services/presentation/screens/services_screen.dart';

import 'package:cyclone/features/assistant/presentation/screens/ai_assistant_screen.dart';

import 'package:cyclone/features/translator/presentation/screens/translator_screen.dart';
import 'package:cyclone/features/lost_found/presentation/screens/lost_and_found_screen.dart';
import 'package:cyclone/features/promotions/presentation/screens/promotions_screen.dart';
import 'package:cyclone/features/accessibility/presentation/screens/accessibility_screen.dart';
import 'package:cyclone/features/airport_support/presentation/screens/airport_support_screen.dart';

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

      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated) {
        final isOnboardingDone = authState.maybeWhen(
          authenticated: (_) => authState.maybeWhen(
                authenticated: (_) => true,
                orElse: () => false,
              ),
          orElse: () => false,
        );

        // NOTE: until backend wiring exists, we still rely on local onboarding flag.
        if (!isOnboardingDone && state.matchedLocation != AppRoutes.travelerSetup) {
          return AppRoutes.travelerSetup;
        }

        if (isAuthRoute && state.matchedLocation != AppRoutes.splash && state.matchedLocation != AppRoutes.travelerSetup) {
          return AppRoutes.home;
        }
      } else {
        if (isAuthRoute && state.matchedLocation != AppRoutes.splash) {
          return AppRoutes.login;
        }
      }


      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return OtpVerificationScreen(email: email);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: AppRoutes.flights,
            builder: (context, state) => const FlightsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return FlightDetailsScreen(flightId: id);
                },
                routes: [
                  GoRoute(
                    path: 'boarding-pass',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return BoardingPassScreen(flightId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/airport/map',
            builder: (context, state) => const AirportMapScreen(),
          ),
          GoRoute(
            path: '/airport/navigation',
            builder: (context, state) => const AirportNavigationScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.services,
            builder: (context, state) => const ServicesScreen(),
          ),

          // Services / Assistant inside shell to keep bottom nav consistent.

          GoRoute(
            path: AppRoutes.aiAssistant,
            builder: (context, state) => const AiAssistantScreen(),
          ),
          GoRoute(
            path: AppRoutes.translator,
            builder: (context, state) => const TranslatorScreen(),
          ),
          GoRoute(
            path: AppRoutes.promotions,
            builder: (context, state) => const PromotionsScreen(),
          ),
          GoRoute(
            path: AppRoutes.lostAndFound,
            builder: (context, state) => const LostAndFoundScreen(),
          ),
          GoRoute(
            path: AppRoutes.accessibility,
            builder: (context, state) => const AccessibilityScreen(),
          ),
          GoRoute(
            path: AppRoutes.airportSupport,
            builder: (context, state) => const AirportSupportScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
});

