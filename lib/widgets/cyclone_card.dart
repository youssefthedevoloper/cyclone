import 'package:flutter/material.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/constants/app_constants.dart';

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
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? color;
  final double? borderRadius;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = color ?? (isDark ? AppColors.darkSurface : AppColors.surface);

    Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? cardColor : null,
        borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.cardRadius),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.cardRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppConstants.spacingLg),
            child: child,
          ),
        ),
      ),
    );

    return card;
  }
}
