import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

part 'notification_dao.g.dart';

@DriftAccessor(tables: [Notifications])
class NotificationDao extends DatabaseAccessor<AppDatabase> with _$NotificationDaoMixin {
  NotificationDao(super.db);

  Future<int> insertNotification(NotificationsCompanion notification) {
    return into(notifications).insert(notification);
  }

  Future<List<Notification>> getAllNotifications({String? userId, int limit = 50}) async {
    var query = select(notifications);

    if (userId != null) {
      query = query..where((tbl) => tbl.userId.equals(userId) | tbl.userId.isNull());
    }

    query = query..orderBy([(t) => t.createdAt.desc()]);
    query = query..limit(limit);

    return query.get();
  }

  Future<List<Notification>> getUnreadNotifications({String? userId}) async {
    var query = select(notifications)..where((tbl) => tbl.isRead.equals(false));

    if (userId != null) {
      query = query..where((tbl) => tbl.userId.equals(userId) | tbl.userId.isNull());
    }

    query = query..orderBy([(t) => t.createdAt.desc()]);

    return query.get();
  }

  Future<int> markAsRead(String notificationId) {
    return (update(notifications)..where((tbl) => tbl.id.equals(notificationId)))
        .write(NotificationsCompanion(isRead: Value(true), readAt: Value(DateTime.now())));
  }

  Future<int> markAllAsRead({String? userId}) {
    var query = update(notifications)..where((tbl) => tbl.isRead.equals(false));

    if (userId != null) {
      query = query..where((tbl) => tbl.userId.equals(userId) | tbl.userId.isNull());
    }

    return query.write(NotificationsCompanion(isRead: Value(true), readAt: Value(DateTime.now())));
  }

  Future<int> deleteNotification(String notificationId) {
    return (delete(notifications)..where((tbl) => tbl.id.equals(notificationId))).go();
  }

  Future<int> deleteOldNotifications(DateTime beforeDate) {
    return (delete(notifications)..where((tbl) => tbl.createdAt.isSmallerThanValue(beforeDate))).go();
  }

  Stream<List<Notification>> watchNotifications({String? userId}) {
    var query = select(notifications);

    if (userId != null) {
      query = query..where((tbl) => tbl.userId.equals(userId) | tbl.userId.isNull());
    }

    query = query..orderBy([(t) => t.createdAt.desc()]);

    return query.watch();
  }
}
