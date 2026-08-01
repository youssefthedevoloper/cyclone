import 'package:dio/dio.dart';

import '../models/notification_model.dart';
import '../../../../core/services/api_client.dart';

class NotificationRepository {
  NotificationRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiClient.dio.get('/notifications/');
      final data = response.data as List<dynamic>;
      return data
          .map((json) => _fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return _mockNotifications;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _apiClient.dio.patch('/notifications/$id/', data: {'is_read': true});
    } on DioException catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiClient.dio.post('/notifications/mark-all-read/');
    } on DioException catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
  }

  NotificationModel _fromJson(Map<String, dynamic> json) {
    final type = _mapType(json['type'] as String? ?? 'general');
    final data = json['data'];
    String? flightId;
    if (data is Map<String, dynamic>) {
      flightId = data['flight_id'] as String?;
    }
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Notification',
      message: json['body'] as String? ?? '',
      type: type,
      timestamp: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      isRead: json['is_read'] as bool? ?? false,
      flightId: flightId,
    );
  }

  NotificationType _mapType(String type) => switch (type) {
        'delay' => NotificationType.flightDelay,
        'gate_change' => NotificationType.gateChange,
        'boarding' => NotificationType.boardingStarted,
        'weather' => NotificationType.weatherAlert,
        _ => NotificationType.announcement,
      };

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
