import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/glass_container.dart';
import 'package:cyclone/widgets/gradient_button.dart';
import 'package:cyclone/widgets/pressable.dart';

final selectedTimeSlotProvider = StateProvider<String>((ref) => '');

class _LoungeInfo {
  const _LoungeInfo({required this.name, required this.location, required this.occupancy, required this.status, required this.rating});
  final String name;
  final String location;
  final int occupancy;
  final String status;
  final double rating;
}

class _AccessRule {
  const _AccessRule({required this.icon, required this.label, required this.description, required this.color});
  final IconData icon;
  final String label;
  final String description;
  final Color color;
}

class _Amenity {
  const _Amenity({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _LoungeCard {
  const _LoungeCard({required this.name, required this.terminal, required this.capacity, required this.occupied, required this.rating});
  final String name;
  final String terminal;
  final int capacity;
  final int occupied;
  final double rating;
}

class _TimeSlot {
  const _TimeSlot({required this.time, required this.available});
  final String time;
  final bool available;
}

const lounges = <_LoungeInfo>[
  _LoungeInfo(name: 'Sky Lounge Alpha', location: 'Terminal 3, Gate 12', occupancy: 68, status: 'Open', rating: 4.8),
];

const accessRules = <_AccessRule>[
  _AccessRule(icon: Icons.card_membership_outlined, label: 'Priority Pass', description: 'Valid Priority Pass members', color: Color(0xFF3B5BDB)),
  _AccessRule(icon: Icons.business_center_outlined, label: 'Business Class', description: 'Flying Business or First Class', color: Color(0xFF7950F2)),
  _AccessRule(icon: Icons.payment_outlined, label: 'Day Pass', description: 'Pay-per-entry available', color: Color(0xFFFD7E14)),
  _AccessRule(icon: Icons.star_outline_rounded, label: 'Membership', description: 'Annual lounge membership', color: Color(0xFF20C997)),
];

const amenities = <_Amenity>[
  _Amenity(icon: Icons.wifi_outlined, label: 'WiFi'),
  _Amenity(icon: Icons.shower_outlined, label: 'Showers'),
  _Amenity(icon: Icons.restaurant_menu_outlined, label: 'Food & Drinks'),
  _Amenity(icon: Icons.weekend_outlined, label: 'Lounge Chair'),
  _Amenity(icon: Icons.meeting_room_outlined, label: 'Meeting Room'),
  _Amenity(icon: Icons.spa_outlined, label: 'Spa'),
  _Amenity(icon: Icons.bed_outlined, label: 'Sleeping Pods'),
];

const availableLounges = <_LoungeCard>[
  _LoungeCard(name: 'Sky Lounge Alpha', terminal: 'T3', capacity: 120, occupied: 82, rating: 4.8),
  _LoungeCard(name: 'Delta Sky Club', terminal: 'T4', capacity: 90, occupied: 45, rating: 4.6),
  _LoungeCard(name: 'Plaza Premium', terminal: 'T2', capacity: 60, occupied: 18, rating: 4.4),
];

const timeSlots = <_TimeSlot>[
  _TimeSlot(time: '06:00', available: true), _TimeSlot(time: '07:00', available: false),
  _TimeSlot(time: '08:00', available: true), _TimeSlot(time: '09:00', available: true),
  _TimeSlot(time: '10:00', available: false), _TimeSlot(time: '11:00', available: true),
  _TimeSlot(time: '12:00', available: true), _TimeSlot(time: '13:00', available: false),
  _TimeSlot(time: '14:00', available: true), _TimeSlot(time: '15:00', available: true),
  _TimeSlot(time: '16:00', available: true), _TimeSlot(time: '17:00', available: false),
];

class LoungeScreen extends ConsumerWidget {
  const LoungeScreen({super.key});

  String _dateHint() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final today = DateFormat('MMM dd').format(now);
    final next = DateFormat('MMM dd').format(tomorrow);
    return '$today / $next';
  }

  Color _statusColor(String status) => switch (status) { 'Open' => AppColors.success, _ => AppColors.textTertiary };

  Color _capacityBarColor(int occupancy) {
    if (occupancy > 85) return AppColors.error;
    if (occupancy > 60) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedSlot = ref.watch(selectedTimeSlotProvider);
    final lounge = lounges.first;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 0, floating: true, snap: true,
              backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
              surfaceTintColor: Colors.transparent, elevation: 0,
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Pressable(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.border, width: 1),
                          ),
                          child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Lounge Access', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  GlassContainer(
                    padding: const EdgeInsets.all(18),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(lounge.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Row(children: [
                            Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Expanded(child: Text(lounge.location, style: Theme.of(context).textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ]),
                        ])),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: _statusColor(lounge.status).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100), border: Border.all(color: _statusColor(lounge.status).withValues(alpha: 0.25), width: 1)),
                          child: Text(lounge.status, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: _statusColor(lounge.status), fontWeight: FontWeight.w700)),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Occupancy', style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 4),
                          LayoutBuilder(builder: (context, constraints) => Row(children: [
                            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: lounge.occupancy / 100, minHeight: 6, backgroundColor: isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : AppColors.border.withValues(alpha: 0.3), valueColor: AlwaysStoppedAnimation(_capacityBarColor(lounge.occupancy))))),
                            const SizedBox(width: 8),
                            Text('${lounge.occupancy}%', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                          ])),
                        ])),
                        Row(children: [
                          Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(lounge.rating.toStringAsFixed(1), style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                        ]),
                      ]),
                    ]),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.06, curve: Curves.easeOut),
                  const SizedBox(height: AppConstants.spacingLg),
                  _SectionHeader(title: 'Access Rules', actionLabel: 'Details', onAction: () {}),
                  const SizedBox(height: AppConstants.spacingMd),
                  ...accessRules.map((rule) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: CycloneCard(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), child: Row(children: [
                      Container(width: 36, height: 36, decoration: BoxDecoration(color: rule.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)), child: Icon(rule.icon, size: 18, color: rule.color)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(rule.label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 1),
                        Text(rule.description, style: Theme.of(context).textTheme.bodySmall),
                      ])),
                    ])),
                  ).animate(delay: (60 * accessRules.indexOf(rule)).ms).fadeIn().slideX(begin: 0.04)),
                  const SizedBox(height: AppConstants.spacingLg),
                  _SectionHeader(title: 'Amenities', actionLabel: null, onAction: null),
                  const SizedBox(height: AppConstants.spacingMd),
                  Wrap(spacing: 10, runSpacing: 10, children: amenities.asMap().entries.map((e) {
                    final amenity = e.value;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: isDark ? AppColors.darkSurface : AppColors.surface, borderRadius: BorderRadius.circular(100), border: Border.all(color: isDark ? AppColors.darkBorder.withValues(alpha: 0.5) : AppColors.border.withValues(alpha: 0.6), width: 1)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(amenity.icon, size: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(amenity.label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 12)),
                      ]),
                    ).animate(delay: (40 * e.key).ms).fadeIn().scale(begin: const Offset(0.8, 0.8));
                  }).toList()),
                  const SizedBox(height: AppConstants.spacingLg),
                  _SectionHeader(title: 'Book Lounge Access', actionLabel: null, onAction: null),
                  const SizedBox(height: AppConstants.spacingMd),
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.calendar_today_outlined, size: 16, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                        const SizedBox(width: 8),
                        Text('Date: ${_dateHint()}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      ]),
                      const SizedBox(height: 12),
                      Text('Time Slots', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 8, children: timeSlots.map((slot) {
                        final isSelected = selectedSlot == slot.time;
                        final isAvailable = slot.available;
                        return Pressable(
                          onTap: isAvailable ? () { ref.read(selectedTimeSlotProvider.notifier).state = slot.time; } : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: isSelected ? AppColors.primary : isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : AppColors.border.withValues(alpha: 0.5), width: isSelected ? 1.5 : 1),
                            ),
                            child: Text(slot.time, style: (isDark ? Theme.of(context).textTheme.labelMedium : Theme.of(context).textTheme.labelMedium)?.copyWith(color: isSelected ? AppColors.primary : !isAvailable ? AppColors.textTertiary : null, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
                          ),
                        );
                      }).toList()),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          label: 'Book Lounge Access',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
                              backgroundColor: AppColors.darkBackground,
                              content: Row(children: [
                                Icon(Icons.check_circle_outline, color: AppColors.success, size: 22),
                                const SizedBox(width: 10),
                                Expanded(child: Text(selectedSlot.isNotEmpty ? 'Lounge booked for ${lounge.name} at $selectedSlot' : 'Please select a time slot', style: Theme.of(context).textTheme.bodyMedium)),
                              ]),
                            ));
                          },
                          icon: Icons.check_circle_outline,
                        ),
                      ),
                    ]),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: AppConstants.spacingLg),
                  _SectionHeader(title: 'Available Lounges', actionLabel: 'See All', onAction: () {}),
                  const SizedBox(height: AppConstants.spacingMd),
                  ...availableLounges.map((card) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CycloneCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(card.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 2),
                            Text('Terminal ${card.terminal}', style: Theme.of(context).textTheme.bodySmall),
                          ])),
                          Row(children: [
                            Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                            const SizedBox(width: 4),
                            Text(card.rating.toStringAsFixed(1), style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                          ]),
                        ]),
                        const SizedBox(height: 10),
                        Row(children: [
                          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: card.occupied / card.capacity, minHeight: 5, backgroundColor: isDark ? AppColors.darkBorder.withValues(alpha: 0.4) : AppColors.border.withValues(alpha: 0.3), valueColor: AlwaysStoppedAnimation(_capacityBarColor((card.occupied * 100) ~/ card.capacity))))),
                          const SizedBox(width: 8),
                          Text('${card.occupied}/${card.capacity}', style: Theme.of(context).textTheme.labelMedium),
                        ]),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Pressable(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
                                backgroundColor: AppColors.darkBackground,
                                content: Text('Viewing details for ${card.name}', style: Theme.of(context).textTheme.bodyMedium),
                              ));
                            },
                            child: Text('View Details', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ]),
                    ),
                  ).animate(delay: (70 * availableLounges.indexOf(card)).ms).fadeIn().slideX(begin: 0.04)),
                  const SizedBox(height: AppConstants.spacingLg),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis)),
        if (actionLabel != null && onAction != null)
          Pressable(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(actionLabel!, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ),
      ],
    );
  }
}
