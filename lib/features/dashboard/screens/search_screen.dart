import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/market_provider.dart';
import 'tips_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final marketProvider = context.watch<MarketProvider>();
    // Accessing tips from TipsScreen static list
    final tips = TipsScreen.allTips;

    final filteredTips = tips.where((t) => 
      t.title.toLowerCase().contains(_query.toLowerCase()) || 
      t.content.toLowerCase().contains(_query.toLowerCase())
    ).toList();

    final filteredMarket = marketProvider.listings.where((l) => 
      l.title.toLowerCase().contains(_query.toLowerCase()) || 
      l.description.toLowerCase().contains(_query.toLowerCase())
    ).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _query = val),
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search tips, market...',
              hintStyle: TextStyle(color: Theme.of(context).disabledColor),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.transparent,
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: _query.isEmpty 
        ? _buildTrendingSection(context)
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (filteredTips.isNotEmpty) ...[
                _buildSectionHeader(context, 'TIPS & GUIDES'),
                ...filteredTips.map((t) => _buildResultItem(context, Icons.lightbulb_outline, t.title, 'Tip Details', () {
                   Navigator.pushNamed(context, '/tip-details', arguments: t);
                })),
                const SizedBox(height: 24),
              ],
              if (filteredMarket.isNotEmpty) ...[
                _buildSectionHeader(context, 'MARKETPLACE'),
                ...filteredMarket.map((l) => _buildResultItem(context, Icons.storefront_outlined, l.title, '${l.pricePerKg.toStringAsFixed(0)} pts/kg', () {
                   Navigator.pushNamed(context, '/product-details', arguments: l);
                })),
              ],
              if (filteredTips.isEmpty && filteredMarket.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      Icon(Icons.search_off, size: 64, color: Theme.of(context).disabledColor),
                      const SizedBox(height: 16),
                      Text(
                        'No results found for "$_query"', 
                        style: Theme.of(context).textTheme.bodyMedium
                      ),
                    ],
                  ),
                ),
            ],
          ),
    );
  }

  Widget _buildTrendingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trending Searches', 
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2)
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTrendingChip(context, 'Plastic Recycling'),
              _buildTrendingChip(context, 'Copper Prices'),
              _buildTrendingChip(context, 'Composting'),
              _buildTrendingChip(context, 'Eco Credits'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingChip(BuildContext context, String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () => setState(() {
        _query = label;
        _searchController.text = label;
      }),
      backgroundColor: Theme.of(context).cardTheme.color,
      labelStyle: Theme.of(context).textTheme.bodySmall,
      side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title, 
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold, 
          color: Theme.of(context).colorScheme.primary
        )
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), 
          shape: BoxShape.circle
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
      ),
      title: Text(
        title, 
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
      ),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: Icon(Icons.chevron_right, size: 16, color: Theme.of(context).disabledColor),
    );
  }
}
