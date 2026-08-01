import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyclone/core/config/settings_provider.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/l10n/generated/app_localizations.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/pressable.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<_SettingsGroup> _buildGroups(AppLocalizations l) => [
    _SettingsGroup(
      title: l.settingsGroupAppearance,
      icon: Icons.palette_outlined,
      gradient: AppColors.purpleGradient,
      items: [
        _SettingsItem(
          type: _SettingsType.toggle,
          icon: Icons.dark_mode_outlined,
          title: l.settingDarkMode,
          subtitle: l.settingDarkModeDesc,
          key: 'darkMode',
        ),
        _SettingsItem(
          type: _SettingsType.toggle,
          icon: Icons.contrast_outlined,
          title: l.settingHighContrast,
          subtitle: l.settingHighContrastDesc,
          key: 'highContrast',
        ),
      ],
    ),
    _SettingsGroup(
      title: l.settingsGroupAccessibility,
      icon: Icons.accessibility_new_outlined,
      gradient: AppColors.tealGradient,
      items: [
        _SettingsItem(
          type: _SettingsType.slider,
          icon: Icons.text_fields_outlined,
          title: l.settingTextSize,
          subtitle: l.settingTextSizeDesc,
          key: 'textScale',
        ),
        _SettingsItem(
          type: _SettingsType.toggle,
          icon: Icons.accessibility_outlined,
          title: l.settingSimpleMode,
          subtitle: l.settingSimpleModeDesc,
          key: 'simpleMode',
        ),
        _SettingsItem(
          type: _SettingsType.toggle,
          icon: Icons.record_voice_over_outlined,
          title: l.settingVoiceAssistant,
          subtitle: l.settingVoiceAssistantDesc,
          key: 'voiceAssistant',
        ),
      ],
    ),
    _SettingsGroup(
      title: l.settingsGroupLanguage,
      icon: Icons.language_outlined,
      gradient: AppColors.translatorGradient,
      items: [
        _SettingsItem(
          type: _SettingsType.dropdown,
          icon: Icons.translate_outlined,
          title: l.settingAppLanguage,
          subtitle: l.settingAppLanguageDesc,
          key: 'language',
        ),
      ],
    ),
    _SettingsGroup(
      title: l.settingsGroupSecurity,
      icon: Icons.security_outlined,
      gradient: AppColors.orangeGradient,
      items: [
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.fingerprint_outlined,
          title: l.settingBiometricLogin,
          subtitle: l.settingBiometricLoginDesc,
          key: 'biometric',
        ),
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.location_on_outlined,
          title: l.settingLocationServices,
          subtitle: l.settingLocationServicesDesc,
          key: 'location',
          status: _PermissionStatus.granted,
        ),
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.notifications_outlined,
          title: l.settingNotifications,
          subtitle: l.settingNotificationsDesc,
          key: 'notifications',
          status: _PermissionStatus.granted,
        ),
      ],
    ),
    _SettingsGroup(
      title: l.settingsGroupData,
      icon: Icons.storage_outlined,
      gradient: AppColors.greenGradient,
      items: [
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.cloud_sync_outlined,
          title: l.settingSyncSettings,
          subtitle: l.settingSyncSettingsDesc,
          key: 'sync',
        ),
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.delete_outline,
          title: l.settingClearCache,
          subtitle: l.settingClearCacheDesc,
          key: 'clearCache',
        ),
      ],
    ),
    _SettingsGroup(
      title: l.settingsGroupSupport,
      icon: Icons.help_outline,
      gradient: AppColors.amberGradient,
      items: [
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.info_outline,
          title: l.settingAppVersion,
          subtitle: l.settingAppVersionDesc,
          key: 'version',
        ),
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.privacy_tip_outlined,
          title: l.settingPrivacyPolicy,
          subtitle: l.settingPrivacyPolicyDesc,
          key: 'privacy',
        ),
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.description_outlined,
          title: l.settingTermsOfService,
          subtitle: l.settingTermsOfServiceDesc,
          key: 'terms',
        ),
        _SettingsItem(
          type: _SettingsType.navigation,
          icon: Icons.support_agent_outlined,
          title: l.settingContactSupport,
          subtitle: l.settingContactSupportDesc,
          key: 'support',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_SettingsGroup> _filteredGroups(List<_SettingsGroup> allGroups) {
    if (_searchQuery.isEmpty) return allGroups;

    return allGroups
        .map((group) {
          final filteredItems = group.items.where((item) {
            return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   item.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                   group.title.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          return filteredItems.isNotEmpty
              ? _SettingsGroup(
                  title: group.title,
                  icon: group.icon,
                  gradient: group.gradient,
                  items: filteredItems,
                )
              : null;
        })
        .where((group) => group != null)
        .cast<_SettingsGroup>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allGroups = _buildGroups(l);
    final filteredGroups = _filteredGroups(allGroups);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Search
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: const EdgeInsets.only(bottom: 60),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
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
                              child: Text(
                                l.settingsTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: l.settingsSearchHint,
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              icon: Icon(
                                Icons.clear,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Settings Content
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= filteredGroups.length) return null;
                  
                  final group = filteredGroups[index];
                  return Column(
                    children: [
                      if (index > 0) const SizedBox(height: 24),
                      _SettingsGroupWidget(
                        group: group,
                        settings: settings,
                        onSettingChanged: (key, value) => _handleSettingChange(key, value, ref),
                      ).animate(delay: (100 * index).ms).fadeIn().slideY(begin: 0.05),
                    ],
                  );
                },
                childCount: filteredGroups.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSettingChange(String key, dynamic value, WidgetRef ref) {
    switch (key) {
      case 'darkMode':
        ref.read(settingsProvider.notifier).toggleDarkMode();
        break;
      case 'highContrast':
        ref.read(settingsProvider.notifier).toggleHighContrast();
        break;
      case 'textScale':
        ref.read(settingsProvider.notifier).setTextScale(value as double);
        break;
      case 'simpleMode':
        ref.read(settingsProvider.notifier).toggleSimpleMode();
        break;
      case 'voiceAssistant':
        ref.read(settingsProvider.notifier).toggleVoiceAssistant();
        break;
      case 'language':
        ref.read(settingsProvider.notifier).setLanguage(value as String);
        break;
      case 'clearCache':
        _showClearCacheDialog();
        break;
      default:
        // Handle navigation items
        _handleNavigation(key);
        break;
    }
  }

  void _handleNavigation(String key) {
    switch (key) {
      case 'biometric':
        // Navigate to biometric settings
        break;
      case 'location':
        // Navigate to location permissions
        break;
      case 'notifications':
        // Navigate to notification settings
        break;
      case 'sync':
        // Navigate to sync settings
        break;
      case 'privacy':
        // Open privacy policy
        break;
      case 'terms':
        // Open terms of service
        break;
      case 'support':
        // Navigate to support screen
        break;
    }
  }

  void _showClearCacheDialog() {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.settingsClearCacheTitle),
          content: Text(l.settingsClearCacheBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.commonCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement cache clearing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l.settingsCacheCleared)),
                );
              },
              child: Text(l.commonClear),
            ),
          ],
        );
      },
    );
  }
}

