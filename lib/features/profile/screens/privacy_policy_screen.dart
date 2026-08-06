import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              'Privacy Policy', 
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 28)
            ),
            const SizedBox(height: 8),
            Text('Last updated: August 2026', style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 32),
            _buildSection(context, '1. Introduction', 'At EcoConnect, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and share your personal information when you use our waste management and marketplace services.'),
            _buildSection(context, '2. Information We Collect', 'We collect information you provide directly, such as your name, email, phone number, and address. For riders, we also collect government ID verification and location data during active sessions.'),
            _buildSection(context, '3. How We Use Information', 'We use your information to provide waste collection services, process marketplace transactions, and communicate updates. Your location is used only to facilitate pickups between customers and riders.'),
            _buildSection(context, '4. Data Sharing', 'Your contact details are shared only with the assigned rider or customer once a pickup is confirmed. We do not sell your personal data to third parties.'),
            _buildSection(context, '5. Your Rights', 'You have the right to access, correct, or delete your personal information. You can manage most of your data directly through the Profile settings.'),
            _buildSection(context, '6. Security', 'We implement industry-standard security measures to protect your data. However, no method of transmission over the internet is 100% secure.'),
            _buildSection(context, '7. Contact Us', 'If you have any questions about this Privacy Policy, please contact us at support@ecoconnect.com.'),
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
