import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/l10n/generated/app_localizations.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/flights')) return 1;
    if (location.startsWith('/airport')) return 2;
    if (location.startsWith('/services') ||
        location.startsWith('/assistant') ||
        location.startsWith('/assistant/translator') ||
        location.startsWith('/lost-and-found') ||
        location.startsWith('/notifications') ||
        location.startsWith('/accessibility') ||
        location.startsWith('/airport-support') ||
        location.startsWith('/promotions') ||
        location.startsWith('/lounge')) {
      return 3;
    }
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    HapticFeedback.selectionClick();
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/flights');
        break;
      case 2:
        context.go('/airport/map');
        break;
      case 3:
        context.go('/services');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: child,
      bottomNavigationBar: _AnimatedNavBar(
        currentIndex: currentIndex,
        onTap: (i) => _onTap(context, i),
        isDark: isDark,
      ),
    );
  }
}

class _AnimatedNavBar extends StatefulWidget {
  const _AnimatedNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.isDark,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  @override
  State<_AnimatedNavBar> createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<_AnimatedNavBar> {
  List<_NavDef> _items(BuildContext context) {
    final l = AppLocalizations.of(context);
    return [
      _NavDef(Icons.home_rounded, Icons.home_outlined, l.navHome),
      _NavDef(Icons.flight_rounded, Icons.flight_outlined, l.navFlights),
      _NavDef(Icons.map_rounded, Icons.map_outlined, l.navMap),
      _NavDef(Icons.grid_view_rounded, Icons.grid_view_outlined, l.navServices),
      _NavDef(Icons.person_rounded, Icons.person_outline_rounded, l.navProfile),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final barBg = isDark
        ? AppColors.darkSurface
        : AppColors.surface;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final items = _items(context);

    return Container(
      height: 64 + bottomPadding,
      decoration: BoxDecoration(
        color: barBg,
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.5)
                : AppColors.border.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = widget.currentIndex == i;
              return Expanded(
                child: _NavItem(
                  def: items[i],
                  isActive: isActive,
                  isDark: isDark,
                  onTap: () => widget.onTap(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.def,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final _NavDef def;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isActive ? 14 : 8,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) => ScaleTransition(
                  scale: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  isActive ? def.activeIcon : def.icon,
                  key: ValueKey(isActive),
                  color: isActive
                      ? AppColors.primary
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textTertiary),
                  size: 22,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                  color: isActive
                      ? AppColors.primary
                      : (isDark ? AppColors.darkTextSecondary : AppColors.textTertiary),
                  letterSpacing: isActive ? 0.2 : 0,
                ),
                child: Text(
                  def.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavDef {
  const _NavDef(this.activeIcon, this.icon, this.label);
  final IconData activeIcon;
  final IconData icon;
  final String label;
}
