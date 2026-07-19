import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/glass_container.dart';

enum AirportPoiType {
  gate,
  restroom,
  restaurant,
  lounge,
  elevator,
  escalator,
  prayerRoom,
  charging,
  parking,
  emergencyExit,
}

class AirportPoi {
  const AirportPoi({
    required this.name,
    required this.type,
    required this.floor,
    required this.distance,
    required this.icon,
  });

  final String name;
  final AirportPoiType type;
  final String floor;
  final String distance;
  final IconData icon;
}

class AirportMapScreen extends StatefulWidget {
  const AirportMapScreen({super.key});

  @override
  State<AirportMapScreen> createState() => _AirportMapScreenState();
}

class _AirportMapScreenState extends State<AirportMapScreen> {
  String _selectedCategory = 'All';
  String _destination = '';

  static const _categories = [
    'All',
    'Gates',
    'Restrooms',
    'Restaurants',
    'Lounges',
    'Services',
  ];

  static const _pois = [
    AirportPoi(name: 'Gate B22', type: AirportPoiType.gate, floor: 'Level 2', distance: '3 min', icon: Icons.flight),
    AirportPoi(name: 'Gate B20', type: AirportPoiType.gate, floor: 'Level 2', distance: '5 min', icon: Icons.flight),
    AirportPoi(name: 'Restroom A', type: AirportPoiType.restroom, floor: 'Level 2', distance: '1 min', icon: Icons.wc),
    AirportPoi(name: 'Starbucks', type: AirportPoiType.restaurant, floor: 'Level 2', distance: '2 min', icon: Icons.restaurant),
    AirportPoi(name: 'Delta Sky Club', type: AirportPoiType.lounge, floor: 'Level 3', distance: '4 min', icon: Icons.weekend),
    AirportPoi(name: 'Prayer Room', type: AirportPoiType.prayerRoom, floor: 'Level 1', distance: '6 min', icon: Icons.mosque),
    AirportPoi(name: 'Charging Station', type: AirportPoiType.charging, floor: 'Level 2', distance: '1 min', icon: Icons.battery_charging_full),
    AirportPoi(name: 'Elevator B', type: AirportPoiType.elevator, floor: 'All Levels', distance: '2 min', icon: Icons.elevator),
    AirportPoi(name: 'Escalator', type: AirportPoiType.escalator, floor: 'Level 1-2', distance: '1 min', icon: Icons.escalator),
    AirportPoi(name: 'Parking P4', type: AirportPoiType.parking, floor: 'Ground', distance: '12 min', icon: Icons.local_parking),
    AirportPoi(name: 'Emergency Exit E3', type: AirportPoiType.emergencyExit, floor: 'Level 2', distance: '4 min', icon: Icons.emergency),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airport Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search destination...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _destination.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.navigation),
                        color: AppColors.primary,
                        onPressed: () => context.push('/airport/navigation'),
                      )
                    : null,
              ),
              onChanged: (v) => setState(() => _destination = v),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: AppColors.primary.withValues(alpha: 0.15),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: CycloneCard(
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.05),
                            AppColors.accent.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                    ),
                    CustomPaint(
                      size: Size.infinite,
                      painter: _MapGridPainter(),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person_pin_circle, color: Colors.white, size: 28),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You are here',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Terminal 4 · Level 2',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 60,
                      child: _MapPin(icon: Icons.flight, label: 'B22', color: AppColors.success),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 40,
                      child: _MapPin(icon: Icons.restaurant, label: '', color: AppColors.warning),
                    ),
                  ],
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.95, 0.95)),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              itemCount: _pois.length,
              itemBuilder: (context, index) {
                final poi = _pois[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CycloneCard(
                    padding: const EdgeInsets.all(14),
                    onTap: () => context.push('/airport/navigation'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(poi.icon, color: AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(poi.name, style: Theme.of(context).textTheme.titleMedium),
                              Text('${poi.floor} · ${poi.distance} walk',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Icon(Icons.navigation, color: AppColors.primary, size: 20),
                      ],
                    ),
                  ).animate(delay: (30 * index).ms).fadeIn().slideX(begin: 0.05),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        if (label.isNotEmpty)
          Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    for (var i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i.toDouble(), 0), Offset(i.toDouble(), size.height), paint);
    }
    for (var i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AirportNavigationScreen extends StatelessWidget {
  const AirportNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: Column(
        children: [
          GlassContainer(
            margin: const EdgeInsets.all(AppConstants.spacingMd),
            child: Row(
              children: [
                const Icon(Icons.my_location, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Location', style: Theme.of(context).textTheme.labelMedium),
                      Text('Terminal 4, Level 2', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_downward, color: AppColors.textTertiary),
                const SizedBox(width: 12),
                const Icon(Icons.place, color: AppColors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Destination', style: Theme.of(context).textTheme.labelMedium),
                      Text('Gate B22', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
              child: CycloneCard(
                padding: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.03),
                        AppColors.accent.withValues(alpha: 0.03),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _NavigationPathPainter(),
                    child: const Center(
                      child: Icon(Icons.navigation, size: 48, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavStat(Icons.directions_walk, '3 min', 'Walking'),
                    _NavStat(Icons.straighten, '250m', 'Distance'),
                    _NavStat(Icons.elevator, '1', 'Elevator'),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingLg),
                _NavigationStep(
                  icon: Icons.arrow_forward,
                  instruction: 'Head east toward Gate B area',
                  distance: '80m',
                ),
                _NavigationStep(
                  icon: Icons.elevator,
                  instruction: 'Take elevator to Level 2',
                  distance: '',
                ),
                _NavigationStep(
                  icon: Icons.turn_right,
                  instruction: 'Turn right at Gate B22',
                  distance: '50m',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavStat extends StatelessWidget {
  const _NavStat(this.icon, this.value, this.label);
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _NavigationStep extends StatelessWidget {
  const _NavigationStep({
    required this.icon,
    required this.instruction,
    required this.distance,
    this.isLast = false,
  });

  final IconData icon;
  final String instruction;
  final String distance;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(instruction, style: Theme.of(context).textTheme.bodyLarge),
                ),
                if (distance.isNotEmpty)
                  Text(distance, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NavigationPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.5, size.height * 0.5,
        size.width * 0.7, size.height * 0.3,
      );

    canvas.drawPath(path, paint);

    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.8), 8,
        Paint()..color = AppColors.primary);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.3), 8,
        Paint()..color = AppColors.success);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
