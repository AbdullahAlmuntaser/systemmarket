import 'package:dartz/dartz.dart';
import 'package:supermarket/domain/entities/audit_log.dart';
import 'package:supermarket/domain/repositories/audit_log_repository.dart';

class LogAudit {
  final AuditLogRepository repository;

  LogAudit(this.repository);

  Future<Either<String, bool>> call(AuditLog auditLog) async {
    return await repository.log(auditLog);
  }
}

class GetAuditLogs {
  final AuditLogRepository repository;

  GetAuditLogs(this.repository);

  Future<Either<String, List<AuditLog>>> call({
    String? userId,
    String? entityType,
    String? entityId,
    DateTime? startDate,
    DateTime? endDate,
    String? action,
    int limit = 100,
  }) async {
    return await repository.getLogs(
      userId: userId,
      entityType: entityType,
      entityId: entityId,
      startDate: startDate,
      endDate: endDate,
      action: action,
      limit: limit,
    );
  }
}

class GetAuditLogById {
  final AuditLogRepository repository;

  GetAuditLogById(this.repository);

  Future<Either<String, AuditLog>> call(String id) async {
    return await repository.getLogById(id);
  }
}

class DeleteOldAuditLogs {
  final AuditLogRepository repository;

  DeleteOldAuditLogs(this.repository);

  Future<Either<String, bool>> call(DateTime beforeDate) async {
    return await repository.deleteOldLogs(beforeDate);
  }
}