// ─── Settings Group Widget ──────────────────────────────────────────────────

class _SettingsGroupWidget extends StatelessWidget {
  const _SettingsGroupWidget({
    required this.group,
    required this.settings,
    required this.onSettingChanged,
  });

  final _SettingsGroup group;
  final AppSettings settings;
  final Function(String, dynamic) onSettingChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: group.gradient,
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            boxShadow: [
              BoxShadow(
                color: group.gradient.colors.first.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                group.icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  group.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Group Items
        CycloneCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: group.items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _SettingsItemWidget(
                    item: item,
                    settings: settings,
                    onChanged: (value) => onSettingChanged(item.key, value),
                  ),
                  if (index < group.items.length - 1)
                    Divider(
                      height: 1,
                      indent: 56,
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── Settings Item Widget ───────────────────────────────────────────────────

class _SettingsItemWidget extends StatelessWidget {
  const _SettingsItemWidget({
    required this.item,
    required this.settings,
    required this.onChanged,
  });

  final _SettingsItem item;
  final AppSettings settings;
  final Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    late final Widget trailing;
    VoidCallback? onTap;

    switch (item.type) {
      case _SettingsType.toggle:
        trailing = Switch(
          value: _getBoolValue(),
          onChanged: (value) => onChanged(value),
        );
        break;
      case _SettingsType.dropdown:
        trailing = _LanguageDropdown(
          value: settings.language,
          onChanged: onChanged,
        );
        break;
      case _SettingsType.navigation:
        if (item.status != null) {
          trailing = Icon(
            item.status == _PermissionStatus.granted
                ? Icons.check_circle
                : Icons.warning_amber_rounded,
            color: item.status == _PermissionStatus.granted
                ? AppColors.success
                : AppColors.warning,
            size: 20,
          );
        } else {
          trailing = Icon(
            Icons.chevron_right,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          );
        }
        onTap = () => onChanged(null);
        break;
      case _SettingsType.slider:
        // Slider is handled differently
        return _SliderSettingWidget(
          item: item,
          value: settings.textScale,
          onChanged: onChanged,
        );
    }

    return Pressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }

  bool _getBoolValue() {
    switch (item.key) {
      case 'darkMode':
        return settings.isDarkMode;
      case 'highContrast':
        return settings.highContrast;
      case 'simpleMode':
        return settings.simpleMode;
      case 'voiceAssistant':
        return settings.voiceAssistant;
      default:
        return false;
    }
  }
}
// ─── Slider Setting Widget ──────────────────────────────────────────────────

class _SliderSettingWidget extends StatelessWidget {
  const _SliderSettingWidget({
    required this.item,
    required this.value,
    required this.onChanged,
  });

  final _SettingsItem item;
  final double value;
  final Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value,
              min: 0.8,
              max: 1.6,
              divisions: 8,
              onChanged: (newValue) => onChanged(newValue),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Language Dropdown ──────────────────────────────────────────────────────

class _LanguageDropdown extends StatelessWidget {
  const _LanguageDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final Function(dynamic) onChanged;

  static const Map<String, String> _languages = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
    'es': 'Español',
    'de': 'Deutsch',
  };

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      underline: const SizedBox.shrink(),
      items: _languages.entries
          .map((e) => DropdownMenuItem(
                value: e.key,
                child: Text(e.value),
              ))
          .toList(),
      onChanged: (newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}

// ─── Data Models ────────────────────────────────────────────────────────────

enum _SettingsType {
  toggle,
  slider,
  dropdown,
  navigation,
}

enum _PermissionStatus {
  granted,
}

class _SettingsGroup {
  const _SettingsGroup({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.items,
  });

  final String title;
  final IconData icon;
  final LinearGradient gradient;
  final List<_SettingsItem> items;
}

class _SettingsItem {
  const _SettingsItem({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.key,
    this.status,
  });

  final _SettingsType type;
  final IconData icon;
  final String title;
  final String subtitle;
  final String key;
  final _PermissionStatus? status;
}
