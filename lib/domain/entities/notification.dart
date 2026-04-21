import 'package:equatable/equatable.dart';

enum NotificationType {
  lowStock,
  outOfStock,
  debtReminder,
  syncError,
  stockAdjustment,
  productionOrder,
  chequeDue,
}

class Notification extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? entityId;
  final Map<String, dynamic>? metadata;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.entityId,
    this.metadata,
  });

  Notification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? entityId,
    Map<String, dynamic>? metadata,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      entityId: entityId ?? this.entityId,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        type,
        createdAt,
        isRead,
        entityId,
        metadata,
      ];
}
