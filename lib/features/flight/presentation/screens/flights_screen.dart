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
import 'package:cyclone/widgets/shimmer_loading.dart';
import 'package:cyclone/features/flight/data/models/flight_model.dart';
import 'package:cyclone/features/flight/presentation/providers/flight_provider.dart';

class FlightsScreen extends ConsumerStatefulWidget {
  const FlightsScreen({super.key});

  @override
  ConsumerState<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends ConsumerState<FlightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

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
      appBar: AppBar(
        title: const Text('My Flights'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search flights, cities, airlines...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(flightSearchProvider.notifier).search('');
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                ref.read(flightSearchProvider.notifier).search(value);
                setState(() {});
              },
            ),
          ),
          Expanded(
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
          padding: EdgeInsets.only(bottom: 12),
          child: ShimmerCard(height: 100),
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
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _FlightListTile(flight: flights[index])
                    .animate(delay: (50 * index).ms)
                    .fadeIn()
                    .slideX(begin: 0.05),
              );
            },
          ),
        );
      },
    );
  }
}

class _FlightListTile extends StatelessWidget {
  const _FlightListTile({required this.flight});

  final FlightModel flight;

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      onTap: () => context.push('/flights/${flight.id}'),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(flight.flightNumber, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 8),
              Text(flight.airline, style: Theme.of(context).textTheme.bodySmall),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  flight.statusLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flight.departureAirport,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(flight.departureTime.timeFormatted),
                ],
              ),
              const Icon(Icons.flight, color: AppColors.textTertiary),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    flight.arrivalAirport,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(flight.arrivalTime.timeFormatted),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                flight.departureTime.dateFormatted,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text('Gate ${flight.gate}', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class FlightDetailsScreen extends ConsumerWidget {
  const FlightDetailsScreen({super.key, required this.flightId});

  final String flightId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightAsync = ref.watch(flightDetailProvider(flightId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () => context.push('/flights/$flightId/boarding-pass'),
          ),
        ],
      ),
      body: flightAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CycloneCard(
            gradient: AppColors.cardGradient,
            child: Column(
              children: [
                Text(
                  flight.flightNumber,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  flight.airline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _DetailAirport(code: flight.departureAirport, label: flight.departureCity),
                    Column(
                      children: [
                        Icon(Icons.flight, color: Colors.white.withValues(alpha: 0.7)),
                        Text(
                          '${flight.duration.inHours}h ${flight.duration.inMinutes % 60}m',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12),
                        ),
                      ],
                    ),
                    _DetailAirport(code: flight.arrivalAirport, label: flight.arrivalCity, alignEnd: true),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
          const SizedBox(height: AppConstants.spacingLg),
          _DetailSection(
            title: 'Departure',
            items: [
              _DetailItem('Date', flight.departureTime.dateFormatted),
              _DetailItem('Time', flight.departureTime.timeFormatted),
              _DetailItem('Terminal', flight.terminal),
              _DetailItem('Gate', flight.gate),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _DetailSection(
            title: 'Arrival',
            items: [
              _DetailItem('Date', flight.arrivalTime.dateFormatted),
              _DetailItem('Time', flight.arrivalTime.timeFormatted),
              if (flight.baggageClaim != null)
                _DetailItem('Baggage', flight.baggageClaim!),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          _DetailSection(
            title: 'Passenger',
            items: [
              _DetailItem('Seat', flight.seat),
              if (flight.boardingGroup != null)
                _DetailItem('Boarding Group', flight.boardingGroup!),
              if (flight.boardingTime != null)
                _DetailItem('Boarding Time', DateFormat('HH:mm').format(flight.boardingTime!)),
              if (flight.aircraft != null) _DetailItem('Aircraft', flight.aircraft!),
            ],
          ),
          const SizedBox(height: AppConstants.spacingXl),
          GradientButton(
            label: 'View Boarding Pass',
            icon: Icons.qr_code,
            onPressed: () => context.push('/flights/${flight.id}/boarding-pass'),
          ),
        ],
      ),
    );
  }
}

class _DetailAirport extends StatelessWidget {
  const _DetailAirport({required this.code, required this.label, this.alignEnd = false});
  final String code;
  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(code, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.items});
  final String title;
  final List<_DetailItem> items;

  @override
  Widget build(BuildContext context) {
    return CycloneCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        )),
                    Text(item.value, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              )),
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

class BoardingPassScreen extends ConsumerWidget {
  const BoardingPassScreen({super.key, required this.flightId});

  final String flightId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightAsync = ref.watch(flightDetailProvider(flightId));

    return Scaffold(
      appBar: AppBar(title: const Text('Boarding Pass')),
      body: flightAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorStateWidget(message: e.toString()),
        data: (flight) {
          if (flight == null) return const SizedBox.shrink();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              children: [
                CycloneCard(
                  child: Column(
                    children: [
                      Text(flight.airline, style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        flight.flightNumber,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('FROM', style: Theme.of(context).textTheme.labelMedium),
                              Text(flight.departureAirport,
                                  style: Theme.of(context).textTheme.headlineMedium),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('TO', style: Theme.of(context).textTheme.labelMedium),
                              Text(flight.arrivalAirport,
                                  style: Theme.of(context).textTheme.headlineMedium),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _PassInfo('GATE', flight.gate),
                          _PassInfo('SEAT', flight.seat),
                          _PassInfo('GROUP', flight.boardingGroup ?? '-'),
                        ],
                      ),
                      const SizedBox(height: 32),
                      QrImageView(
                        data: 'CYCLONE:${flight.id}:${flight.flightNumber}:${flight.seat}',
                        version: QrVersions.auto,
                        size: 200,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: AppColors.textPrimary,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Scan at security and boarding gate',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
                const SizedBox(height: AppConstants.spacingLg),
                GradientButton(
                  label: 'Add to Wallet',
                  icon: Icons.wallet,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to wallet')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PassInfo extends StatelessWidget {
  const _PassInfo(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
