import 'package:dartz/dartz.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<String, List<Notification>>> getAllNotifications();
  Future<Either<String, List<Notification>>> getUnreadNotifications();
  Future<Either<String, Notification>> markAsRead(String notificationId);
  Future<Either<String, bool>> markAllAsRead();
  Future<Either<String, bool>> deleteNotification(String notificationId);
  Future<Either<String, bool>> createNotification(Notification notification);
  Stream<List<Notification>> get notificationsStream;
}
