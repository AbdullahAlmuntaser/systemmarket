import 'package:dartz/dartz.dart';
import 'package:supermarket/domain/entities/audit_log.dart';

abstract class AuditLogRepository {
  Future<Either<String, bool>> log(AuditLog auditLog);
  Future<Either<String, List<AuditLog>>> getLogs({
    String? userId,
    String? entityType,
    String? entityId,
    DateTime? startDate,
    DateTime? endDate,
    String? action,
    int limit = 100,
  });
  Future<Either<String, AuditLog>> getLogById(String id);
  Future<Either<String, bool>> deleteOldLogs(DateTime beforeDate);
}
