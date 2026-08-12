import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/pickup_request.dart';
import '../../../models/user_model.dart';
import '../../../providers/pickup_provider.dart';
import '../../../providers/user_provider.dart';
import 'pickup_details_screen.dart';

class PickupsScreen extends StatefulWidget {
  const PickupsScreen({super.key});

  @override
  State<PickupsScreen> createState() => _PickupsScreenState();
}

class _PickupsScreenState extends State<PickupsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final isRiderMode = user?.currentMode == AppMode.rider;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isRiderMode ? 'Job Management' : 'My Pickups',
          style: AppTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
          indicatorColor: Theme.of(context).colorScheme.primary,
          labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: isRiderMode ? 'Available' : 'Active'),
            Tab(text: isRiderMode ? 'My Jobs' : 'Completed'),
          ],
        ),
      ),
      body: Consumer<PickupProvider>(
        builder: (context, provider, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildPickupList(context, isRiderMode ? provider.availableForRiders : provider.activeRequests, isRider: isRiderMode),
              _buildPickupList(context, isRiderMode ? provider.getRiderJobs(user?.id ?? '') : provider.completedRequests, isCompleted: !isRiderMode, isRider: isRiderMode),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPickupList(BuildContext context, List<PickupRequest> requests, {bool isCompleted = false, bool isRider = false}) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted ? Icons.history : (isRider ? Icons.work_outline : Icons.local_shipping_outlined),
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted ? 'No completed pickups yet' : (isRider ? 'No available jobs near you' : 'No active pickups'),
              style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _buildPickupCard(context, request, isRider: isRider);
      },
    );
  }

  Widget _buildPickupCard(BuildContext context, PickupRequest request, {bool isRider = false}) {
    final bool isCompleted = request.status == PickupStatus.completed;
    final Color statusColor = _getStatusColor(request.status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PickupDetailsScreen(request: request),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerTheme.color ?? AppColors.gray200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.status.name.toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${request.dateTime.day}/${request.dateTime.month}',
                  style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodySmall?.color),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_circle_outline : (isRider ? Icons.location_on_outlined : Icons.local_shipping_outlined),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRider ? request.address : request.wasteType,
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isRider ? '${request.wasteType} • ${request.weightKg} Kg' : 'Weight: ${request.weightKg} Kg',
                        style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View Details',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 14, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(PickupStatus status) {
    switch (status) {
      case PickupStatus.confirmed:
      case PickupStatus.completed:
        return AppColors.primary;
      case PickupStatus.pending:
        return Colors.orange;
      case PickupStatus.cancelled:
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }
}
