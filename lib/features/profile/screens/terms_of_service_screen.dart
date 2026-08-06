import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Terms of Service'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service', 
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 28)
            ),
            const SizedBox(height: 8),
            Text('Effective Date: August 1, 2026', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 32),
            _buildSection(context, '1. Acceptance of Terms', 'By accessing or using the EcoConnect app, you agree to be bound by these Terms of Service and all applicable laws and regulations.'),
            _buildSection(context, '2. User Roles', 'Customers may request waste pickups and purchase items. Riders agree to provide professional collection services and verify their identity with a government-issued ID.'),
            _buildSection(context, '3. Waste Collection', 'Users must accurately describe the type and weight of waste. Hazardous materials are strictly prohibited. EcoConnect reserves the right to refuse collection of non-compliant materials.'),
            _buildSection(context, '4. Marketplace Transactions', 'All sales are final once confirmed through MoMo, OM, or Cash on Delivery. EcoConnect acts as a platform to facilitate transactions between independent buyers and sellers.'),
            _buildSection(context, '5. Prohibited Activities', 'You may not use the service for any illegal purpose, post fraudulent listings, or harass other users. Violation of these terms may result in account termination.'),
            _buildSection(context, '6. Limitation of Liability', 'EcoConnect is not liable for any indirect, incidental, or consequential damages resulting from your use of the service or interactions between users.'),
            _buildSection(context, '7. Dispute Resolution', 'Any disputes arising from marketplace transactions or pickup services should first be addressed through our Help Center support system.'),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold, 
              color: Theme.of(context).colorScheme.primary
            )
          ),
          const SizedBox(height: 12),
          Text(content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}
