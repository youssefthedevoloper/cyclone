import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';

enum NotificationType {
  flightDelay,
  gateChange,
  boardingStarted,
  weatherAlert,
  announcement,
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String message,
    required NotificationType type,
    required DateTime timestamp,
    @Default(false) bool isRead,
    String? flightId,
  }) = _NotificationModel;
}

extension NotificationModelX on NotificationModel {
  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
