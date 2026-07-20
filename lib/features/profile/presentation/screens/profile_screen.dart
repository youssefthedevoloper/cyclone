import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/features/authentication/presentation/providers/auth_provider.dart';

import 'package:cyclone/core/config/router/routes.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.maybeWhen(
      authenticated: (user) => _ProfileBody(user: user, ref: ref),
      orElse: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user, required this.ref});

  final dynamic user;
  final WidgetRef ref;

  String _initialsFromName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'G';
    if (parts.length == 1) {
      final p = parts.first;
      return (p.isNotEmpty ? p[0] : 'G').toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            children: [
              const SizedBox(height: AppConstants.spacingMd),
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Text(
                  _initialsFromName((user.fullName ?? '').toString()),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate().scale(curve: Curves.easeOutBack),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                user.fullName,
                style: Theme.of(context).textTheme.headlineLarge,
              ).animate().fadeIn(delay: 100.ms),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ).animate().fadeIn(delay: 150.ms),
              const SizedBox(height: AppConstants.spacingXl),
              _ProfileSection(
                title: 'Traveler Information',
                items: [
                  _ProfileItem(Icons.email_outlined, 'Email', user.email),
                  if (user.phone != null)
                    _ProfileItem(Icons.phone_outlined, 'Phone', user.phone!),
                  if (user.nationality != null)
                    _ProfileItem(Icons.flag_outlined, 'Nationality', user.nationality!),
                  _ProfileItem(Icons.language, 'Language', user.preferredLanguage ?? 'English'),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              _ProfileSection(
                title: 'Documents',
                items: [
                  _ProfileItem(Icons.badge_outlined, 'Passport', user.passportNumber ?? 'Not added'),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMd),
              _ProfileSection(
                title: 'Achievements',
                items: const [],
                customChild: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _AchievementBadge(Icons.flight_takeoff, 'First Flight', true),
                    _AchievementBadge(Icons.explore, 'Explorer', true),
                    _AchievementBadge(Icons.star, 'Frequent Flyer', false),
                    _AchievementBadge(Icons.public, 'Globetrotter', false),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              const SizedBox(height: AppConstants.spacingMd),
              CycloneCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lost & Found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.05,
                      children: [
                        _ActionTile(
                          icon: Icons.report_problem_outlined,
                          title: 'Report Lost Item',
                          onTap: () => context.push(AppRoutes.lostAndFound),
                        ),
                        _ActionTile(
                          icon: Icons.inventory_2_outlined,
                          title: 'Found an Item',
                          onTap: () => context.push(AppRoutes.lostAndFound),
                        ),
                        _ActionTile(
                          icon: Icons.track_changes_outlined,
                          title: 'Track Request',
                          onTap: () => context.push(AppRoutes.lostAndFound),
                        ),
                        _ActionTile(
                          icon: Icons.qr_code_scanner_outlined,
                          title: 'Scan QR',
                          onTap: () => context.push(AppRoutes.lostAndFound),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              CycloneCard(
                onTap: () => context.push('/settings'),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.settings_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text('Settings', style: Theme.of(context).textTheme.titleMedium),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textTertiary),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout, color: AppColors.error),
                  label: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.title,
    required this.items,
    this.customChild,
  });

  final String title;
  final List<_ProfileItem> items;

  // NOTE: we keep this widget for Traveler info blocks.

  final Widget? customChild;

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (customChild != null) ...[
            const SizedBox(height: 16),
            customChild!,
          ] else ...[
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 20, color: AppColors.textTertiary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(item.label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            )),
                      ),
                      Text(item.value, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                )),
          ],
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
  }
}

class _ProfileItem {
  const _ProfileItem(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: CycloneCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}


class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge(this.icon, this.label, this.unlocked);

  final IconData icon;
  final String label;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: unlocked
                ? AppColors.warning.withValues(alpha: 0.15)
                : AppColors.border.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: unlocked ? AppColors.warning : AppColors.textTertiary,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: unlocked ? null : AppColors.textTertiary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
