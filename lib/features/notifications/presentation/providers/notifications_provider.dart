import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(),
);

class NotificationsNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  NotificationsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _load();
  }

  final NotificationRepository _repository;

  Future<void> _load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.getNotifications);
  }

  Future<void> refresh() => _load();

  Future<void> markAsRead(String id) async {
    final data = state.value;
    if (data == null) return;
    final updated = data
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    state = AsyncValue.data(updated);
    await _repository.markAsRead(id);
  }

  Future<void> markAllAsRead() async {
    final data = state.value;
    if (data == null) return;
    final updated = data.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncValue.data(updated);
    await _repository.markAllAsRead();
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier,
    AsyncValue<List<NotificationModel>>>((ref) {
  return NotificationsNotifier(ref.watch(notificationRepositoryProvider));
});
