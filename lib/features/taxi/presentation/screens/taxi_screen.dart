import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/glass_container.dart';
import 'package:cyclone/widgets/gradient_button.dart';
import 'package:cyclone/widgets/pressable.dart';

class _RideOption {
  final String name, eta, price;
  final IconData icon;
  final Color color;
  final int capacity;

  const _RideOption({required this.name, required this.eta, required this.price, required this.icon, required this.color, this.capacity = 4});
}

const _rideOptions = [
  _RideOption(name: 'Standard', eta: '5 min', price: r'$25-35', icon: Icons.directions_car_rounded, color: Color(0xFF3B5BDB), capacity: 4),
  _RideOption(name: 'Premium', eta: '3 min', price: r'$45-60', icon: Icons.directions_car_filled_rounded, color: Color(0xFF7950F2), capacity: 4),
  _RideOption(name: 'SUV', eta: '7 min', price: r'$55-75', icon: Icons.directions_car_filled_outlined, color: Color(0xFFFD7E14), capacity: 6),
  _RideOption(name: 'Economy', eta: '8 min', price: r'$18-25', icon: Icons.electric_car_rounded, color: Color(0xFF20C997), capacity: 4),
];

class TaxiScreen extends ConsumerWidget {
  const TaxiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 0, floating: true, snap: true,
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
              surfaceTintColor: Colors.transparent, elevation: 0,
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Taxi & Rides', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _LocationSelector(isDark: isDark),
                  const SizedBox(height: 20),
                  _RideOptionsGrid(isDark: isDark),
                  const SizedBox(height: 24),
                  _BookingCard(isDark: isDark),
                  const SizedBox(height: 24),
                  _ActiveRideCard(isDark: isDark),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  final bool isDark;
  const _LocationSelector({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Row(children: [
          Column(children: [
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
            Container(width: 2, height: 30, color: isDark ? AppColors.darkBorder : AppColors.border),
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
          ]),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('JFK Airport', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text('Terminal 4, Arrivals Gate B', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Text('Downtown Manhattan', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text('345 Broadway, NY 10013', style: Theme.of(context).textTheme.bodySmall),
          ])),
          const Icon(Icons.swap_vert_rounded, color: AppColors.primary, size: 24),
        ]),
      ]),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06);
  }
}

class _RideOptionsGrid extends StatelessWidget {
  final bool isDark;
  const _RideOptionsGrid({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SectionHeader(title: 'Choose Ride', actionLabel: null, onAction: null),
      const SizedBox(height: 12),
      GridView.count(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.1,
        children: List.generate(_rideOptions.length, (i) {
          final option = _rideOptions[i];
          return Pressable(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.border, width: 1),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: option.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Icon(option.icon, color: option.color, size: 22),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomCenter,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(option.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('${option.eta} · ${option.capacity} seats', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
                    Text(option.price, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.primary)),
                  ]),
                ),
              ]),
            ),
          );
        }),
      ),
    ]);
  }
}

class _BookingCard extends StatelessWidget {
  final bool isDark;
  const _BookingCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Book a Ride', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _InputField(label: 'Pickup Time', value: 'Now', icon: Icons.schedule_rounded, isDark: isDark)),
          const SizedBox(width: 12),
          Expanded(child: _InputField(label: 'Passengers', value: '1 Adult', icon: Icons.people_outlined, isDark: isDark)),
        ]),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: GradientButton(
          label: 'Request Ride',
          icon: Icons.arrow_forward_rounded,
          onPressed: () {},
        )),
      ]),
    ).animate().fadeIn(delay: 200.ms);
  }
}

class _InputField extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final bool isDark;
  const _InputField({required this.label, required this.value, required this.icon, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : AppColors.border.withValues(alpha: 0.6), width: 1),
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 10)),
          Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ]),
    );
  }
}

class _ActiveRideCard extends StatelessWidget {
  final bool isDark;
  const _ActiveRideCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.greenGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.success.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.taxi_alert_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text('Active Ride', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
            child: const Text('ETA 5 min', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 12),
        const Text('Toyota Camry · ABC 1234', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('Michael - Your driver is waiting at Gate B22', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
      ]),
    ).animate().fadeIn(delay: 300.ms);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      if (actionLabel != null && onAction != null)
        Pressable(onTap: onAction, child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
          child: Text(actionLabel!, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
        )),
    ]);
  }
}
