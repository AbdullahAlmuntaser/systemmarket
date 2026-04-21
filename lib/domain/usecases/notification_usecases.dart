import 'package:dartz/dartz.dart';
import '../entities/notification.dart';

class CreateNotification {
  final NotificationRepository _repository;

  CreateNotification(this._repository);

  Future<Either<String, Notification>> execute({
    required String title,
    required String message,
    required NotificationType type,
    String? entityId,
    Map<String, dynamic>? metadata,
  }) async {
    final notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      entityId: entityId,
      metadata: metadata,
    );

    return await _repository.createNotification(notification);
  }
}

class GetNotifications {
  final NotificationRepository _repository;

  GetNotifications(this._repository);

  Future<Either<String, List<Notification>>> execute() async {
    return await _repository.getAllNotifications();
  }
}

class MarkNotificationAsRead {
  final NotificationRepository _repository;

  MarkNotificationAsRead(this._repository);

  Future<Either<String, Notification>> execute(String notificationId) async {
    return await _repository.markAsRead(notificationId);
  }
}

class MarkAllNotificationsAsRead {
  final NotificationRepository _repository;

  MarkAllNotificationsAsRead(this._repository);

  Future<Either<String, bool>> execute() async {
    return await _repository.markAllAsRead();
  }
}
