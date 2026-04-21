import 'package:dartz/dartz.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';
import 'package:supermarket/data/datasources/local/daos/notification_dao.dart';
import 'package:supermarket/domain/entities/notification.dart';
import 'package:supermarket/domain/repositories/notification_repository.dart';
import 'dart:convert';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDao _dao;

  NotificationRepositoryImpl(this._dao);

  @override
  Future<Either<String, List<Notification>>> getAllNotifications() async {
    try {
      final notifications = await _dao.getAllNotifications();
      return Right(notifications.map((n) => _toDomain(n)).toList());
    } catch (e) {
      return Left('Failed to get notifications: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<Notification>>> getUnreadNotifications() async {
    try {
      final notifications = await _dao.getUnreadNotifications();
      return Right(notifications.map((n) => _toDomain(n)).toList());
    } catch (e) {
      return Left('Failed to get unread notifications: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Notification>> markAsRead(String notificationId) async {
    try {
      await _dao.markAsRead(notificationId);
      final notifications = await _dao.getAllNotifications(limit: 1);
      final notification = notifications.firstWhere((n) => n.id == notificationId);
      return Right(_toDomain(notification));
    } catch (e) {
      return Left('Failed to mark notification as read: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> markAllAsRead() async {
    try {
      await _dao.markAllAsRead();
      return const Right(true);
    } catch (e) {
      return Left('Failed to mark all notifications as read: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> deleteNotification(String notificationId) async {
    try {
      await _dao.deleteNotification(notificationId);
      return const Right(true);
    } catch (e) {
      return Left('Failed to delete notification: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> createNotification(Notification notification) async {
    try {
      final companion = NotificationsCompanion(
        id: Value(notification.id),
        title: Value(notification.title),
        message: Value(notification.message),
        type: Value(notification.type.name),
        userId: Value(notification.metadata?['userId']),
        isRead: Value(notification.isRead),
        entityId: Value(notification.entityId),
        metadata: Value(notification.metadata != null ? jsonEncode(notification.metadata) : null),
        createdAt: Value(notification.createdAt),
      );

      await _dao.insertNotification(companion);
      return const Right(true);
    } catch (e) {
      return Left('Failed to create notification: ${e.toString()}');
    }
  }

  @override
  Stream<List<Notification>> get notificationsStream {
    return _dao.watchNotifications().map((notifications) =>
        notifications.map((n) => _toDomain(n)).toList());
  }

  Notification _toDomain(NotificationTable n) {
    Map<String, dynamic>? metadata;
    if (n.metadata != null) {
      try {
        metadata = jsonDecode(n.metadata!) as Map<String, dynamic>;
      } catch (_) {}
    }

    return Notification(
      id: n.id,
      title: n.title,
      message: n.message,
      type: NotificationType.values.firstWhere(
        (t) => t.name == n.type,
        orElse: () => NotificationType.syncError,
      ),
      createdAt: n.createdAt,
      isRead: n.isRead,
      entityId: n.entityId,
      metadata: metadata,
    );
  }
}
