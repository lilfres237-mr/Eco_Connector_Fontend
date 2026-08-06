import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/pickup_request.dart';
import '../../../core/constants/app_images.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:provider/provider.dart';
import '../../../providers/pickup_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/user_model.dart';

class PickupDetailsScreen extends StatelessWidget {
  final PickupRequest request;
  const PickupDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    // Watch for updates to this specific request
    final updatedRequest = context.watch<PickupProvider>().activeRequests.firstWhere(
      (r) => r.id == request.id,
      orElse: () => request,
    );
    final isSearching = updatedRequest.status == PickupStatus.searching;
    final rider = updatedRequest.assignedRider;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pickup Details',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(updatedRequest),
            const SizedBox(height: 32),
            _buildInfoSection('TRACKING INFORMATION', [
              _buildInfoRow('Tracking ID', updatedRequest.trackingNumber),
              _buildInfoRow('Pickup ID', updatedRequest.id.substring(0, updatedRequest.id.length > 8 ? 8 : updatedRequest.id.length).toUpperCase()),
            ]),
            const SizedBox(height: 24),
            _buildInfoSection('COLLECTION DETAILS', [
              _buildInfoRow('Waste Type', updatedRequest.wasteType),
              _buildInfoRow('Description', updatedRequest.description),
              _buildInfoRow('Estimated Weight', '${updatedRequest.weightKg} Kg'),
              _buildInfoRow('Scheduled Date', DateFormat('EEEE, MMM d').format(updatedRequest.dateTime)),
              _buildInfoRow('Scheduled Time', DateFormat('h:mm a').format(updatedRequest.dateTime)),
            ]),
            const SizedBox(height: 24),
            if (rider != null)
              _buildInfoSection('COURIER INFORMATION', [
                _buildInfoRow('Rider Name', rider.name),
                _buildInfoRow('Vehicle', rider.vehicleInfo),
                _buildInfoRow('Rating', '${rider.rating} ⭐'),
                _buildInfoRow('Est. Arrival', rider.estimatedArrival),
              ])
            else if (isSearching)
              _buildSearchingCard(context),
            const SizedBox(height: 32),
            Text(
              'ACTIVITY TIMELINE',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            _buildTimeline(updatedRequest),
            const SizedBox(height: 32),
            Text('PICKUP LOCATION', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gray200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 14),
                  markers: {
                    const Marker(markerId: MarkerId('pickup'), position: LatLng(37.7749, -122.4194)),
                  },
                  zoomControlsEnabled: false,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildActionButton(context, updatedRequest),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(PickupRequest request) {
    final isSearching = request.status == PickupStatus.searching;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSearching ? Colors.orange.withValues(alpha: 0.1) : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              isSearching ? Icons.search : Icons.local_shipping_outlined, 
              color: isSearching ? Colors.orange : AppColors.primary, 
              size: 28
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Status', style: AppTextStyles.bodySmall),
              Text(
                request.status.name.toUpperCase(),
                style: AppTextStyles.h3.copyWith(
                  color: isSearching ? Colors.orange : AppColors.primary, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.gray200),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Searching for a rider to pick up your waste...',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(PickupRequest request) {
    final bool isSearching = request.status == PickupStatus.searching;
    final bool isConfirmed = request.status != PickupStatus.searching && request.status != PickupStatus.pending;
    
    return Column(
      children: [
        _buildTimelineItem('Request Received', DateFormat('MMM d, h:mm a').format(DateTime.now().subtract(const Duration(minutes: 5))), isLast: false, isDone: true),
        _buildTimelineItem('Searching for Rider', isSearching ? 'In progress...' : 'Completed', isLast: false, isDone: true),
        _buildTimelineItem('Rider Assigned', isConfirmed ? 'Assigned' : 'Pending', isLast: false, isDone: isConfirmed),
        _buildTimelineItem('Confirmed', isConfirmed ? 'Ready' : '-', isLast: false, isDone: isConfirmed),
        _buildTimelineItem('Collected', '-', isLast: true, isDone: false),
      ],
    );
  }

  Widget _buildTimelineItem(String title, String time, {required bool isLast, required bool isDone}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? AppColors.primary : AppColors.gray300,
              size: 22,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isDone ? AppColors.primary : AppColors.gray200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDone ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
            Text(time, style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, PickupRequest request) {
    final user = context.watch<UserProvider>().user;
    final isRider = user?.role == UserRole.rider;
    final isSearching = request.status == PickupStatus.searching;
    final canContact = request.status != PickupStatus.searching && request.status != PickupStatus.pending;

    if (isRider && isSearching) {
      return SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () async {
            final rider = PickupRider(
              id: user?.id ?? 'r1',
              name: user?.name ?? 'Rider Marcus',
              avatar: AppImages.avatarPlaceholder,
              vehicleInfo: 'Electric Trike • GEX-902',
              contactNumber: user?.phoneNumber ?? '+1 555 999 0000',
              rating: user?.ecoRating ?? 4.9,
              estimatedArrival: '10 mins',
            );
            final success = await context.read<PickupProvider>().acceptPickup(request.id, rider);
            if (success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job accepted! Navigate to pickup point.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Accept Pickup Job', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      );
    }

    if (isRider && !isSearching && request.status != PickupStatus.completed) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                context.read<PickupProvider>().updateStatus(request.id, PickupStatus.completed);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pickup completed! Points awarded.')));
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Mark Completed'),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/chat-details', arguments: request.customerId),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: canContact ? () {
              Navigator.pushNamed(context, '/chat-details', arguments: request.assignedRider?.id ?? 'r1');
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.gray300,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_bubble_outline),
                const SizedBox(width: 12),
                Text(
                  canContact ? 'Start a Chat with Rider' : 'Chat Unavailable', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ],
            ),
          ),
        ),
        if (!canContact) ...[
          const SizedBox(height: 12),
          Text(
            'You can contact your rider once assigned.',
            style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.bodySmall?.color),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
