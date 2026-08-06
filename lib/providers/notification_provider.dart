import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/storage_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  NotificationProvider() {
    _loadNotifications();
  }

  void _loadNotifications() {
    final notificationsJson = StorageService.getString('user_notifications');
    if (notificationsJson != null && notificationsJson.isNotEmpty) {
      final List<dynamic> decoded = json.decode(notificationsJson);
      _notifications = decoded.map((n) => NotificationModel.fromJson(n)).toList();
    } else {
      _notifications = [
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
      _saveNotifications();
    }
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    final notificationsJson = json.encode(_notifications.map((n) => n.toJson()).toList());
    await StorageService.setString('user_notifications', notificationsJson);
  }

  List<NotificationModel> get notifications => _notifications;
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _saveNotifications();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    _saveNotifications();
    notifyListeners();
  }

  void addNotification(NotificationModel n) {
    _notifications.insert(0, n);
    _saveNotifications();
    notifyListeners();
  }
}
