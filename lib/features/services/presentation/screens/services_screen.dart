import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/config/router/routes.dart' as routes;
import 'package:cyclone/widgets/pressable.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppConstants.spacingLg, AppConstants.spacingMd, AppConstants.spacingLg, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Services', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5)).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 4),
                    Text('Premium tools for your journey.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary)).animate().fadeIn(delay: 100.ms),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
                child: _AiBanner(),
              ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.06),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
                child: Text('Quick Access', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              ).animate().fadeIn(delay: 200.ms),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppConstants.spacingLg, 0, AppConstants.spacingLg, AppConstants.spacingMd),
              sliver: SliverGrid.builder(
                itemCount: _standardServices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.05),
                itemBuilder: (context, i) => _ServiceCard(def: _standardServices[i], index: i),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppConstants.spacingLg, AppConstants.spacingXs, AppConstants.spacingLg, AppConstants.spacingSm),
                child: Text('AI Tools', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              ).animate().fadeIn(delay: 350.ms),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppConstants.spacingLg, 0, AppConstants.spacingLg, AppConstants.spacingLg),
              sliver: SliverGrid.builder(
                itemCount: _aiServices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.05),
                itemBuilder: (context, i) => _ServiceCard(def: _aiServices[i], index: i, isAi: true),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _AiBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: () => context.push('/assistant'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.aiGradient,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: [BoxShadow(color: AppColors.aiGradient.colors.first.withValues(alpha: 0.4), blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: Stack(
          children: [
            Positioned(top: -20, right: -10, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.07)))),
            Row(
              children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.2))), child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 26)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Cyclone AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: -0.3)),
                  const SizedBox(height: 3),
                  Text('Ask anything. Translate. Get help.', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                const SizedBox(width: 8),
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), shape: BoxShape.circle), child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.def, required this.index, this.isAi = false});
  final _ServiceDef def;
  final int index;
  final bool isAi;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Pressable(
      onTap: () => context.push(def.route),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.border, width: 1),
          boxShadow: [BoxShadow(color: def.gradient.colors.first.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: def.gradient, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: def.gradient.colors.first.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))]), child: Icon(def.icon, color: Colors.white, size: 22)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(def.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(def.subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
          ]),
        ]),
      ),
    ).animate(delay: (70 * index).ms).fadeIn().slideY(begin: 0.06);
  }
}

class _ServiceDef {
  const _ServiceDef(this.icon, this.title, this.subtitle, this.route, this.gradient);
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final LinearGradient gradient;
}

const _standardServices = [
  _ServiceDef(Icons.map_outlined, 'Airport Map', 'Navigate terminals & gates', '/airport/map', AppColors.primaryGradient),
  _ServiceDef(Icons.notifications_outlined, 'Notifications', 'Flight alerts & updates', '/notifications', AppColors.tealGradient),
  _ServiceDef(Icons.airline_seat_recline_normal_rounded, 'Lounge', 'Premium lounge access', '/lounge', AppColors.purpleGradient),
  _ServiceDef(Icons.local_taxi_rounded, 'Taxi & Rides', 'Book a ride to/from airport', '/taxi', AppColors.amberGradient),
  _ServiceDef(Icons.accessibility_new_outlined, 'Accessibility', 'Customize your experience', '/accessibility', AppColors.purpleGradient),
  _ServiceDef(Icons.support_agent_outlined, 'Airport Support', 'Help desk & quick topics', '/airport-support', AppColors.amberGradient),
  _ServiceDef(Icons.qr_code_scanner_outlined, 'Lost & Found', 'Report or claim items', '/lost-and-found', AppColors.greenGradient),
  _ServiceDef(Icons.local_offer_outlined, 'Promotions', 'Deals & QR coupons', '/promotions', AppColors.promotionsGradient),
];

const _aiServices = [
  _ServiceDef(Icons.auto_awesome_rounded, 'AI Assistant', 'Ask flight & travel questions', '/assistant', AppColors.aiGradient),
  _ServiceDef(Icons.translate_rounded, 'Translator', 'Real-time speech translation', routes.AppRoutes.translator, AppColors.translatorGradient),
];
