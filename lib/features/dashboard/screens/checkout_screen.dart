import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/market_listing_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/success_screen.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/market_provider.dart';
import '../../../models/order_model.dart';
import '../../../../l10n/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  final MarketListing listing;
  final double quantity;

  const CheckoutScreen({super.key, required this.listing, required this.quantity});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPayment = PaymentMethod.momo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<UserProvider>().user;
    final totalPrice = widget.listing.pricePerKg * widget.quantity;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSummary(context, l10n),
            const SizedBox(height: 24),
            _buildDeliveryInfo(context, user),
            const SizedBox(height: 24),
            _buildPaymentMethod(context, l10n),
            const SizedBox(height: 40),
            _buildTotalSection(context, l10n, totalPrice),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Confirm Order',
              onPressed: () => _handleConfirmOrder(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerTheme.color ?? AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary', 
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(widget.listing.imageUrls.first, width: 60, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.listing.title, 
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
                    ),
                    Text(
                      '${widget.quantity.toStringAsFixed(0)} ${widget.listing.unit} x ${widget.listing.pricePerKg.toStringAsFixed(0)} ${l10n.pts}', 
                      style: Theme.of(context).textTheme.bodySmall
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(BuildContext context, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerTheme.color ?? AppColors.gray200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address', 
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
              ),
              TextButton(
                onPressed: () {}, 
                child: Text('Change', style: TextStyle(color: Theme.of(context).colorScheme.primary))
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  user?.address ?? 'No address provided', 
                  style: Theme.of(context).textTheme.bodyMedium
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method', 
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(context, PaymentMethod.momo, Icons.phone_android, 'Mobile Money (MoMo)'),
        const SizedBox(height: 12),
        _buildPaymentOption(context, PaymentMethod.orangeMoney, Icons.smartphone, 'Orange Money (OM)'),
        const SizedBox(height: 12),
        _buildPaymentOption(context, PaymentMethod.cashOnDelivery, Icons.payments_outlined, 'Cash on Delivery'),
      ],
    );
  }

  Widget _buildPaymentOption(BuildContext context, PaymentMethod method, IconData icon, String label) {
    bool isSelected = _selectedPayment == method;
    return InkWell(
      onTap: () => setState(() => _selectedPayment = method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : (Theme.of(context).dividerTheme.color ?? AppColors.gray200), 
            width: isSelected ? 2 : 1
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color),
            const SizedBox(width: 16),
            Text(
              label, 
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)
            ),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context, AppLocalizations l10n, double total) {
    return Column(
      children: [
        _buildPriceRow(context, 'Subtotal', '$total ${l10n.pts}'),
        const SizedBox(height: 8),
        _buildPriceRow(context, 'Delivery Fee', '0 ${l10n.pts}'),
        const Divider(height: 32),
        _buildPriceRow(context, 'Total', '$total ${l10n.pts}', isTotal: true),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: isTotal ? Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold) : Theme.of(context).textTheme.bodyMedium
        ),
        Text(
          value, 
          style: isTotal 
            ? AppTextStyles.h3.copyWith(color: Theme.of(context).colorScheme.primary) 
            : Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
        ),
      ],
    );
  }

  void _handleConfirmOrder(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final totalPrice = widget.listing.pricePerKg * widget.quantity;

    Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        // Update marketplace quantity
        await context.read<MarketProvider>().purchaseListing(widget.listing.id, widget.quantity);
        
        // Update user points (deduct)
        if (context.mounted) {
          await context.read<UserProvider>().updatePoints(-totalPrice / 100); // Scale for proto
        }

        if (context.mounted) {
          Navigator.pop(context); // Close loading
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => SuccessScreen(
                title: 'Order Placed!',
                subtitle: 'Your transaction has been successfully processed. The seller has been notified.',
                buttonText: 'Back to Market',
                onButtonPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ),
            (route) => false,
          );
        }
      }
    });
  }
}
