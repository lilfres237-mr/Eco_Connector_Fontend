import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/market_listing_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/constants/app_images.dart';

class ProductDetailsScreen extends StatefulWidget {
  final MarketListing listing;
  const ProductDetailsScreen({super.key, required this.listing});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double _quantity = 1.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageGallery(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 16),
                      _buildPriceAndQuantity(context, l10n),
                      const SizedBox(height: 32),
                      _buildSellerInfo(context, l10n),
                      const SizedBox(height: 32),
                      _buildDescription(context, l10n),
                      const SizedBox(height: 32),
                      _buildReviews(context, l10n),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildAppBar(context),
          _buildBottomAction(context, l10n),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: PageView.builder(
        itemCount: widget.listing.imageUrls.length,
        itemBuilder: (context, index) {
          return Image.asset(
            AppImages.getSafeImage(widget.listing.imageUrls[index]),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Theme.of(context).disabledColor),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Theme.of(context).colorScheme.primary),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.listing.category.name.toUpperCase(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  widget.listing.rating.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  ' (120+ reviews)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          widget.listing.title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).textTheme.bodySmall?.color),
            const SizedBox(width: 4),
            Text(
              widget.listing.location,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceAndQuantity(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.listing.pricePerKg.toStringAsFixed(0)} ${l10n.pts}/kg',
                style: AppTextStyles.h2.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              Text(
                'Available: ${widget.listing.availableQuantity} ${widget.listing.unit}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                  icon: Icon(Icons.remove, size: 20, color: Theme.of(context).colorScheme.primary),
                ),
                Text(
                  _quantity.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    if (_quantity < widget.listing.availableQuantity) {
                      setState(() => _quantity++);
                    }
                  },
                  icon: Icon(Icons.add, size: 20, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerInfo(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seller Information',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(AppImages.getSafeImage(widget.listing.sellerAvatar, fallback: AppImages.avatarPlaceholder)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.listing.sellerName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Verified Provider',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.blue),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/chat-details', arguments: widget.listing.sellerId);
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('Contact'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          widget.listing.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildReviews(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {}, 
              child: Text('See all', style: TextStyle(color: Theme.of(context).colorScheme.primary))
            ),
          ],
        ),
        // Mock reviews
        _buildReviewItem(context, 'Sarah J.', 5, 'Perfect quality materials, exactly as described.'),
        _buildReviewItem(context, 'Michael R.', 4, 'Good communication, though pickup took a bit longer.'),
      ],
    );
  }

  Widget _buildReviewItem(BuildContext context, String name, int rating, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                children: List.generate(5, (i) => Icon(Icons.star, size: 12, color: i < rating ? Colors.amber : Theme.of(context).disabledColor)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context, AppLocalizations l10n) {
    final totalPrice = widget.listing.pricePerKg * _quantity;
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Price', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  '${totalPrice.toStringAsFixed(0)} ${l10n.pts}',
                  style: AppTextStyles.h2.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: CustomButton(
                text: 'Proceed to Checkout',
                onPressed: () {
                  Navigator.pushNamed(
                    context, 
                    '/checkout', 
                    arguments: {
                      'listing': widget.listing,
                      'quantity': _quantity,
                    }
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
