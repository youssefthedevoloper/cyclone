import '../models/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _mockNotifications;
  }

  Future<void> markAsRead(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  Future<void> markAllAsRead() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  static final _mockNotifications = [
    NotificationModel(
      id: 'n1',
      title: 'Boarding Started',
      message: 'Group 2 boarding has started at Gate B22 for flight CY 2847.',
      type: NotificationType.boardingStarted,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      flightId: 'fl_001',
    ),
    NotificationModel(
      id: 'n2',
      title: 'Gate Changed',
      message: 'Flight CY 2847 gate changed from B20 to B22.',
      type: NotificationType.gateChange,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      flightId: 'fl_001',
    ),
    NotificationModel(
      id: 'n3',
      title: 'Weather Alert',
      message: 'Light rain expected at JFK. Allow extra time for ground transport.',
      type: NotificationType.weatherAlert,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'n4',
      title: 'Airport Announcement',
      message: 'Security checkpoint wait time at Terminal 4 is approximately 15 minutes.',
      type: NotificationType.announcement,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n5',
      title: 'Flight Delayed',
      message: 'Flight BA 178 delayed by 45 minutes. New departure: 3:45 PM.',
      type: NotificationType.flightDelay,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      flightId: 'fl_002',
      isRead: true,
    ),
  ];
}
