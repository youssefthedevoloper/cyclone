import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/utils/extensions.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/glass_container.dart';
import 'package:cyclone/widgets/shimmer_loading.dart';
import 'package:cyclone/features/authentication/presentation/providers/auth_provider.dart';
import 'package:cyclone/features/flight/data/models/flight_model.dart';
import 'package:cyclone/features/flight/presentation/providers/flight_provider.dart';
import 'package:cyclone/features/notifications/data/models/notification_model.dart';
import 'package:cyclone/features/notifications/presentation/providers/notifications_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final flightsAsync = ref.watch(upcomingFlightsProvider);
    final notificationsAsync = ref.watch(notificationsProvider);

    final userName = authState.maybeWhen(
      authenticated: (user) => user.firstName,
      orElse: () => 'Traveler',
    );

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(upcomingFlightsProvider);
            ref.invalidate(notificationsProvider);
          },
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, userName, ref),
                      const SizedBox(height: AppConstants.spacingLg),
                      flightsAsync.when(
                        data: (flights) => flights.isNotEmpty
                            ? _UpcomingFlightCard(flight: flights.first)
                            : const SizedBox.shrink(),
                        loading: () => const ShimmerCard(height: 180),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                      _QuickActions(),
                      const SizedBox(height: AppConstants.spacingLg),
                      SectionHeader(
                        title: 'Flight Status',
                        actionLabel: 'See All',
                        onAction: () => context.go('/flights'),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      flightsAsync.when(
                        data: (flights) => _FlightStatusList(flights: flights.take(2).toList()),
                        loading: () => Column(
                          children: List.generate(2, (_) => const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: ShimmerCard(height: 80),
                          )),
                        ),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                      _WeatherCard(),
                      const SizedBox(height: AppConstants.spacingLg),
                      SectionHeader(
                        title: 'Notifications',
                        actionLabel: 'View All',
                        onAction: () => context.push('/notifications'),
                      ),
                      const SizedBox(height: AppConstants.spacingMd),
                      notificationsAsync.when(
                        data: (notifications) =>
                            _NotificationPreview(notifications: notifications.take(3).toList()),
                        loading: () => const ShimmerCard(height: 100),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: AppConstants.spacingLg),
                      _TravelTips(),
                      const SizedBox(height: AppConstants.spacingXl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName, WidgetRef ref) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ).animate().fadeIn(),
              Text(
                userName,
                style: Theme.of(context).textTheme.displayMedium,
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.push('/notifications'),
          icon: Badge(
            smallSize: 8,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.notifications_outlined, size: 22),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => context.go('/profile'),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary,
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : 'T',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _UpcomingFlightCard extends StatelessWidget {
  const _UpcomingFlightCard({required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      gradient: AppColors.cardGradient,
      onTap: () => context.push('/flights/${flight.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.flightNumber,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  flight.statusLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AirportInfo(
                code: flight.departureAirport,
                city: flight.departureCity,
                time: flight.departureTime.timeFormatted,
              ),
              Column(
                children: [
                  Icon(Icons.flight, color: Colors.white.withValues(alpha: 0.7), size: 20),
                  const SizedBox(height: 4),
                  Text(
                    '${flight.duration.inHours}h ${flight.duration.inMinutes % 60}m',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
              _AirportInfo(
                code: flight.arrivalAirport,
                city: flight.arrivalCity,
                time: flight.arrivalTime.timeFormatted,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            children: [
              _InfoChip(icon: Icons.door_front_door, label: 'Gate ${flight.gate}'),
              const SizedBox(width: 12),
              _InfoChip(icon: Icons.event_seat, label: 'Seat ${flight.seat}'),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.white.withValues(alpha: 0.7), size: 16),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }
}

class _AirportInfo extends StatelessWidget {
  const _AirportInfo({
    required this.code,
    required this.city,
    required this.time,
    this.alignEnd = false,
  });

  final String code;
  final String city;
  final String time;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        Text(city, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
        Text(time, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(Icons.map_outlined, 'Airport Map', '/airport/map'),
      _ActionItem(Icons.qr_code, 'Boarding Pass', '/flights/fl_001/boarding-pass'),
      _ActionItem(Icons.restaurant, 'Dining', '/airport/map'),
      _ActionItem(Icons.support_agent, 'Help', '/profile'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => context.push(action.route),
              child: CycloneCard(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(action.icon, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action.label,
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(delay: 300.ms);
  }
}

class _ActionItem {
  const _ActionItem(this.icon, this.label, this.route);
  final IconData icon;
  final String label;
  final String route;
}

class _FlightStatusList extends StatelessWidget {
  const _FlightStatusList({required this.flights});

  final List<FlightModel> flights;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: flights.map((flight) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CycloneCard(
            onTap: () => context.push('/flights/${flight.id}'),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _statusColor(flight.status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.flight, color: _statusColor(flight.status), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(flight.flightNumber, style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        flight.route,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      flight.statusLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: _statusColor(flight.status),
                          ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(flight.departureTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _statusColor(FlightStatus status) => switch (status) {
        FlightStatus.boarding => AppColors.success,
        FlightStatus.delayed => AppColors.warning,
        FlightStatus.cancelled => AppColors.error,
        _ => AppColors.primary,
      };
}

class _WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.wb_sunny_rounded, color: AppColors.accent, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('JFK Airport Weather', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '72°F · Partly Cloudy · Light breeze',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            '72°',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _NotificationPreview extends StatelessWidget {
  const _NotificationPreview({required this.notifications});

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: notifications.map((n) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CycloneCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: n.isRead ? Colors.transparent : AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        n.message,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(n.timeAgo, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TravelTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.lightbulb_outline, color: AppColors.warning),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Travel Tip', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  'Arrive 2 hours before domestic flights. Keep liquids in a clear bag.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}
