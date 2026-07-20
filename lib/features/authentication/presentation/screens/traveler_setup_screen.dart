import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../widgets/cyclone_text_field.dart';
import '../../../../widgets/gradient_button.dart';
import '../providers/auth_provider.dart';
import '../../../../core/config/router/routes.dart';

class TravelerSetupScreen extends ConsumerStatefulWidget {
  const TravelerSetupScreen({super.key});

  @override
  ConsumerState<TravelerSetupScreen> createState() => _TravelerSetupScreenState();
}

class _TravelerSetupScreenState extends ConsumerState<TravelerSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _airportCodeController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _preferredLanguageController = TextEditingController();
  final _passportController = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _airportCodeController.dispose();
    _nationalityController.dispose();
    _preferredLanguageController.dispose();
    _passportController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      // For now this is persisted locally until backend onboarding endpoint is wired.
      // Requirements: airport + user info mandatory.
      await ref.read(authProvider.notifier).completeOnboarding();
      if (!mounted) return;
      context.go(AppRoutes.home);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traveler Setup'),
        actions: [
          TextButton(
            onPressed: () => context.go(AppRoutes.home),
            child: const Text('Skip'),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your airport profile',
                  style: Theme.of(context).textTheme.displayMedium,
                ).animate().fadeIn().slideX(begin: -0.1),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Airport + traveler information are required to unlock boarding, map guidance, and tickets.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: AppConstants.spacingXl),

                CycloneTextField(
                  controller: _airportCodeController,
                  label: 'Airport Code (IATA) *',
                  hint: 'JFK',
                  prefixIcon: Icons.flight_takeoff_outlined,
                  keyboardType: TextInputType.text,
                  validator: (v) {
                    final val = (v ?? '').trim().toUpperCase();
                    if (val.isEmpty) return 'Airport code is required';
                    if (val.length < 3) return 'Enter a valid IATA code';
                    return null;
                  },
                ).animate().fadeIn(delay: 150.ms),
                const SizedBox(height: AppConstants.spacingMd),

                CycloneTextField(
                  controller: _nationalityController,
                  label: 'Nationality *',
                  hint: 'United States',
                  prefixIcon: Icons.flag_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nationality is required' : null,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: AppConstants.spacingMd),

                CycloneTextField(
                  controller: _preferredLanguageController,
                  label: 'Preferred Language *',
                  hint: 'en',
                  prefixIcon: Icons.language,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Preferred language is required' : null,
                ).animate().fadeIn(delay: 250.ms),
                const SizedBox(height: AppConstants.spacingMd),

                CycloneTextField(
                  controller: _passportController,
                  label: 'Passport Number (Optional)',
                  hint: 'A1234567',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.text,
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: AppConstants.spacingXl),

                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    label: _submitting ? 'Saving…' : 'Continue',
                    onPressed: _submitting ? null : _submit,
                    isLoading: _submitting,
                    icon: Icons.arrow_forward_rounded,
                  ),
                ).animate().fadeIn(delay: 350.ms),

                const SizedBox(height: AppConstants.spacingLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

