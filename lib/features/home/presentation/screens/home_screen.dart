import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/utils/extensions.dart';
import 'package:cyclone/l10n/generated/app_localizations.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/glass_container.dart';
import 'package:cyclone/widgets/pressable.dart';
import 'package:cyclone/widgets/shimmer_loading.dart';
import 'package:cyclone/widgets/status_badge.dart';
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
      orElse: () => AppLocalizations.of(context).homeTraveler,
    );

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(upcomingFlightsProvider);
          ref.invalidate(notificationsProvider);
        },
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            _HomeAppBar(userName: userName),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // ── Upcoming Flight Card ──
                  flightsAsync.when(
                    data: (flights) => flights.isNotEmpty
                        ? _UpcomingFlightCard(flight: flights.first)
                        : const SizedBox.shrink(),
                    loading: () => const ShimmerBoardingPass(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Quick Actions ──
                  _QuickActions(),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Flight Status ──
                  _SectionHeader(
                    title: AppLocalizations.of(context).homeFlightStatus,
                    actionLabel: AppLocalizations.of(context).homeSeeAll,
                    onAction: () => context.go('/flights'),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  flightsAsync.when(
                    data: (flights) =>
                        _FlightStatusList(flights: flights.take(2).toList()),
                    loading: () => Column(
                      children: List.generate(
                          2,
                          (_) => const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: ShimmerFlightTile())),
                    ),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Weather ──
                  _WeatherCard(),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Notifications ──
                  _SectionHeader(
                    title: AppLocalizations.of(context).homeNotifications,
                    actionLabel: AppLocalizations.of(context).homeViewAll,
                    onAction: () => context.push('/notifications'),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  notificationsAsync.when(
                    data: (notifs) => _NotificationPreview(
                        notifications: notifs.take(3).toList()),
                    loading: () => const ShimmerCard(height: 100),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Travel Tips Carousel ──
                  _TravelTipsCarousel(),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Quick Currency Converter ──
                  const _QuickCurrencyConverter(),
                  const SizedBox(height: AppConstants.spacingLg),

                  // ── Emergency Contacts ──
                  _EmergencyContacts(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── App Bar ──────────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l.homeGoodMorning
        : hour < 17
            ? l.homeGoodAfternoon
            : l.homeGoodEvening;

    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      snap: true,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: isDark ? AppColors.darkBackground : AppColors.background,
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$greeting,',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                    ).animate().fadeIn(duration: 400.ms),
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.04),
                  ],
                ),
              ),
              Pressable(
                onTap: () => context.push('/notifications'),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder.withValues(alpha: 0.5)
                          : AppColors.border,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Badge(
                    smallSize: 8,
                    backgroundColor: AppColors.error,
                    child: Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(width: 8),
              Pressable(
                onTap: () => context.go('/profile'),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: CircleAvatar(
                    radius: 19,
                    backgroundColor:
                        isDark ? AppColors.darkBackground : AppColors.background,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'T',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 250.ms),
            ],
          ),
        ),
      ),
      ),
    ),
    );
  }
}

// ─── Upcoming Flight Card (Boarding Pass Style) ───────────────────────────────

