import 'package:supermarket/domain/entities/notification.dart';
import 'package:supermarket/domain/repositories/notification_repository.dart';
import 'package:supermarket/domain/usecases/notification_usecases.dart';

class NotificationService {
  final NotificationRepository _repository;
  final CreateNotification _createNotification;
  final GetNotifications _getNotifications;
  final MarkNotificationAsRead _markAsRead;
  final MarkAllNotificationsAsRead _markAllAsRead;

  NotificationService(
    this._repository,
    this._createNotification,
    this._getNotifications,
    this._markAsRead,
    this._markAllAsRead,
  );

  Stream<List<Notification>> get notificationsStream => _repository.notificationsStream;

  Future<void> notifyLowStock(String productId, String productName, double currentStock, double alertLimit) async {
    await _createNotification.execute(
      title: 'مخزون منخفض',
      message: 'المخزون الحالي للمنتج $productName هو $currentStock، الحد الأدنى هو $alertLimit',
      type: NotificationType.lowStock,
      entityId: productId,
      metadata: {'productId': productId, 'currentStock': currentStock, 'alertLimit': alertLimit},
    );
  }

  Future<void> notifyOutOfStock(String productId, String productName) async {
    await _createNotification.execute(
      title: 'نفذ المخزون',
      message: 'نفذ المخزون من المنتج $productName',
      type: NotificationType.outOfStock,
      entityId: productId,
      metadata: {'productId': productId},
    );
  }

  Future<void> notifyDebtReminder(String customerId, String customerName, double amount) async {
    await _createNotification.execute(
      title: 'تذكير بالدين',
      message: 'لدى العميل $customerName مبلغ مستحق قدره $amount',
      type: NotificationType.debtReminder,
      entityId: customerId,
      metadata: {'customerId': customerId, 'amount': amount},
    );
  }

  Future<void> notifySyncError(String module, String error) async {
    await _createNotification.execute(
      title: 'خطأ في المزامنة',
      message: 'حدث خطأ في مزامنة $module: $error',
      type: NotificationType.syncError,
      metadata: {'module': module, 'error': error},
    );
  }

  Future<void> notifyStockAdjustment(String auditId, String note, double variance) async {
    await _createNotification.execute(
      title: 'تسوية جرد',
      message: 'تم تسجيل تسوية جرد: $note (التفاوت: $variance)',
      type: NotificationType.stockAdjustment,
      entityId: auditId,
      metadata: {'auditId': auditId, 'variance': variance},
    );
  }

  Future<void> notifyProductionOrder(String orderId, String productName, int quantity) async {
    await _createNotification.execute(
      title: 'أمر تصنيع',
      message: 'تم إنشاء أمر تصنيع لـ $productName (الكمية: $quantity)',
      type: NotificationType.productionOrder,
      entityId: orderId,
      metadata: {'orderId': orderId, 'productName': productName, 'quantity': quantity},
    );
  }

  Future<void> notifyChequeDue(String chequeId, String amount, DateTime dueDate) async {
    await _createNotification.execute(
      title: 'استحقاق شيك',
      message: 'الشيك بقيمة $amount مستحق في $dueDate',
      type: NotificationType.chequeDue,
      entityId: chequeId,
      metadata: {'chequeId': chequeId, 'amount': amount, 'dueDate': dueDate.toIso8601String()},
    );
  }

  Future<List<Notification>> getAllNotifications() async {
    final result = await _getNotifications.execute();
    return result.fold(
      (failure) => [],
      (notifications) => notifications,
    );
  }

  Future<List<Notification>> getUnreadNotifications() async {
    final result = await _repository.getUnreadNotifications();
    return result.fold(
      (failure) => [],
      (notifications) => notifications,
    );
  }

  Future<bool> markAsRead(String notificationId) async {
    final result = await _markAsRead.execute(notificationId);
    return result.isRight();
  }

  Future<bool> markAllAsRead() async {
    final result = await _markAllAsRead.execute();
    return result.isRight();
  }

  Future<bool> deleteNotification(String notificationId) async {
    final result = await _repository.deleteNotification(notificationId);
    return result.isRight();
  }
}
