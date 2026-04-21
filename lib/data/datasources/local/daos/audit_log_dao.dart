import 'package:drift/drift.dart';
import 'package:supermarket/data/datasources/local/app_database.dart';

part 'audit_log_dao.g.dart';

@DriftAccessor(tables: [AuditLogs])
class AuditLogDao extends DatabaseAccessor<AppDatabase> with _$AuditLogDaoMixin {
  AuditLogDao(super.db);

  Future<int> insertAuditLog(AuditLogsCompanion entry) {
    return into(auditLogs).insert(entry);
  }

  Future<List<AuditLogWithUser>> getAuditLogs({
    String? userId,
    String? entityType,
    String? entityId,
    DateTime? startDate,
    DateTime? endDate,
    String? action,
    int limit = 100,
  }) async {
    var query = select(auditLogs).join([
      innerJoin(users, users.id.equalsExp(auditLogs.userId)),
    ]);

    if (userId != null) {
      query = query.where(auditLogs.userId.equals(userId));
    }

    if (entityType != null) {
      query = query.where(auditLogs.entityType.equals(entityType));
    }

    if (entityId != null) {
      query = query.where(auditLogs.entityId.equals(entityId));
    }

    if (startDate != null) {
      query = query.where(auditLogs.timestamp.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query = query.where(auditLogs.timestamp.isSmallerOrEqualValue(endDate));
    }

    if (action != null) {
      query = query.where(auditLogs.action.equals(action));
    }

    query = query.orderBy([(t) => t.timestamp.desc()]);
    query = query.limit(limit);

    final results = await query.get();
    return results.map((row) {
      final log = row.readTable(auditLogs);
      final user = row.readTable(users);
      return AuditLogWithUser(log, user);
    }).toList();
  }

  Future<AuditLog?> getAuditLogById(String id) {
    return (select(auditLogs)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> deleteOldAuditLogs(DateTime beforeDate) {
    return (delete(auditLogs)
          ..where((tbl) => tbl.timestamp.isSmallerThanValue(beforeDate)))
        .go();
  }

  Future<int> deleteAllAuditLogs() {
    return delete(auditLogs).go();
  }
}

class AuditLogWithUser {
  final AuditLog log;
  final User user;

  AuditLogWithUser(this.log, this.user);

  Map<String, dynamic> toJson() {
    return {
      'id': log.id,
      'userId': log.userId,
      'userName': user.name,
      'action': log.action,
      'entityType': log.entityType,
      'entityId': log.entityId,
      'oldValue': log.oldValue,
      'newValue': log.newValue,
      'description': log.description,
      'ipAddress': log.ipAddress,
      'timestamp': log.timestamp.toIso8601String(),
      'module': log.module,
    };
  }
}
