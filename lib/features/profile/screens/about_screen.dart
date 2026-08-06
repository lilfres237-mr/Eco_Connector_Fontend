import 'package:flutter/material.dart';
import '../../../widgets/app_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('About EcoConnect'),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: AppLogo(size: 200),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 48),
            _buildInfoSection(
              context,
              'Our Mission',
              'EcoConnect is dedicated to bridging the gap between waste generators and recycling facilities. Our mission is to make recycling accessible, rewarding, and efficient for everyone in the community.',
            ),
            const SizedBox(height: 24),
            _buildInfoSection(
              context,
              'App Version',
              'v1.0.0+1\nReleased August 2026',
            ),
            const SizedBox(height: 48),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              '© 2026 EcoConnect. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
