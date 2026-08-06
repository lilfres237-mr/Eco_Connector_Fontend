import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/tip_model.dart';

class TipDetailsScreen extends StatelessWidget {
  final TipModel tip;
  const TipDetailsScreen({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetaInfo(context),
                  const SizedBox(height: 16),
                  Text(
                    tip.title, 
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 24)
                  ),
                  const SizedBox(height: 24),
                  _buildContent(context),
                  const SizedBox(height: 48),
                  _buildRelatedTips(context),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha: 0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          tip.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Theme.of(context).disabledColor,
            child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tip.category.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Icon(Icons.access_time, size: 16, color: Theme.of(context).textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(tip.readingTime, style: Theme.of(context).textTheme.bodySmall),
        const Spacer(),
        Text(tip.date, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tip.content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.8,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedTips(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Tips', 
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildRelatedCard(context, 'Reducing Single-Use Plastic', 'Plastic'),
              _buildRelatedCard(context, 'Benefits of Mulching', 'Organic'),
              _buildRelatedCard(context, 'Zero Waste Lifestyle', 'General'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedCard(BuildContext context, String title, String category) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
