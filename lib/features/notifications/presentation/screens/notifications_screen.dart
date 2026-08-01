import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cyclone/core/theme/app_colors.dart';
import 'package:cyclone/widgets/cyclone_card.dart';
import 'package:cyclone/widgets/empty_state.dart';
import 'package:cyclone/widgets/shimmer_loading.dart';
import 'package:cyclone/widgets/pressable.dart';
import 'package:cyclone/features/notifications/data/models/notification_model.dart';
import 'package:cyclone/features/notifications/presentation/providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final Map<NotificationType, String> _filterLabels = {
    NotificationType.flightDelay: 'Delays',
    NotificationType.gateChange: 'Gate Changes',
    NotificationType.boardingStarted: 'Boarding',
    NotificationType.weatherAlert: 'Weather',
    NotificationType.announcement: 'General',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 140,
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
                        Row(
                          children: [
                            Pressable(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Notifications',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  notificationsAsync.when(
                                    data: (notifications) {
                                      final unreadCount = notifications.where((n) => !n.isRead).length;
                                      return Text(
                                        unreadCount > 0
                                            ? '$unreadCount unread updates'
                                            : 'All caught up!',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.8),
                                          fontSize: 14,
                                        ),
                                      );
                                    },
                                    loading: () => Text(
                                      'Loading...',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                    error: (_, _) => Text(
                                      'Error loading notifications',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Pressable(
                              onTap: () => _markAllAsRead(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'Mark all read',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Unread'),
                    Tab(text: 'Today'),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAllNotifications(),
            _buildUnreadNotifications(),
            _buildTodayNotifications(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllNotifications() {
    return Consumer(
      builder: (context, ref, _) {
        final notificationsAsync = ref.watch(notificationsProvider);

        return notificationsAsync.when(
          loading: () => _buildLoadingState(),
          error: (_, _) => _buildErrorState(),
          data: (notifications) {
            if (notifications.isEmpty) {
              return _buildEmptyState('No notifications yet', 'You\'ll see important updates here');
            }

            final groupedNotifications = _groupNotificationsByDate(notifications);
            return _buildGroupedNotifications(groupedNotifications);
          },
        );
      },
    );
  }

  Widget _buildUnreadNotifications() {
    return Consumer(
      builder: (context, ref, _) {
        final notificationsAsync = ref.watch(notificationsProvider);

        return notificationsAsync.when(
          loading: () => _buildLoadingState(),
          error: (_, _) => _buildErrorState(),

          data: (notifications) {
            final unreadNotifications = notifications.where((n) => !n.isRead).toList();
            if (unreadNotifications.isEmpty) {
              return _buildEmptyState('All caught up!', 'No unread notifications');
            }

            final groupedNotifications = _groupNotificationsByDate(unreadNotifications);
            return _buildGroupedNotifications(groupedNotifications);
          },
        );
      },
    );
  }

  Widget _buildTodayNotifications() {
    return Consumer(
      builder: (context, ref, _) {
        final notificationsAsync = ref.watch(notificationsProvider);

        return notificationsAsync.when(
          loading: () => _buildLoadingState(),
          error: (_, _) => _buildErrorState(),
          data: (notifications) {
            final now = DateTime.now();
            final todayNotifications = notifications.where((n) {
              return n.timestamp.day == now.day &&
                     n.timestamp.month == now.month &&
                     n.timestamp.year == now.year;
            }).toList();

            if (todayNotifications.isEmpty) {
              return _buildEmptyState('No updates today', 'Check back later for new notifications');
            }

            final groupedNotifications = _groupNotificationsByType(todayNotifications);
            return _buildGroupedByTypeNotifications(groupedNotifications);
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: 5,
      itemBuilder: (_, _) => const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: ShimmerCard(height: 80),
      ),
    );
  }

  Widget _buildErrorState() {
    return ListView(
      children: [
        const SizedBox(height: 80),
        const EmptyStateWidget(
          title: 'Unable to load',
          message: 'Notifications could not be loaded.',
          icon: Icons.notifications_off_outlined,
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return ListView(
      children: [
        const SizedBox(height: 80),
        EmptyStateWidget(
          title: title,
          message: message,
          icon: Icons.notifications_none,
        ),
      ],
    );
  }

  Map<String, List<NotificationModel>> _groupNotificationsByDate(List<NotificationModel> notifications) {
    final Map<String, List<NotificationModel>> grouped = {};
    final now = DateTime.now();

    for (final notification in notifications) {
      String dateKey;
      final diff = now.difference(notification.timestamp);

      if (diff.inDays == 0) {
        dateKey = 'Today';
      } else if (diff.inDays == 1) {
        dateKey = 'Yesterday';
      } else if (diff.inDays < 7) {
        dateKey = '${diff.inDays} days ago';
      } else {
        dateKey = 'Older';
      }

      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

  Map<NotificationType, List<NotificationModel>> _groupNotificationsByType(List<NotificationModel> notifications) {
    final Map<NotificationType, List<NotificationModel>> grouped = {};

    for (final notification in notifications) {
      grouped.putIfAbsent(notification.type, () => []);
      grouped[notification.type]!.add(notification);
    }

    return grouped;
  }

  Widget _buildGroupedNotifications(Map<String, List<NotificationModel>> groupedNotifications) {
    final entries = groupedNotifications.entries.toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 24),
            _buildSectionHeader(entry.key, entry.value.length),
            const SizedBox(height: 12),
            ...entry.value.asMap().entries.map((e) =>
              _buildNotificationCard(e.value, e.key)
                .animate(delay: (50 * e.key).ms)
                .fadeIn()
                .slideY(begin: 0.05)
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupedByTypeNotifications(Map<NotificationType, List<NotificationModel>> groupedNotifications) {
    final entries = groupedNotifications.entries.toList();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: 24),
            _buildSectionHeader(_filterLabels[entry.key] ?? 'Other', entry.value.length),
            const SizedBox(height: 12),
            ...entry.value.asMap().entries.map((e) =>
              _buildNotificationCard(e.value, e.key)
                .animate(delay: (50 * e.key).ms)
                .fadeIn()
                .slideY(begin: 0.05)
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(NotificationModel notification, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Pressable(
        onTap: () => _handleNotificationTap(notification),
        child: CycloneCard(
          padding: const EdgeInsets.all(16),
          color: notification.isRead
              ? null
              : AppColors.primary.withValues(alpha: 0.03),
          borderColor: notification.isRead
              ? null
              : AppColors.primary.withValues(alpha: 0.2),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status bar
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: _typeColor(notification.type),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),

                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _typeColor(notification.type).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _typeIcon(notification.type),
                    color: _typeColor(notification.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
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
                                    ? FontWeight.w600
                                    : FontWeight.w700,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _typeColor(notification.type),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _typeColor(notification.type).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              _getTypeLabel(notification.type),
                              style: TextStyle(
                                color: _typeColor(notification.type),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            notification.timeAgo,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    ref.read(notificationsProvider.notifier).markAsRead(notification.id);
  }

  void _markAllAsRead() {
    ref.read(notificationsProvider.notifier).markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getTypeLabel(NotificationType type) => switch (type) {
    NotificationType.flightDelay => 'DELAY',
    NotificationType.gateChange => 'GATE',
    NotificationType.boardingStarted => 'BOARDING',
    NotificationType.weatherAlert => 'WEATHER',
    NotificationType.announcement => 'INFO',
  };

  Color _typeColor(NotificationType type) => switch (type) {
        NotificationType.flightDelay => AppColors.delayedColor,
        NotificationType.gateChange => AppColors.scheduledColor,
        NotificationType.boardingStarted => AppColors.boardingColor,
        NotificationType.weatherAlert => AppColors.warning,
        NotificationType.announcement => AppColors.info,
      };

  IconData _typeIcon(NotificationType type) => switch (type) {
        NotificationType.flightDelay => Icons.schedule_outlined,
        NotificationType.gateChange => Icons.door_front_door_outlined,
        NotificationType.boardingStarted => Icons.flight_takeoff_outlined,
        NotificationType.weatherAlert => Icons.cloud_outlined,
        NotificationType.announcement => Icons.campaign_outlined,
      };
}
