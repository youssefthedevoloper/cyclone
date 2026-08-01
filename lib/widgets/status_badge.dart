import 'package:flutter/material.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/features/flight/data/models/flight_model.dart';

class StatusBadge extends StatefulWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.large = false,
  });

  final FlightStatus status;
  final bool large;

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    // Only animate for active statuses
    if (widget.status == FlightStatus.boarding ||
        widget.status == FlightStatus.delayed) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Color _bgColor() => switch (widget.status) {
        FlightStatus.boarding => AppColors.boardingColor.withValues(alpha: 0.15),
        FlightStatus.delayed => AppColors.delayedColor.withValues(alpha: 0.15),
        FlightStatus.cancelled => AppColors.cancelledColor.withValues(alpha: 0.15),
        FlightStatus.departed => AppColors.departedColor.withValues(alpha: 0.15),
        FlightStatus.arrived => AppColors.arrivedColor.withValues(alpha: 0.15),
        FlightStatus.scheduled => AppColors.scheduledColor.withValues(alpha: 0.15),
      };

  Color _dotColor() => switch (widget.status) {
        FlightStatus.boarding => AppColors.boardingColor,
        FlightStatus.delayed => AppColors.delayedColor,
        FlightStatus.cancelled => AppColors.cancelledColor,
        FlightStatus.departed => AppColors.departedColor,
        FlightStatus.arrived => AppColors.arrivedColor,
        FlightStatus.scheduled => AppColors.scheduledColor,
      };

  String _label() => switch (widget.status) {
        FlightStatus.boarding => 'Boarding',
        FlightStatus.delayed => 'Delayed',
        FlightStatus.cancelled => 'Cancelled',
        FlightStatus.departed => 'Departed',
        FlightStatus.arrived => 'Arrived',
        FlightStatus.scheduled => 'Scheduled',
      };

  @override
  Widget build(BuildContext context) {
    final isAnimated = widget.status == FlightStatus.boarding ||
        widget.status == FlightStatus.delayed;
    final fontSize = widget.large ? 13.0 : 11.0;
    final dotSize = widget.large ? 8.0 : 6.0;
    final hPad = widget.large ? 12.0 : 10.0;
    final vPad = widget.large ? 6.0 : 4.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: _dotColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated indicator dot
          if (isAnimated)
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) => Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: _dotColor().withValues(
                    alpha: 0.5 + 0.5 * _pulse.value,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            )
          else
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: _dotColor(),
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 5),
          Text(
            _label(),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: _dotColor(),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
