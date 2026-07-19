import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/cyclone_text_field.dart';
import '../../../../widgets/gradient_button.dart';
import '../../data/models/auth_state.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@cyclone.app');
  final _passwordController = TextEditingController(text: 'password123');
  bool _obscurePassword = true;
  bool _rememberMe = false;
  final _localAuth = LocalAuthentication();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );
  }

  Future<void> _biometricLogin() async {
    try {
      final canAuth = await _localAuth.canCheckBiometrics;
      if (!canAuth) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biometric authentication not available')),
          );
        }
        return;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Cyclone',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (authenticated) {
        final success = await ref.read(authProvider.notifier).authenticateWithBiometric();
        if (!success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No saved session found. Please login first.')),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      next.whenOrNull(
        authenticated: (_) => context.go('/home'),
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      );
    });

    final authState = ref.watch(authProvider);
    final isLoading = authState.maybeWhen(loading: () => true, orElse: () => false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.spacingXl),
                Center(
                  child: Image.asset(
                    AppAssets.logo,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: AppConstants.spacing2xl),
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.displayMedium,
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Sign in to continue your journey',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
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
                  textInputAction: TextInputAction.next,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                const SizedBox(height: AppConstants.spacingMd),
                CycloneTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  validator: Validators.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),
                const SizedBox(height: AppConstants.spacingMd),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        fillColor: WidgetStateProperty.all(AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Text('Remember me', style: Theme.of(context).textTheme.bodyMedium),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: AppConstants.spacingLg),
                GradientButton(
                  label: 'Sign In',
                  onPressed: _login,
                  isLoading: isLoading,
                ).animate().fadeIn(delay: 350.ms),
                const SizedBox(height: AppConstants.spacingMd),
                Center(
                  child: IconButton(
                    onPressed: _biometricLogin,
                    icon: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.fingerprint, size: 32, color: AppColors.primary),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: AppConstants.spacingLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/register'),
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 450.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
