import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cyclone/core/constants/app_assets.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/features/authentication/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authNotifier = ref.read(authProvider.notifier);
    final onboardingComplete = await authNotifier.isOnboardingComplete();
    final authState = ref.read(authProvider);

    if (authState.maybeWhen(authenticated: (_) => true, orElse: () => false)) {
      if (mounted) context.go('/home');
    } else if (!onboardingComplete) {
      if (mounted) context.go('/onboarding');
    } else {
      if (mounted) context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 200,
              height: 80,
              fit: BoxFit.contain,
            )
                .animate(controller: _controller)
                .fadeIn(duration: 600.ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 800.ms,
                  curve: Curves.easeOutBack,
                ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              AppConstants.appTagline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ).animate(controller: _controller).fadeIn(delay: 400.ms),
            const SizedBox(height: AppConstants.spacing2xl),
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ).animate(controller: _controller).fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