class _UpcomingFlightCard extends StatelessWidget {
  const _UpcomingFlightCard({required this.flight});
  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Pressable(
      onTap: () => context.push('/flights/${flight.id}'),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.homeUpcomingFlight,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              flight.flightNumber,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(status: flight.status, large: true),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Route row
                  Row(
                    children: [
                      // Departure
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                flight.departureAirport,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                            Text(
                              flight.departureCity,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              flight.departureTime.timeFormatted,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Plane icon & duration
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Icon(
                              Icons.flight,
                              color: Colors.white.withValues(alpha: 0.85),
                              size: 24,
                            )
                                .animate(onPlay: (c) => c.repeat())
                                .then(delay: 2.seconds)
                                .moveX(
                                    begin: -3,
                                    end: 3,
                                    duration: 1.5.seconds,
                                    curve: Curves.easeInOut)
                                .then()
                                .moveX(
                                    begin: 3,
                                    end: -3,
                                    duration: 1.5.seconds,
                                    curve: Curves.easeInOut),
                            const SizedBox(height: 4),
                            Text(
                              '${flight.duration.inHours}h ${flight.duration.inMinutes % 60}m',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Arrival
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                flight.arrivalAirport,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                            Text(
                              flight.arrivalCity,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              flight.arrivalTime.timeFormatted,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  _DashedDivider(),
                  const SizedBox(height: 14),

                  // Bottom chips with responsive Wrap
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _InfoChip(
                                icon: Icons.door_front_door_outlined,
                                label: l.homeGate(flight.gate)),
                            _InfoChip(
                                icon: Icons.event_seat_outlined,
                                label: l.homeSeat(flight.seat)),
                            _InfoChip(
                                icon: Icons.flight_land_outlined,
                                label: l.homeTerminal(flight.terminal)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.chevron_right,
                            color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.08, curve: Curves.easeOut);
  }
}

class _DashedDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const dashWidth = 6.0;
      const dashSpace = 4.0;
      final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
      return Row(
        children: List.generate(count, (i) {
          return Padding(
            padding: const EdgeInsets.only(right: dashSpace),
            child: Container(
              width: dashWidth,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          );
        }),
      );
    });
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _QuickActions();

  List<_Action> _actions(AppLocalizations l) => [
        _Action(Icons.map_outlined, l.homeAirportMap, '/airport/map',
            AppColors.primaryGradient),
        _Action(Icons.qr_code_2_rounded, l.homeBoardingPass,
            '/flights/fl_001/boarding-pass', AppColors.greenGradient),
        _Action(Icons.restaurant_outlined, l.homeDining, '/services',
            AppColors.amberGradient),
        _Action(Icons.support_agent_outlined, l.homeHelp, '/airport-support',
            AppColors.purpleGradient),
      ];

  @override
  Widget build(BuildContext context) {
    final actions = _actions(AppLocalizations.of(context));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(actions.length, (i) {
        final a = actions[i];
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: i == 0 ? 0 : 4,
              right: i == actions.length - 1 ? 0 : 4,
            ),
            child: Pressable(
              onTap: () => context.push(a.route),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: a.gradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: (a.gradient.colors.first)
                              .withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(a.icon, color: Colors.white, size: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    a.label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ).animate(delay: (80 * i).ms).fadeIn().slideY(begin: 0.1),
          ),
        );
      }),
    );
  }
}

class _Action {
  const _Action(this.icon, this.label, this.route, this.gradient);
  final IconData icon;
  final String label;
  final String route;
  final LinearGradient gradient;
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (actionLabel != null && onAction != null)
          Pressable(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                actionLabel!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Flight Status List ───────────────────────────────────────────────────────

class _FlightStatusList extends StatelessWidget {
  const _FlightStatusList({required this.flights});
  final List<FlightModel> flights;

  Color _barColor(FlightStatus s) => switch (s) {
        FlightStatus.boarding => AppColors.boardingColor,
        FlightStatus.delayed => AppColors.delayedColor,
        FlightStatus.cancelled => AppColors.cancelledColor,
        FlightStatus.departed => AppColors.departedColor,
        FlightStatus.arrived => AppColors.arrivedColor,
        _ => AppColors.scheduledColor,
      };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: flights.asMap().entries.map((e) {
        final flight = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CycloneCard(
            onTap: () => context.push('/flights/${flight.id}'),
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: _barColor(flight.status),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppConstants.cardRadius),
                          bottomLeft: Radius.circular(AppConstants.cardRadius),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    flight.flightNumber,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    flight.route,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 6),
                                  StatusBadge(status: flight.status),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('HH:mm')
                                      .format(flight.departureTime),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Gate ${flight.gate}',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 4),
                                Icon(Icons.chevron_right,
                                    size: 18,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textTertiary),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate(delay: (60 * e.key).ms).fadeIn().slideX(begin: 0.04);
      }).toList(),
    );
  }
}

// ─── Weather Card ─────────────────────────────────────────────────────────────

class _WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppColors.amberGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.warning.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.wb_sunny_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('JFK Airport',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  l.homeWeatherDesc,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '72°',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(l.homeFeels(69),
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}

// ─── Notification Preview ─────────────────────────────────────────────────────

class _NotificationPreview extends StatelessWidget {
  const _NotificationPreview({required this.notifications});
  final List<NotificationModel> notifications;

  Color _typeColor(NotificationType type) => switch (type) {
        NotificationType.flightDelay => AppColors.delayedColor,
        NotificationType.gateChange => AppColors.scheduledColor,
        NotificationType.boardingStarted => AppColors.boardingColor,
        NotificationType.weatherAlert => AppColors.warning,
        _ => AppColors.textSecondary,
      };

  IconData _typeIcon(NotificationType type) => switch (type) {
        NotificationType.flightDelay => Icons.schedule_outlined,
        NotificationType.gateChange => Icons.door_front_door_outlined,
        NotificationType.boardingStarted => Icons.flight_takeoff_outlined,
        NotificationType.weatherAlert => Icons.cloud_outlined,
        _ => Icons.campaign_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: notifications.asMap().entries.map((e) {
        final n = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CycloneCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: _typeColor(n.type).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_typeIcon(n.type),
                      size: 18, color: _typeColor(n.type)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: n.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w700)),
                      Text(
                        n.message,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!n.isRead)
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(n.timeAgo,
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ],
            ),
          ),
        ).animate(delay: (50 * e.key).ms).fadeIn();
      }).toList(),
    );
  }
}

