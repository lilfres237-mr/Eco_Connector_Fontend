enum NotificationType { 
  riderAccepted, 
  riderNearby, 
  pickupCompleted, 
  pointsCredited, 
  report, 
  scheduleUpdate,
  alert,
  pickup,
  reward,
  system 
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}
