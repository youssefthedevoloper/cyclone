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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    await ref.read(authProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      next.whenOrNull(
        authenticated: (_) => context.go('/home'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: Theme.of(context).textTheme.displayMedium,
                ).animate().fadeIn().slideX(begin: -0.1),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Join Cyclone for a smarter travel experience',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: AppConstants.spacingXl),
                Row(
                  children: [
                    Expanded(
                      child: CycloneTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        hint: 'John',
                        validator: (v) => Validators.required(v, 'First name'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: CycloneTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        hint: 'Doe',
                        validator: (v) => Validators.required(v, 'Last name'),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 150.ms),
                const SizedBox(height: AppConstants.spacingMd),
                CycloneTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'john@example.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: AppConstants.spacingMd),
                CycloneTextField(
                  controller: _phoneController,
                  label: 'Phone (Optional)',
                  hint: '+1 555 0123',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ).animate().fadeIn(delay: 250.ms),
                const SizedBox(height: AppConstants.spacingMd),
                CycloneTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Min. 8 characters',
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
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: AppConstants.spacingMd),
                CycloneTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirm,
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordController.text),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ).animate().fadeIn(delay: 350.ms),
                const SizedBox(height: AppConstants.spacingMd),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _acceptedTerms,
                        onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                        fillColor: WidgetStateProperty.all(AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingSm),
                    Expanded(
                      child: Text(
                        'I agree to the Terms of Service and Privacy Policy',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: AppConstants.spacingXl),
                GradientButton(
                  label: 'Create Account',
                  onPressed: _register,
                  isLoading: isLoading,
                ).animate().fadeIn(delay: 450.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
