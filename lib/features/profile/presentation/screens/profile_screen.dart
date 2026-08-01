import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/pressable.dart';
import 'package:cyclone/features/authentication/presentation/providers/auth_provider.dart';
import 'package:cyclone/features/authentication/data/models/user_model.dart';
import 'package:cyclone/core/config/router/routes.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.maybeWhen(
      authenticated: (user) => _ProfileBody(user: user),
      orElse: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header with Gradient
          SliverAppBar(
            expandedHeight: 330,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      // Profile Avatar with Tier Ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.greenGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? AppColors.darkBackground : AppColors.background,
                              ),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: AppColors.primary,
                                backgroundImage: user.avatarUrl != null 
                                    ? NetworkImage(user.avatarUrl!) 
                                    : null,
                                child: user.avatarUrl == null
                                    ? Text(
                                        user.initials,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: AppColors.greenGradient,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.verified,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ).animate().scale(curve: Curves.easeOutBack),
                      const SizedBox(height: 16),
                      
                      // Name and Email
                      Text(
                        user.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ).animate().fadeIn(delay: 150.ms),
                      const SizedBox(height: 16),
                      
                      // Tier Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.diamond,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Silver Elite',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats Dashboard
                _StatsSection(),
                const SizedBox(height: AppConstants.spacingLg),

                // Tier Progress Card
                _TierProgressCard(),
                const SizedBox(height: AppConstants.spacingLg),

                // Quick Actions
                _SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: AppConstants.spacingMd),
                _QuickActionsGrid(),
                const SizedBox(height: AppConstants.spacingLg),

                // Travel Info
                _SectionHeader(title: 'Travel Information'),
                const SizedBox(height: AppConstants.spacingMd),
                _TravelInfoSection(user: user),
                const SizedBox(height: AppConstants.spacingLg),

                // Achievements
                _SectionHeader(title: 'Achievements'),
                const SizedBox(height: AppConstants.spacingMd),
                _AchievementsSection(),
                const SizedBox(height: AppConstants.spacingLg),

                // Settings & Sign Out
                _SettingsSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Dashboard ────────────────────────────────────────────────────────

class _StatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Flights',
            value: '24',
            subtitle: 'This Year',
            icon: Icons.flight_takeoff_outlined,
            gradient: AppColors.primaryGradient,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Miles',
            value: '48.2K',
            subtitle: 'Total',
            icon: Icons.public_outlined,
            gradient: AppColors.greenGradient,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Points',
            value: '1,250',
            subtitle: 'Available',
            icon: Icons.stars_outlined,
            gradient: AppColors.amberGradient,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05);
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tier Progress Card ─────────────────────────────────────────────────────

class _TierProgressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      padding: const EdgeInsets.all(20),
      gradient: AppColors.aiGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.diamond_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Silver Elite Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '750 points to Gold Elite',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '62%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.62,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1,250 points',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '2,000 needed',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.05);
  }
}

// ─── Section Headers ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ─── Quick Actions Grid ─────────────────────────────────────────────────────

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.qr_code_2_rounded,
            title: 'Boarding Pass',
            gradient: AppColors.greenGradient,
            onTap: () => context.push('/flights/fl_001/boarding-pass'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            icon: Icons.support_agent_outlined,
            title: 'Support',
            gradient: AppColors.purpleGradient,
            onTap: () => context.push(AppRoutes.airportSupport),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            icon: Icons.inventory_2_outlined,
            title: 'Lost & Found',
            gradient: AppColors.orangeGradient,
            onTap: () => context.push(AppRoutes.lostAndFound),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05);
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final LinearGradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Travel Info Section ───────────────────────────────────────────────────

class _TravelInfoSection extends StatelessWidget {
  const _TravelInfoSection({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCard(
          icon: Icons.email_outlined,
          title: 'Email',
          value: user.email,
          gradient: AppColors.tealGradient,
        ),
        const SizedBox(height: 8),
        if (user.phone != null)
          _InfoCard(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: user.phone!,
            gradient: AppColors.translatorGradient,
          ),
        if (user.phone != null) const SizedBox(height: 8),
        _InfoCard(
          icon: Icons.language_outlined,
          title: 'Language',
          value: user.preferredLanguage ?? 'English',
          gradient: AppColors.purpleGradient,
        ),
        const SizedBox(height: 8),
        if (user.nationality != null)
          _InfoCard(
            icon: Icons.flag_outlined,
            title: 'Nationality',
            value: user.nationality!,
            gradient: AppColors.promotionsGradient,
          ),
        if (user.nationality != null) const SizedBox(height: 8),
        _InfoCard(
          icon: Icons.badge_outlined,
          title: 'Passport',
          value: user.passportNumber ?? 'Not added',
          gradient: AppColors.orangeGradient,
          isPlaceholder: user.passportNumber == null,
        ),
      ],
    ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.05);
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.gradient,
    this.isPlaceholder = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final LinearGradient gradient;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CycloneCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: isPlaceholder ? null : gradient,
              color: isPlaceholder
                  ? (isDark ? AppColors.darkBorder : AppColors.border)
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isPlaceholder
                  ? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)
                  : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isPlaceholder
                        ? (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)
                        : null,
                  ),
                ),
              ],
            ),
          ),
          if (!isPlaceholder)
            Icon(
              Icons.verified,
              color: AppColors.success,
              size: 16,
            ),
        ],
      ),
    );
  }
}

// ─── Achievements Section ───────────────────────────────────────────────────

class _AchievementsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _AchievementBadge(
            icon: Icons.flight_takeoff,
            label: 'First Flight',
            unlocked: true,
          ),
        ),
        Expanded(
          child: _AchievementBadge(
            icon: Icons.explore,
            label: 'Explorer',
            unlocked: true,
          ),
        ),
        Expanded(
          child: _AchievementBadge(
            icon: Icons.star,
            label: 'Frequent Flyer',
            unlocked: true,
          ),
        ),
        Expanded(
          child: _AchievementBadge(
            icon: Icons.public,
            label: 'Globetrotter',
            unlocked: false,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.05);
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({
    required this.icon,
    required this.label,
    required this.unlocked,
  });

  final IconData icon;
  final String label;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: unlocked ? AppColors.amberGradient : null,
            color: !unlocked
                ? (isDark ? AppColors.darkBorder : AppColors.border)
                : null,
            shape: BoxShape.circle,
            boxShadow: unlocked
                ? [
                    BoxShadow(
                      color: AppColors.warning.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: unlocked
                ? Colors.white
                : (isDark ? AppColors.darkTextSecondary : AppColors.textTertiary),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: unlocked
                ? null
                : (isDark ? AppColors.darkTextSecondary : AppColors.textTertiary),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Settings Section ───────────────────────────────────────────────────────

class _SettingsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        CycloneCard(
          onTap: () => context.push('/settings'),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings & Preferences',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Manage your account and app settings',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
                size: 20,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 550.ms),
        const SizedBox(height: 12),
        
        // Sign Out Button
        Pressable(
          onTap: () => _showSignOutDialog(context, ref),
          child: CycloneCard(
            padding: const EdgeInsets.all(16),
            borderColor: AppColors.error.withValues(alpha: 0.3),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout_outlined,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Sign Out',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.error.withValues(alpha: 0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out of your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/login');
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
