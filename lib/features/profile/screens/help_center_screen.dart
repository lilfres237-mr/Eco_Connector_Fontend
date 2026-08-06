import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help Center', 
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
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
              'How can we help?', 
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 28)
            ),
            const SizedBox(height: 24),
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search for articles...',
                prefixIcon: Icon(Icons.search, color: Theme.of(context).disabledColor),
                fillColor: Theme.of(context).cardTheme.color,
              ),
            ),
            const SizedBox(height: 32),
            _buildFAQTile(context, 'How do I request a pickup?', 'To request a pickup, navigate to the Home screen and tap the "Request Pickup" button. Select your waste category, estimate the weight, and confirm your location. A rider will be assigned to you shortly.'),
            _buildFAQTile(context, 'What materials are recyclable?', 'We currently accept Plastic (PET, HDPE), Paper/Cardboard, Metals (Aluminum, Steel), and Glass. Please ensure all containers are rinsed and free of organic residue.'),
            _buildFAQTile(context, 'How are eco-credits calculated?', 'Credits are awarded based on the type and weight of materials collected. For example, Aluminum earns more points per kg than Paper. You can view the current rates in the Marketplace.'),
            _buildFAQTile(context, 'Marketplace & Payments', 'You can purchase recycled materials using Mobile Money (MoMo), Orange Money (OM), or Cash on Delivery. Once a purchase is confirmed, you will receive an order ID for tracking.'),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Icon(Icons.headset_mic_outlined, color: Theme.of(context).colorScheme.primary, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Still need help?', 
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our AI assistant is available 24/7. For urgent matters, we will connect you to a human agent.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Chat with Support',
                    onPressed: () => Navigator.pushNamed(context, '/chat-details', arguments: 'support'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile(BuildContext context, String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question, 
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)
        ),
        iconColor: Theme.of(context).colorScheme.primary,
        collapsedIconColor: Theme.of(context).disabledColor,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5)),
          ),
        ],
      ),
    );
  }
}
