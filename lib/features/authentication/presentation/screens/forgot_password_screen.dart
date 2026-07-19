import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/cyclone_text_field.dart';
import '../../../../widgets/gradient_button.dart';
import '../../data/models/auth_state.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).sendPasswordReset(
          _emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      next.whenOrNull(
        passwordResetSent: (_) => setState(() => _emailSent = true),
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: AppColors.error),
          );
        },
      );
    });

    final isLoading = ref.watch(authProvider).maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: _emailSent ? _buildSuccessView() : _buildFormView(isLoading),
        ),
      ),
    );
  }

  Widget _buildFormView(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.lock_reset, color: AppColors.primary, size: 32),
          ).animate().scale(curve: Curves.easeOutBack),
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.displayMedium,
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Enter your email and we\'ll send you a link to reset your password.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: AppConstants.spacingXl),
          CycloneTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ).animate().fadeIn(delay: 200.ms),
          const Spacer(),
          GradientButton(
            label: 'Send Reset Link',
            onPressed: _sendReset,
            isLoading: isLoading,
          ).animate().fadeIn(delay: 250.ms),
          const SizedBox(height: AppConstants.spacingLg),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mark_email_read_outlined, color: AppColors.success, size: 40),
        ).animate().scale(curve: Curves.easeOutBack),
        const SizedBox(height: AppConstants.spacingLg),
        Text(
          'Check your email',
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: AppConstants.spacingSm),
        Text(
          'We sent a password reset link to\n${_emailController.text}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: AppConstants.spacingXl),
        GradientButton(
          label: 'Back to Login',
          onPressed: () => context.go('/login'),
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }
}
