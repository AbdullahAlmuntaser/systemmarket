import 'package:equatable/equatable.dart';

enum AuditAction {
  create,
  update,
  delete,
  view,
  approve,
  reject,
  void,
  reconcile,
  adjust,
}

class AuditLog extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String action;
  final String entityType;
  final String entityId;
  final Map<String, dynamic>? oldValue;
  final Map<String, dynamic>? newValue;
  final String? description;
  final String? ipAddress;
  final DateTime timestamp;
  final String? module;

  const AuditLog({
    required this.id,
    required this.userId,
    required this.userName,
    required this.action,
    required this.entityType,
    required this.entityId,
    this.oldValue,
    this.newValue,
    this.description,
    this.ipAddress,
    required this.timestamp,
    this.module,
  });

  factory AuditLog.create({
    required String id,
    required String userId,
    required String userName,
    required String action,
    required String entityType,
    required String entityId,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
    String? description,
    String? ipAddress,
    String? module,
  }) {
    return AuditLog(
      id: id,
      userId: userId,
      userName: userName,
      action: action,
      entityType: entityType,
      entityId: entityId,
      oldValue: oldValue,
      newValue: newValue,
      description: description,
      ipAddress: ipAddress,
      timestamp: DateTime.now(),
      module: module,
    );
  }

  AuditLog copyWith({
    String? id,
    String? userId,
    String? userName,
    String? action,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
    String? description,
    String? ipAddress,
    DateTime? timestamp,
    String? module,
  }) {
    return AuditLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      description: description ?? this.description,
      ipAddress: ipAddress ?? this.ipAddress,
      timestamp: timestamp ?? this.timestamp,
      module: module ?? this.module,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        action,
        entityType,
        entityId,
        oldValue,
        newValue,
        description,
        timestamp,
        module,
      ];
}

extension AuditActionExtension on AuditAction {
  String get displayName {
    switch (this) {
      case AuditAction.create:
        return 'إنشاء';
      case AuditAction.update:
        return 'تعديل';
      case AuditAction.delete:
        return 'حذف';
      case AuditAction.view:
        return 'عرض';
      case AuditAction.approve:
        return 'اعتماد';
      case AuditAction.reject:
        return 'رفض';
      case AuditAction.void:
        return 'إلغاء';
      case AuditAction.reconcile:
        return 'تسوية';
      case AuditAction.adjust:
        return 'تعديل';
    }
  }
}
