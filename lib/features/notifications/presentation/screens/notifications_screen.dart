import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyclone/core/constants/app_constants.dart';
import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/empty_state.dart';
import 'package:cyclone/widgets/shimmer_loading.dart';
import 'package:cyclone/features/notifications/data/models/notification_model.dart';
import 'package:cyclone/features/notifications/presentation/providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          itemCount: 5,
          itemBuilder: (_, _) => const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: ShimmerCard(height: 80),
          ),
        ),
        error: (_, _) => const EmptyStateWidget(
          title: 'Unable to load',
          message: 'Notifications could not be loaded.',
          icon: Icons.notifications_off_outlined,
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyStateWidget(
              title: 'No notifications',
              message: 'You\'re all caught up!',
              icon: Icons.notifications_none,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingMd),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CycloneCard(
                  padding: const EdgeInsets.all(16),
                  color: notification.isRead
                      ? null
                      : AppColors.primary.withValues(alpha: 0.03),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _typeColor(notification.type).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _typeIcon(notification.type),
                          color: _typeColor(notification.type),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: notification.isRead
                                              ? FontWeight.normal
                                              : FontWeight.w600,
                                        ),
                                  ),
                                ),
                                if (!notification.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.message,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notification.timeAgo,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: (40 * index).ms).fadeIn().slideX(begin: 0.05),
              );
            },
          );
        },
      ),
    );
  }

  Color _typeColor(NotificationType type) => switch (type) {
        NotificationType.flightDelay => AppColors.warning,
        NotificationType.gateChange => AppColors.primary,
        NotificationType.boardingStarted => AppColors.success,
        NotificationType.weatherAlert => AppColors.accent,
        _ => AppColors.textSecondary,
      };

  IconData _typeIcon(NotificationType type) => switch (type) {
        NotificationType.flightDelay => Icons.schedule,
        NotificationType.gateChange => Icons.door_front_door,
        NotificationType.boardingStarted => Icons.flight_takeoff,
        NotificationType.weatherAlert => Icons.cloud,
        _ => Icons.campaign,
      };
}
