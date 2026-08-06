import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/notification_model.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationModel notification;
  const NotificationDetailsScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification Details',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: 24),
            Text(notification.title, style: AppTextStyles.h2.copyWith(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.textTertiary),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(notification.timestamp),
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(width: 16),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: AppColors.gray200),
            const SizedBox(height: 32),
            Text(
              notification.message,
              style: AppTextStyles.bodyLarge.copyWith(height: 1.6, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 48),
            if (notification.type == NotificationType.pickupCompleted)
              _buildActionCard(
                'View Impact Summary',
                'Check how much waste you diverted from landfills this week.',
                Icons.analytics_outlined,
                () {},
              ),
            if (notification.type == NotificationType.pointsCredited)
              _buildActionCard(
                'View My Wallet',
                'Check your current Eco-Rewards balance and history.',
                Icons.account_balance_wallet_outlined,
                () {},
              ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: notification.isRead ? AppColors.gray100 : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        notification.isRead ? 'READ' : 'NEW',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: notification.isRead ? AppColors.textTertiary : Colors.green,
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.riderAccepted: return Icons.route_outlined;
      case NotificationType.riderNearby: return Icons.location_on_outlined;
      case NotificationType.pickupCompleted: return Icons.check_circle_outline;
      case NotificationType.pointsCredited: return Icons.account_balance_wallet_outlined;
      case NotificationType.report: return Icons.bar_chart_outlined;
      default: return Icons.notifications_outlined;
    }
  }
}
