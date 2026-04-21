import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/services/notification_service.dart';
import '../../../domain/entities/notification.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () async {
              await notificationService.markAllAsRead();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديد الكل كمقروء')),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Notification>>(
        stream: notificationService.notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('لا توجد إشعارات', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _NotificationTile(
                notification: notification,
                onDismiss: () => notificationService.deleteNotification(notification.id),
                onMarkAsRead: () => notificationService.markAsRead(notification.id),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final Notification notification;
  final VoidCallback onDismiss;
  final VoidCallback onMarkAsRead;

  const _NotificationTile({
    Key? key,
    required this.notification,
    required this.onDismiss,
    required this.onMarkAsRead,
  }) : super(key: key);

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.lowStock:
        return Icons.inventory_2_outlined;
      case NotificationType.outOfStock:
        return Icons.warning;
      case NotificationType.debtReminder:
        return Icons.account_balance_wallet;
      case NotificationType.syncError:
        return Icons.sync_problem;
      case NotificationType.stockAdjustment:
        return Icons.adjust;
      case NotificationType.productionOrder:
        return Icons.factory;
      case NotificationType.chequeDue:
        return Icons.credit_card;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.lowStock:
        return Colors.orange;
      case NotificationType.outOfStock:
        return Colors.red;
      case NotificationType.debtReminder:
        return Colors.amber;
      case NotificationType.syncError:
        return Colors.redAccent;
      case NotificationType.stockAdjustment:
        return Colors.blue;
      case NotificationType.productionOrder:
        return Colors.purple;
      case NotificationType.chequeDue:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return Dismissible(
      key: Key(notification.id),
      direction: isArabic ? DismissDirection.startToEnd : DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDismiss(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        color: notification.isRead ? Colors.white : Colors.blue.shade50,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getColorForType(notification.type),
            child: Icon(_getIconForType(notification.type), color: Colors.white, size: 20),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification.message),
              const SizedBox(height: 4),
              Text(
                DateFormat('yyyy-MM-dd HH:mm').format(notification.createdAt),
                style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 12),
              ),
            ],
          ),
          trailing: !notification.isRead
              ? IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: onMarkAsRead,
                )
              : null,
          onTap: !notification.isRead ? onMarkAsRead : null,
        ),
      ),
    );
  }
}
