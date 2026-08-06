import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Rider Accepted your request',
      message: 'John Doe is on his way to your location for the household waste collection.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      type: NotificationType.riderAccepted,
    ),
    NotificationModel(
      id: '2',
      title: 'Rider is nearby',
      message: 'Your waste collection partner is less than 500m away. Please ensure bags are ready.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: NotificationType.riderNearby,
    ),
    NotificationModel(
      id: '3',
      title: 'Pickup Completed',
      message: 'Your waste has been successfully collected and weighed. Thank you for recycling!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.pickupCompleted,
      isRead: true,
    ),
    NotificationModel(
      id: '4',
      title: '15 points credited to your wallet',
      message: 'EcoRewards points added for your sustainable disposal contribution.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.pointsCredited,
    ),
    NotificationModel(
      id: '5',
      title: 'Weekly Sustainability Report',
      message: "You've diverted 12kg of plastic from landfills this week. View your impact summary.",
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.report,
    ),
  ];

  List<NotificationModel> get notifications => _notifications;
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void addNotification(NotificationModel n) {
    _notifications.insert(0, n);
    notifyListeners();
  }
}
