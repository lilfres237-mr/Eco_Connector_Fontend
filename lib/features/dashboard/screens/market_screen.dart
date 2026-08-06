import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../widgets/app_logo.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../providers/market_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/market_listing_model.dart';
import 'product_details_screen.dart';
import '../../../core/constants/app_images.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Metals', 'Plastic', 'Glass', 'Paper', 'Electronics', 'Organic', 'Textile'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final marketProvider = context.watch<MarketProvider>();
    final user = context.watch<UserProvider>().user;
    
    // Filter listings based on category
    final listings = _selectedFilterIndex == 0 
        ? marketProvider.listings 
        : marketProvider.listings.where((l) => l.category.name.toLowerCase() == _filters[_selectedFilterIndex].toLowerCase()).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(variant: LogoVariant.icon),
        ),
        title: Text(
          'EcoConnect',
          style: AppTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildSearchAndFilter(context, l10n),
                const SizedBox(height: 20),
                _buildFilters(context),
                const SizedBox(height: 24),
                _buildSectionHeader(context, l10n),
                const SizedBox(height: 16),
                _buildMaterialsGrid(listings, l10n),
                const SizedBox(height: 120),
              ],
            ),
          ),
          _buildBottomBalanceCard(context, user?.ecoRating ?? 0.0), 
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.postWaste),
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.search),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Theme.of(context).textTheme.bodySmall?.color, size: 20),
                  const SizedBox(width: 8),
                  Text('Search materials...', style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).textTheme.bodySmall?.color)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Icon(Icons.tune, color: Theme.of(context).iconTheme.color),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_filters.length, (index) {
          bool isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilterIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                ),
                child: Text(
                  _filters[index],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Available Materials',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headlineSmall?.color),
        ),
        Text(
          'View Map',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialsGrid(List<MarketListing> listings, AppLocalizations l10n) {
    if (listings.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text('No materials found', style: AppTextStyles.bodyMedium),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listings.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final listing = listings[index];
        return _buildMarketCard(context, listing, l10n);
      },
    );
  }

  Widget _buildMarketCard(BuildContext context, MarketListing listing, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(listing: listing),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      AppImages.getSafeImage(listing.imageUrls.first),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(color: Theme.of(context).disabledColor),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            listing.rating.toString(),
                            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${listing.pricePerKg.toStringAsFixed(0)} ${l10n.pts}/${listing.unit}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen(listing: listing),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 0,
                      ),
                      child: Text(listing.category == ListingCategory.metals ? 'Contact' : 'Buy'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBalanceCard(BuildContext context, double balance) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR BALANCE',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(balance * 500).toStringAsFixed(0)} pts', // Proto formula
                  style: AppTextStyles.h1.copyWith(
                    color: Theme.of(context).textTheme.headlineLarge?.color,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
