import 'package:flutter/material.dart';
import '../../../widgets/app_logo.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/pickup_provider.dart';
import '../../home/widgets/pickup_card.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(variant: LogoVariant.icon),
        ),
        title: Text(
          'Pickup Requests',
          style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<PickupProvider>(
        builder: (context, provider, child) {
          final requests = provider.activeRequests;

          if (requests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_shipping_outlined, size: 80, color: AppColors.gray200),
                  const SizedBox(height: 16),
                  Text('No active requests', style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(
                    'Your scheduled pickups will appear here.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
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
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PickupCard(
                  date: DateFormat('EEEE, h:mm a').format(request.dateTime),
                  type: '${request.wasteType} (${request.weightKg} Kg)',
                  status: request.status.name[0].toUpperCase() + request.status.name.substring(1),
                  onViewDetails: () {
                    // Show details dialog
                    _showDetailsDialog(context, request);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Logic for requesting new pickup
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Request', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, dynamic request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Pickup Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Waste Type', request.wasteType),
            _detailRow('Weight', '${request.weightKg} Kg'),
            _detailRow('Date', DateFormat('MMM dd, yyyy').format(request.dateTime)),
            _detailRow('Time', DateFormat('h:mm a').format(request.dateTime)),
            _detailRow('Address', request.address),
            _detailRow('Status', request.status.name.toUpperCase()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: AppTextStyles.bodyMedium,
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
