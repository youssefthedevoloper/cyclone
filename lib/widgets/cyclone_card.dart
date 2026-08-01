import 'package:flutter/material.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/widgets/pressable.dart';

class CycloneCard extends StatelessWidget {
  const CycloneCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.gradient,
    this.color,
    this.borderRadius,
    this.elevation = 0,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  final double? borderRadius;
  final double elevation;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = color ?? (isDark ? AppColors.darkSurface : AppColors.surface);
    final radius = borderRadius ?? AppConstants.cardRadius;

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? cardColor : null,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1.5)
            : Border.all(
                color: isDark
                    ? AppColors.darkBorder.withValues(alpha: 0.5)
                    : AppColors.border.withValues(alpha: 0.6),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.primary.withValues(alpha: 0.06),
            blurRadius: elevation > 0 ? 32 : 16,
            spreadRadius: elevation > 0 ? 2 : 0,
            offset: const Offset(0, 6),
          ),
          if (!isDark)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.8),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppConstants.spacingLg),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return Pressable(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}
