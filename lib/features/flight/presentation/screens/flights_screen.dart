import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/core/utils/extensions.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/empty_state.dart';
import 'package:cyclone/widgets/gradient_button.dart';
import 'package:cyclone/widgets/pressable.dart';
import 'package:cyclone/widgets/shimmer_loading.dart';
import 'package:cyclone/widgets/status_badge.dart';
import 'package:cyclone/features/flight/data/models/flight_model.dart';
import 'package:cyclone/features/flight/presentation/providers/flight_provider.dart';
import 'package:cyclone/core/config/router/routes.dart' as routes;

class FlightsScreen extends ConsumerStatefulWidget {
  const FlightsScreen({super.key});

  @override
  ConsumerState<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends ConsumerState<FlightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced header with gradient
          SliverAppBar(
            expandedHeight: 260,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                        const SizedBox(height: 20),
                        // Title and filter toggle
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Flights',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Text(
                                    'Track and manage your journeys',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Stats card
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.flight,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '12',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    'flights',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Search bar with enhanced filter button
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search flights, cities, airlines...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      size: 20,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              _searchController.clear();
                                              ref.read(flightSearchProvider.notifier).search('');
                                              setState(() {});
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 18,
                                              color: Colors.white.withValues(alpha: 0.8),
                                            ),
                                          )
                                        : null,
                                  ),
                                  onChanged: (v) {
                                    ref.read(flightSearchProvider.notifier).search(v);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Pressable(
                              onTap: () {
                                setState(() {
                                  _showFilters = !_showFilters;
                                });
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _showFilters 
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _showFilters 
                                      ? Colors.white.withValues(alpha: 0.4)
                                      : Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Tabs
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                            indicator: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                            tabs: const [
                              Tab(text: 'Upcoming'),
                              Tab(text: 'Past'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filters (below header so they never overflow the app bar)
          if (_showFilters)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _FiltersSection().animate().fadeIn().slideY(begin: -0.1),
              ),
            ),

          // Content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _FlightsList(provider: upcomingFlightsProvider),
                _FlightsList(provider: pastFlightsProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filters Section ─────────────────────────────────────────────────────────

class _FiltersSection extends StatefulWidget {
  @override
  State<_FiltersSection> createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<_FiltersSection> {
  String _selectedStatus = 'All';
  String _selectedSort = 'Date';

  final _statuses = ['All', 'Scheduled', 'Boarding', 'Departed', 'Delayed'];
  final _sortOptions = ['Date', 'Price', 'Duration'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list_rounded, color: Colors.white.withValues(alpha: 0.8), size: 16),
              const SizedBox(width: 6),
              Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Status',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _statuses.map((s) {
              final selected = _selectedStatus == s;
              return GestureDetector(
                onTap: () => setState(() => _selectedStatus = s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'Sort by',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _sortOptions.map((s) {
              final selected = _selectedSort == s;
              return GestureDetector(
                onTap: () => setState(() => _selectedSort = s),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FlightsList extends ConsumerWidget {
  const _FlightsList({required this.provider});
  final FutureProvider<List<FlightModel>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightsAsync = ref.watch(provider);

    return flightsAsync.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        itemCount: 4,
        itemBuilder: (_, _) => const Padding(
          padding: EdgeInsets.only(bottom: 14),
          child: ShimmerFlightTile(),
        ),
      ),
      error: (error, _) => ErrorStateWidget(
        message: error.toString(),
        onRetry: () => ref.invalidate(provider),
      ),
      data: (flights) {
        if (flights.isEmpty) {
          return const EmptyStateWidget(
            title: 'No flights found',
            message: 'Your flights will appear here once booked.',
            icon: Icons.flight_outlined,
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(provider),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _FlightBoardingCard(flight: flights[index])
                    .animate(delay: (60 * index).ms)
                    .fadeIn()
                    .slideY(begin: 0.06),
              );
            },
          ),
        );
      },
    );
  }
}

// ─── Boarding-Pass Style Flight Card ─────────────────────────────────────────

class _FlightBoardingCard extends StatelessWidget {
  const _FlightBoardingCard({required this.flight});
  final FlightModel flight;

  Color _accentColor() => switch (flight.status) {
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
    final accent = _accentColor();

    return Hero(
      tag: 'flight_${flight.id}',
      child: Pressable(
        onTap: () => context.push('${routes.AppRoutes.flights}/${flight.id}'),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            border: Border.all(
              color: isDark
                  ? AppColors.darkBorder.withValues(alpha: 0.5)
                  : AppColors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Top section with accent bar ──
              Container(
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.06),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.cardRadius),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Row(
                  children: [
                    // Airline initial badge
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          flight.airlineCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(flight.flightNumber,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800)),
                          Text(flight.airline,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                    StatusBadge(status: flight.status, large: true),
                  ],
                ),
              ),

              // Dashed separator with cutout circles
              _CardSeparator(accentColor: accent, isDark: isDark),

              // ── Bottom section – route info ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Departure
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.departureAirport,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              Text(
                                flight.departureCity,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                flight.departureTime.timeFormatted,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        // Center
                        Column(
                          children: [
                            Icon(Icons.flight_rounded,
                                color: accent, size: 22),
                            const SizedBox(height: 4),
                            Text(
                              '${flight.duration.inHours}h ${flight.duration.inMinutes % 60}m',
                              style:
                                  Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        // Arrival
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                flight.arrivalAirport,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              Text(
                                flight.arrivalCity,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                flight.arrivalTime.timeFormatted,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 13, color: AppColors.textTertiary),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            flight.departureTime.dateFormatted,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const Spacer(),
                        _SmallChip(
                            icon: Icons.door_front_door_outlined,
                            label: 'Gate ${flight.gate}'),
                        const SizedBox(width: 6),
                        _SmallChip(
                            icon: Icons.event_seat_outlined,
                            label: 'Seat ${flight.seat}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardSeparator extends StatelessWidget {
  const _CardSeparator({required this.accentColor, required this.isDark});
  final Color accentColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dashed line
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(builder: (context, constraints) {
              const dw = 6.0;
              const ds = 4.0;
              final count = (constraints.maxWidth / (dw + ds)).floor();
              return Row(
                children: List.generate(count, (i) => Padding(
                  padding: const EdgeInsets.only(right: ds),
                  child: Container(
                    width: dw,
                    height: 1,
                    color: accentColor.withValues(alpha: 0.3),
                  ),
                )),
              );
            }),
          ),
          // Left cutout
          Positioned(
            left: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.5)
                      : AppColors.border,
                  width: 1,
                ),
              ),
            ),
          ),
          // Right cutout
          Positioned(
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder.withValues(alpha: 0.5)
                      : AppColors.border,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Flight Details Screen ────────────────────────────────────────────────────

class FlightDetailsScreen extends ConsumerWidget {
  const FlightDetailsScreen({super.key, required this.flightId});
  final String flightId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightAsync = ref.watch(flightDetailProvider(flightId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Details',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          Pressable(
            onTap: () => context.push(routes.AppRoutes.boardingPass.replaceFirst(':id', flightId)),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text('Pass',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
      body: flightAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => ErrorStateWidget(
          message: e.toString(),
          onRetry: () => ref.invalidate(flightDetailProvider(flightId)),
        ),
        data: (flight) {
          if (flight == null) {
            return const EmptyStateWidget(
              title: 'Flight not found',
              message: 'This flight could not be loaded.',
              icon: Icons.flight_outlined,
            );
          }
          return _FlightDetailsBody(flight: flight);
        },
      ),
    );
  }
}

class _FlightDetailsBody extends StatelessWidget {
  const _FlightDetailsBody({required this.flight});
  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero card
          Hero(
            tag: 'flight_${flight.id}',
            child: Material(
              color: Colors.transparent,
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(flight.airline,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.7),
                                      fontSize: 13)),
                              Text(flight.flightNumber,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        StatusBadge(status: flight.status, large: true),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(flight.departureAirport,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1)),
                              Text(flight.departureCity,
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.65),
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                        Column(children: [
                          const Icon(Icons.flight_rounded,
                              color: Colors.white70, size: 28),
                          const SizedBox(height: 4),
                          Text(
                              '${flight.duration.inHours}h ${flight.duration.inMinutes % 60}m',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.65),
                                  fontSize: 12)),
                        ]),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(flight.arrivalAirport,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1)),
                              Text(flight.arrivalCity,
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.65),
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.96, 0.96), curve: Curves.easeOut),

          const SizedBox(height: AppConstants.spacingLg),

          // Detail sections
          _DetailSection(title: 'Departure', items: [
            _DetailItem('Date', flight.departureTime.dateFormatted),
            _DetailItem('Time', flight.departureTime.timeFormatted),
            _DetailItem('Terminal', flight.terminal),
            _DetailItem('Gate', flight.gate),
          ]).animate(delay: 100.ms).fadeIn().slideY(begin: 0.04),

          const SizedBox(height: AppConstants.spacingMd),

          _DetailSection(title: 'Arrival', items: [
            _DetailItem('Date', flight.arrivalTime.dateFormatted),
            _DetailItem('Time', flight.arrivalTime.timeFormatted),
            if (flight.baggageClaim != null)
              _DetailItem('Baggage Claim', flight.baggageClaim!),
          ]).animate(delay: 160.ms).fadeIn().slideY(begin: 0.04),

          const SizedBox(height: AppConstants.spacingMd),

          _DetailSection(title: 'Passenger', items: [
            _DetailItem('Seat', flight.seat),
            if (flight.boardingGroup != null)
              _DetailItem('Boarding Group', flight.boardingGroup!),
            if (flight.boardingTime != null)
              _DetailItem('Boarding Time',
                  DateFormat('HH:mm').format(flight.boardingTime!)),
            if (flight.aircraft != null)
              _DetailItem('Aircraft', flight.aircraft!),
          ]).animate(delay: 220.ms).fadeIn().slideY(begin: 0.04),

          const SizedBox(height: AppConstants.spacingXl),

          GradientButton(
            label: 'View Boarding Pass',
            icon: Icons.qr_code_2_rounded,
            onPressed: () =>
                context.push(routes.AppRoutes.boardingPass.replaceFirst(':id', flight.id)),
          ).animate(delay: 280.ms).fadeIn().slideY(begin: 0.04),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.items});
  final String title;
  final List<_DetailItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CycloneCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          ...items.asMap().entries.map((e) {
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(e.value.label,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.textSecondary)),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(e.value.value,
                            textAlign: TextAlign.end,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    color: isDark
                        ? AppColors.darkBorder.withValues(alpha: 0.5)
                        : AppColors.divider,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _DetailItem {
  const _DetailItem(this.label, this.value);
  final String label;
  final String value;
}

// ─── Apple Wallet–Style Boarding Pass ────────────────────────────────────────

class BoardingPassScreen extends ConsumerWidget {
  const BoardingPassScreen({super.key, required this.flightId});
  final String flightId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightAsync = ref.watch(flightDetailProvider(flightId));

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: Colors.white,
        title: const Text('Boarding Pass',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        elevation: 0,
      ),
      body: flightAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => ErrorStateWidget(message: e.toString()),
        data: (flight) {
          if (flight == null) return const SizedBox.shrink();
          return _BoardingPassBody(flight: flight);
        },
      ),
    );
  }
}

class _BoardingPassBody extends StatelessWidget {
  const _BoardingPassBody({required this.flight});
  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Column(
        children: [
          // ── The Boarding Pass Card ──
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.boardingPassGradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // ── Header ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          flight.airlineCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(flight.airline,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 11,
                                    letterSpacing: 0.5)),
                            Text(flight.flightNumber,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18)),
                          ],
                        ),
                      ),
                      StatusBadge(status: flight.status, large: true),
                    ],
                  ),
                ),

                // ── Route ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FROM',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 10,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(flight.departureAirport,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 44,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1)),
                            Text(flight.departureCity,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.55),
                                    fontSize: 13)),
                            const SizedBox(height: 8),
                            Text(
                              flight.departureTime.timeFormatted,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              flight.departureTime.dateFormatted,
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Icon(Icons.flight_rounded,
                              color: AppColors.accent, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            '${flight.duration.inHours}h ${flight.duration.inMinutes % 60}m',
                            style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('TO',
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 10,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(flight.arrivalAirport,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 44,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1)),
                            Text(flight.arrivalCity,
                                style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.55),
                                    fontSize: 13)),
                            const SizedBox(height: 8),
                            Text(
                              flight.arrivalTime.timeFormatted,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              flight.arrivalTime.dateFormatted,
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Perforated Separator ──
                _PerforatedSeparator(),
                const SizedBox(height: 20),

                // ── Passenger Info ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _PassInfoBox('GATE', flight.gate),
                      _VerticalDivider(),
                      _PassInfoBox('SEAT', flight.seat),
                      _VerticalDivider(),
                      _PassInfoBox('GROUP', flight.boardingGroup ?? 'A'),
                      _VerticalDivider(),
                      _PassInfoBox('TERMINAL', flight.terminal),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── QR Code ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      QrImageView(
                        data:
                            'CYCLONE:${flight.id}:${flight.flightNumber}:${flight.seat}',
                        version: QrVersions.auto,
                        size: 180,
                        backgroundColor: Colors.white,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppColors.textPrimary,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Scan at security & boarding gate',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(
                  begin: const Offset(0.92, 0.92),
                  curve: Curves.easeOutBack),

          const SizedBox(height: 24),

          // ── Wallet Button ──
          GradientButton(
            label: 'Add to Wallet',
            icon: Icons.wallet_rounded,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Boarding pass saved to Wallet'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.06),
        ],
      ),
    );
  }
}

class _PerforatedSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const dashW = 5.0;
      const dashSp = 4.0;
      final count = ((constraints.maxWidth - 40) / (dashW + dashSp)).floor();
      return Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(count, (i) => Padding(
                padding: const EdgeInsets.only(right: dashSp),
                child: Container(
                  width: dashW,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              )),
            ),
          ),
          // Left hole
          Positioned(
            left: 0,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
          ),
          // Right hole
          Positioned(
            right: 0,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _PassInfoBox extends StatelessWidget {
  const _PassInfoBox(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }
}
