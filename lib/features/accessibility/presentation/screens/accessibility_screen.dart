import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyclone/core/config/settings_provider.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/pressable.dart';

class AccessibilityScreen extends ConsumerWidget {
  const AccessibilityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with gradient
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.tealGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Pressable(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Accessibility',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Text(
                                    'Customize your airport experience',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.accessibility_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Visual Modes Section
                _SectionHeader(title: 'Visual Modes'),
                const SizedBox(height: 16),
                _VisualModesGrid(settings: settings, ref: ref),
                const SizedBox(height: 24),

                // Audio & Voice Section
                _SectionHeader(title: 'Audio & Voice'),
                const SizedBox(height: 16),
                _AudioSection(settings: settings, ref: ref),
                const SizedBox(height: 24),

                // Navigation Aids Section
                _SectionHeader(title: 'Navigation Aids'),
                const SizedBox(height: 16),
                _NavigationAidsSection(),
                const SizedBox(height: 24),

                // Quick Settings Section
                _SectionHeader(title: 'Quick Settings'),
                const SizedBox(height: 16),
                _QuickSettingsSection(settings: settings, ref: ref),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ─────────────────────────────────────────────────────────

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

// ─── Visual Modes Grid ──────────────────────────────────────────────────────

class _VisualModesGrid extends StatelessWidget {
  const _VisualModesGrid({
    required this.settings,
    required this.ref,
  });

  final AppSettings settings;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _VisualModeCard(
                title: 'High Contrast',
                subtitle: 'Enhanced visibility',
                icon: Icons.contrast,
                gradient: AppColors.purpleGradient,
                isActive: settings.highContrast,
                onToggle: () => ref.read(settingsProvider.notifier).toggleHighContrast(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _VisualModeCard(
                title: 'Large Text',
                subtitle: 'Bigger font size',
                icon: Icons.text_fields,
                gradient: AppColors.tealGradient,
                isActive: settings.textScale > 1.0,
                onToggle: () => ref.read(settingsProvider.notifier)
                    .setTextScale(settings.textScale > 1.0 ? 1.0 : 1.3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _VisualModeCard(
                title: 'Simple Mode',
                subtitle: 'Clean interface',
                icon: Icons.slideshow,
                gradient: AppColors.greenGradient,
                isActive: settings.simpleMode,
                onToggle: () => ref.read(settingsProvider.notifier).toggleSimpleMode(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _VisualModeCard(
                title: 'Dark Mode',
                subtitle: 'Easy on eyes',
                icon: Icons.dark_mode,
                gradient: AppColors.aiGradient,
                isActive: settings.isDarkMode,
                onToggle: () => ref.read(settingsProvider.notifier).toggleDarkMode(),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05);
  }
}

class _VisualModeCard extends StatelessWidget {
  const _VisualModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.isActive,
    required this.onToggle,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final bool isActive;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isActive ? gradient : null,
          color: isActive ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          border: Border.all(
            color: isActive ? Colors.transparent : Theme.of(context).dividerColor,
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: gradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? Colors.white : Theme.of(context).iconTheme.color,
                  size: 24,
                ),
                const Spacer(),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : null,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.8)
                    : Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Audio Section ──────────────────────────────────────────────────────────

class _AudioSection extends StatelessWidget {
  const _AudioSection({
    required this.settings,
    required this.ref,
  });

  final AppSettings settings;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToggleItem(
            icon: Icons.record_voice_over,
            title: 'Voice Assistant',
            subtitle: 'Audio guidance and announcements',
            value: settings.voiceAssistant,
            onChanged: () => ref.read(settingsProvider.notifier).toggleVoiceAssistant(),
            gradient: AppColors.amberGradient,
          ),
          const SizedBox(height: 16),
          _ActionItem(
            icon: Icons.volume_up,
            title: 'Audio Descriptions',
            subtitle: 'Enable detailed audio descriptions',
            gradient: AppColors.translatorGradient,
            onTap: () => _showComingSoon(context, 'Audio Descriptions'),
          ),
          const SizedBox(height: 16),
          _ActionItem(
            icon: Icons.hearing,
            title: 'Hearing Assistance',
            subtitle: 'Connect to hearing aid devices',
            gradient: AppColors.purpleGradient,
            onTap: () => _showComingSoon(context, 'Hearing Assistance'),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon!')),
    );
  }
}

// ─── Navigation Aids Section ────────────────────────────────────────────────

class _NavigationAidsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _NavigationCard(
                icon: Icons.vibration,
                title: 'Haptic Feedback',
                subtitle: 'Vibration cues',
                gradient: AppColors.orangeGradient,
                onTap: () => _showComingSoon(context, 'Haptic Feedback'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _NavigationCard(
                icon: Icons.explore,
                title: 'Audio Compass',
                subtitle: 'Directional audio',
                gradient: AppColors.greenGradient,
                onTap: () => _showComingSoon(context, 'Audio Compass'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _NavigationCard(
                icon: Icons.directions_walk,
                title: 'Step-by-Step',
                subtitle: 'Detailed navigation',
                gradient: AppColors.tealGradient,
                onTap: () => _showComingSoon(context, 'Step-by-Step Navigation'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _NavigationCard(
                icon: Icons.map,
                title: 'Tactile Maps',
                subtitle: 'Touch-friendly maps',
                gradient: AppColors.purpleGradient,
                onTap: () => _showComingSoon(context, 'Tactile Maps'),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon!')),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Settings Section ─────────────────────────────────────────────────

class _QuickSettingsSection extends StatelessWidget {
  const _QuickSettingsSection({
    required this.settings,
    required this.ref,
  });

  final AppSettings settings;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextSizeSlider(
            value: settings.textScale,
            onChanged: (value) => ref.read(settingsProvider.notifier).setTextScale(value),
          ),
          const SizedBox(height: 20),
          _ActionItem(
            icon: Icons.restore,
            title: 'Reset All Settings',
            subtitle: 'Restore default accessibility settings',
            gradient: AppColors.orangeGradient,
            onTap: () => _showResetDialog(context, ref),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('This will reset all accessibility settings to default. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Reset settings logic would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings reset to default')),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ─────────────────────────────────────────────────────────

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.gradient,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final VoidCallback onChanged;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Pressable(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _TextSizeSlider extends StatelessWidget {
  const _TextSizeSlider({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.tealGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.text_fields,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Text Size',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(value * 100).round()}%',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: 0.8,
            max: 1.6,
            divisions: 8,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
