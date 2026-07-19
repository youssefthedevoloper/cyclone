import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(),
);

final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  return ref.watch(notificationRepositoryProvider).getNotifications();
});
