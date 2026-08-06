import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/notification_model.dart';
import '../../../providers/notification_provider.dart';
import 'notification_details_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Notifications', style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.read<NotificationProvider>().markAllAsRead(),
            child: const Text('Mark all read', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          final notifications = provider.notifications;
          
          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          // Grouping by date logic
          Map<String, List<NotificationModel>> grouped = {};
          for (var n in notifications) {
            String day = DateFormat('yyyy-MM-dd').format(n.timestamp);
            if (grouped[day] == null) grouped[day] = [];
            grouped[day]!.add(n);
          }

          List<String> sortedDays = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sortedDays.length,
            itemBuilder: (context, dayIndex) {
              String day = sortedDays[dayIndex];
              String title = _getDayTitle(day);
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 16),
                  ...grouped[day]!.map((n) => _buildNotificationItem(context, n)),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _getDayTitle(String day) {
    DateTime now = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(now);
    String yesterday = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));
    
    if (day == today) return 'TODAY';
    if (day == yesterday) return 'YESTERDAY';
    return DateFormat('MMM dd, yyyy').format(DateTime.parse(day)).toUpperCase();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off_outlined, color: AppColors.gray200, size: 64),
          const SizedBox(height: 16),
          Text('No notifications yet', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, NotificationModel n) {
    return GestureDetector(
      onTap: () {
        context.read<NotificationProvider>().markAsRead(n.id);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NotificationDetailsScreen(notification: n)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getBgColor(n.type),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getIcon(n.type), color: AppColors.primary, size: 24),
                ),
                if (!n.isRead)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(n.title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                      Text(DateFormat('h:mm a').format(n.timestamp), style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.message,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBgColor(NotificationType type) {
    if (type == NotificationType.alert) return Colors.red.shade50;
    return AppColors.primaryLight;
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.riderAccepted: return Icons.route_outlined;
      case NotificationType.riderNearby: return Icons.location_on_outlined;
      case NotificationType.pickupCompleted: return Icons.check_circle_outline;
      case NotificationType.pointsCredited: return Icons.account_balance_wallet_outlined;
      case NotificationType.report: return Icons.bar_chart_outlined;
      case NotificationType.scheduleUpdate: return Icons.warning_amber_outlined;
      case NotificationType.pickup: return Icons.local_shipping_outlined;
      case NotificationType.reward: return Icons.star_outline;
      case NotificationType.alert: return Icons.warning_amber_outlined;
      case NotificationType.system: return Icons.settings_outlined;
    }
  }
}
