import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/gradient_button.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.flight_takeoff_rounded,
      title: 'Navigate with Confidence',
      description:
          'Interactive airport maps guide you to gates, lounges, and amenities with real-time walking directions.',
      color: AppColors.primary,
    ),
    _OnboardingPage(
      icon: Icons.qr_code_scanner_rounded,
      title: 'Digital Boarding Pass',
      description:
          'Access your boarding pass instantly. Scan QR codes at security and boarding gates seamlessly.',
      color: Color(0xFF7C3AED),
    ),
    _OnboardingPage(
      icon: Icons.notifications_active_rounded,
      title: 'Stay Informed',
      description:
          'Get instant alerts for gate changes, delays, boarding calls, and weather updates at your airport.',
      color: Color(0xFF059669),
    ),
    _OnboardingPage(
      icon: Icons.accessibility_new_rounded,
      title: 'Built for Everyone',
      description:
          'Voice guidance, large text, high contrast, and simple mode make travel accessible for all passengers.',
      color: Color(0xFFEA580C),
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.animationNormal,
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    await ref.read(authProvider.notifier).completeOnboarding();
    if (mounted) context.go('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _complete,
                child: Text(
                  'Skip',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingXl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: page.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 56, color: page.color),
                        )
                            .animate(key: ValueKey(index))
                            .fadeIn(duration: 400.ms)
                            .scale(
                              begin: const Offset(0.5, 0.5),
                              curve: Curves.easeOutBack,
                            ),
                        const SizedBox(height: AppConstants.spacing2xl),
                        Text(
                          page.title,
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ).animate(key: ValueKey('title_$index')).fadeIn(delay: 100.ms),
                        const SizedBox(height: AppConstants.spacingMd),
                        Text(
                          page.description,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                          textAlign: TextAlign.center,
                        ).animate(key: ValueKey('desc_$index')).fadeIn(delay: 200.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _pages.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: AppColors.primary,
                dotColor: AppColors.border,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLg,
              ),
              child: GradientButton(
                label: _currentPage == _pages.length - 1 ? 'Get Started' : 'Continue',
                onPressed: _nextPage,
                icon: _currentPage == _pages.length - 1
                    ? Icons.arrow_forward_rounded
                    : null,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
}
