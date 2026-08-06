import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';

class AddressSettingsScreen extends StatelessWidget {
  const AddressSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Address Settings', 
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
              'Saved Addresses', 
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 16),
            _buildAddressCard(
              context,
              label: 'Home',
              address: '123 Maple St, Springfield, IL 62704',
              isDefault: true,
            ),
            const SizedBox(height: 16),
            _buildAddressCard(
              context,
              label: 'Office',
              address: '456 Business Way, Suite 200, Springfield, IL 62701',
              isDefault: false,
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Add New Address',
              type: ButtonType.outline,
              icon: Icons.add,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, {required String label, required String address, required bool isDefault}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDefault ? Theme.of(context).colorScheme.primary : (Theme.of(context).dividerTheme.color ?? AppColors.gray200), 
          width: isDefault ? 2 : 1
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), 
              shape: BoxShape.circle
            ),
            child: Icon(
              label == 'Home' ? Icons.home_outlined : Icons.work_outline, 
              color: Theme.of(context).colorScheme.primary
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label, 
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                    ),
                    if (isDefault)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary, 
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: const Text('DEFAULT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(address, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Theme.of(context).disabledColor, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
