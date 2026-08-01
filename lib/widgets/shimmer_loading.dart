import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/theme/app_colors.dart';
import '../core/constants/app_constants.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurfaceVariant : AppColors.border,
      highlightColor: isDark
          ? AppColors.darkBorder.withValues(alpha: 0.5)
          : AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.height = 120});

  final double height;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurfaceVariant : AppColors.border,
      highlightColor: isDark
          ? AppColors.darkBorder.withValues(alpha: 0.5)
          : AppColors.surface,
      child: Container(
        height: height,
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 14,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Boarding-pass shaped shimmer skeleton
class ShimmerBoardingPass extends StatelessWidget {
  const ShimmerBoardingPass({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFDEE8FF),
      highlightColor: isDark
          ? AppColors.darkBorder.withValues(alpha: 0.5)
          : Colors.white,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(80, 14),
                _box(70, 22),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _col([_box(60, 36), _box(80, 12)]),
                _box(30, 20),
                _col([_box(60, 36), _box(80, 12)]),
              ],
            ),
            const SizedBox(height: 20),
            Row(children: [_box(70, 26), const SizedBox(width: 8), _box(70, 26)]),
          ],
        ),
      ),
    );
  }

  Widget _box(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      );

  Widget _col(List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .expand((e) => [e, const SizedBox(height: 8)])
            .toList()
          ..removeLast(),
      );
}

/// Shimmer for a flight list tile
class ShimmerFlightTile extends StatelessWidget {
  const ShimmerFlightTile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurfaceVariant : AppColors.border,
      highlightColor: isDark
          ? AppColors.darkBorder.withValues(alpha: 0.5)
          : AppColors.surface,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(100, 14),
                _box(70, 22),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _col([_box(54, 28), _box(60, 12)]),
                _box(20, 20),
                _col([_box(54, 28), _box(60, 12)]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(double w, double h) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      );

  Widget _col(List<Widget> children) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .expand((e) => [e, const SizedBox(height: 6)])
            .toList()
          ..removeLast(),
      );
}