// ─── Travel Tips Carousel ─────────────────────────────────────────────────────

class _TravelTipsCarousel extends StatefulWidget {
  @override
  State<_TravelTipsCarousel> createState() => _TravelTipsCarouselState();
}

class _TravelTipsCarouselState extends State<_TravelTipsCarousel> {
  final _controller = PageController();

  List<_Tip> _tips(AppLocalizations l) => [
        _Tip(Icons.access_time_outlined, l.homeTipCheckInEarly,
            l.homeTipCheckInEarlyBody),
        _Tip(Icons.liquor_outlined, l.homeTipLiquidsRule,
            l.homeTipLiquidsRuleBody),
        _Tip(Icons.wifi_outlined, l.homeTipFreeWifi, l.homeTipFreeWifiBody),
        _Tip(Icons.luggage_outlined, l.homeTipBaggage, l.homeTipBaggageBody),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final tips = _tips(l);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l.homeTravelTips),
        const SizedBox(height: AppConstants.spacingMd),
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: _controller,
            itemCount: tips.length,
            itemBuilder: (context, i) {
              final tip = tips[i];
              return Padding(
                padding: const EdgeInsets.only(right: 2),
                child: CycloneCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:
                            Icon(tip.icon, color: AppColors.warning, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tip.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Text(
                              tip.message,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: SmoothPageIndicator(
            controller: _controller,
            count: tips.length,
            effect: WormEffect(
              dotWidth: 8,
              dotHeight: 8,
              activeDotColor: AppColors.primary,
              dotColor:
                  AppColors.primary.withValues(alpha: 0.2),
              spacing: 6,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingXl),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }
}

class _Tip {
  const _Tip(this.icon, this.title, this.message);
  final IconData icon;
  final String title;
  final String message;
}

// ─── Quick Currency Converter ───────────────────────────────────────────────

class _QuickCurrencyConverter extends StatefulWidget {
  const _QuickCurrencyConverter();

  @override
  State<_QuickCurrencyConverter> createState() => _QuickCurrencyConverterState();
}

class _QuickCurrencyConverterState extends State<_QuickCurrencyConverter> {
  final _amountController = TextEditingController(text: '100');
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _result = 0;

  static const _rates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 149.50,
    'AED': 3.67,
  };

  void _convert() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final fromRate = _rates[_fromCurrency] ?? 1;
    final toRate = _rates[_toCurrency] ?? 1;
    setState(() => _result = amount / fromRate * toRate);
  }

  @override
  void initState() {
    super.initState();
    _convert();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CycloneCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.translatorGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.currency_exchange, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                l.homeQuickConverter,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CurrencyDropdown(
                  value: _fromCurrency,
                  items: _rates.keys.toList(),
                  onChanged: (v) {
                    _fromCurrency = v;
                    _convert();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward,
                    size: 16,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
              ),
              Expanded(
                child: _CurrencyDropdown(
                  value: _toCurrency,
                  items: _rates.keys.toList(),
                  onChanged: (v) {
                    _toCurrency = v;
                    _convert();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBackground : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                    onChanged: (_) => _convert(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: AppColors.translatorGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_result.toStringAsFixed(2)} $_toCurrency',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 550.ms);
  }
}

class _CurrencyDropdown extends StatelessWidget {
  const _CurrencyDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
        items: items
            .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

// ─── Emergency Contacts ─────────────────────────────────────────────────────

class _EmergencyContacts extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _EmergencyContacts();

  List<_Contact> _contacts(AppLocalizations l) => [
        _Contact(Icons.local_police_outlined, l.homeEmergency, '911'),
        _Contact(Icons.medical_services_outlined, l.homeMedical, '555-MED'),
        _Contact(Icons.local_fire_department_outlined, l.homeFire, '555-FIRE'),
        _Contact(Icons.support_agent_outlined, l.homeAirportHelp, '555-HELP'),
      ];

  static Color _contactColor(int index) {
    return [AppColors.error, AppColors.error, AppColors.warning, AppColors.primary][index];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final contacts = _contacts(l);
    return CycloneCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.amberGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.emergency_outlined,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                l.homeEmergencyContacts,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: contacts.asMap().entries.map((e) {
              final c = e.value;
              final isLast = e.key == contacts.length - 1;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 8),
                  child: Pressable(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l.homeCalling(c.number, c.title)),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _contactColor(e.key).withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Icon(c.icon, color: Colors.white, size: 20),
                          const SizedBox(height: 6),
                          Text(
                            c.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            c.number,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: (50 * e.key).ms).fadeIn().slideY(begin: 0.05),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }
}

class _Contact {
  const _Contact(this.icon, this.title, this.number);
  final IconData icon;
  final String title;
  final String number;
}
