import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/routes/app_routes.dart';
import '../../../providers/pickup_provider.dart';
import '../../../providers/user_provider.dart';

class RiderControlPanelScreen extends StatefulWidget {
  const RiderControlPanelScreen({super.key});

  @override
  State<RiderControlPanelScreen> createState() => _RiderControlPanelScreenState();
}

class _RiderControlPanelScreenState extends State<RiderControlPanelScreen> {
  bool _isActive = true;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final pickupProvider = context.watch<PickupProvider>();
    final riderJobs = pickupProvider.getRiderJobs(user?.id ?? '');
    final totalEarnings = riderJobs.length * 25.0; // Mock earnings per job

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Rider Control Panel'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 32),
            _buildEarningsSummary(riderJobs.length, totalEarnings),
            const SizedBox(height: 32),
            CustomButton(
              text: 'View Pickup Requests',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.pickups),
            ),
            const SizedBox(height: 16),
            Text('Vehicle Information', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildInfoTile(Icons.electric_bike, 'Vehicle Type', 'Electric Trike'),
            _buildInfoTile(Icons.numbers, 'License Plate', 'GEX-902'),
            _buildInfoTile(Icons.verified, 'Status', 'Verified & Insured'),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Manage Schedule',
              type: ButtonType.outline,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Contact Support',
              type: ButtonType.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isActive ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Theme.of(context).disabledColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isActive ? Icons.power_settings_new : Icons.power_settings_new,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isActive ? 'You are Online' : 'You are Offline',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  _isActive ? 'Visible to new pickup requests' : 'Currently not receiving new jobs',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (v) => setState(() => _isActive = v),
            activeThumbColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSummary(int jobsCount, double earnings) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TODAY\'S EARNINGS', style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text('\$${earnings.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('+12%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat('Jobs', jobsCount.toString()),
              _buildMiniStat('Distance', '${jobsCount * 2}km'),
              _buildMiniStat('Points', '${jobsCount * 40}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
