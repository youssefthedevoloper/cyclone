import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyclone/core/config/settings_provider.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        children: [
          _SettingsSection(
            title: 'Appearance',
            children: [
              _SettingsToggle(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Switch to dark theme',
                value: settings.isDarkMode,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleDarkMode(),
              ),
              _SettingsToggle(
                icon: Icons.contrast,
                title: 'High Contrast',
                subtitle: 'Increase visual contrast',
                value: settings.highContrast,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleHighContrast(),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _SettingsSection(
            title: 'Accessibility',
            children: [
              _SettingsSlider(
                icon: Icons.text_fields,
                title: 'Text Size',
                value: settings.textScale,
                min: 0.8,
                max: 1.6,
                divisions: 8,
                label: '${(settings.textScale * 100).round()}%',
                onChanged: (v) => ref.read(settingsProvider.notifier).setTextScale(v),
              ),
              _SettingsToggle(
                icon: Icons.accessibility_new,
                title: 'Simple Mode',
                subtitle: 'Simplified interface for easier use',
                value: settings.simpleMode,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleSimpleMode(),
              ),
              _SettingsToggle(
                icon: Icons.record_voice_over,
                title: 'Voice Assistant',
                subtitle: 'Enable voice guidance',
                value: settings.voiceAssistant,
                onChanged: (_) => ref.read(settingsProvider.notifier).toggleVoiceAssistant(),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _SettingsSection(
            title: 'Language',
            children: [
              _SettingsDropdown(
                icon: Icons.language,
                title: 'App Language',
                value: settings.language,
                items: const {
                  'en': 'English',
                  'ar': 'Arabic',
                  'fr': 'French',
                  'es': 'Spanish',
                  'de': 'German',
                },
                onChanged: (v) {
                  if (v != null) ref.read(settingsProvider.notifier).setLanguage(v);
                },
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _SettingsSection(
            title: 'Permissions',
            children: [
              _SettingsTile(
                icon: Icons.location_on_outlined,
                title: 'Location',
                subtitle: 'Required for indoor navigation',
                trailing: const Icon(Icons.check_circle, color: AppColors.success, size: 20),
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Flight alerts and updates',
                trailing: const Icon(Icons.check_circle, color: AppColors.success, size: 20),
              ),
              _SettingsTile(
                icon: Icons.fingerprint,
                title: 'Biometric Login',
                subtitle: 'Use fingerprint or face ID',
                trailing: const Switch(
                  value: true,
                  onChanged: null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _SettingsSection(
            title: 'About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        CycloneCard(
          padding: EdgeInsets.zero,
          child: Column(children: children),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.05);
  }
}

class _SettingsToggle extends StatelessWidget {
  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class _SettingsSlider extends StatelessWidget {
  const _SettingsSlider({
    required this.icon,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: AppColors.textTertiary),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
              Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                  )),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsDropdown extends StatelessWidget {
  const _SettingsDropdown({
    required this.icon,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String value;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textTertiary),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox.shrink(),
            items: items.entries
                .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Icon(icon, size: 22, color: AppColors.textTertiary),
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (subtitle != null)
              Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    ];

    if (trailing != null) {
      children.add(trailing!);
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: children),
      ),
    );
  }
}
