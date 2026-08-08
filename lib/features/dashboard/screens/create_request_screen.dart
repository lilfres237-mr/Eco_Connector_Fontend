import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/pickup_request.dart';
import '../../../providers/pickup_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_picker_screen.dart';
import '../../../core/config/app_config.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _descController = TextEditingController();
  final _weightController = TextEditingController();
  final _contactController = TextEditingController();
  String _selectedType = 'Plastic Waste';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;
  // LatLng? _selectedLocation; // Removed unused field

  void _pickLocationOnMap() async {
    if (!AppConfig.isGoogleMapsConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Live map is unavailable. Add a Google Maps API key to enable it.')),
      );
      return;
    }
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerScreen()),
    );
    if (result != null) {
      setState(() {
        // _selectedLocation = result;
        _addressController.text = '${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: const Text('Request Pickup'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Pickup Address',
                hint: '123 Sustainability Ave, Green City',
                controller: _addressController,
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => v!.isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _pickLocationOnMap,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Pick on Map'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Package Description',
                hint: 'e.g. 3 bags of mixed plastic bottles',
                controller: _descController,
                prefixIcon: Icons.description_outlined,
              ),
              const SizedBox(height: 20),
              Text('Waste Type', style: AppTextStyles.label),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                items: ['Plastic Waste', 'Metals', 'Paper & Cardboard', 'Organic Scraps']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Est. Weight (Kg)',
                      hint: '15',
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null) return 'Enter a valid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pickup Date', style: AppTextStyles.label),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 30)),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.gray300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textSecondary),
                                const SizedBox(width: 8),
                                Text('${_selectedDate.day}/${_selectedDate.month}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Contact Number',
                hint: '+1 234 567 890',
                controller: _contactController,
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 40),
              CustomButton(
                text: 'Confirm Request',
                isLoading: _isLoading,
                onPressed: _submitRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final pickupProvider = context.read<PickupProvider>();
      final user = context.read<UserProvider>().user;
      await Future.delayed(const Duration(seconds: 2));
      
      final newRequest = PickupRequest(
        id: DateTime.now().toString(),
        customerId: user?.id ?? 'u1',
        customerName: user?.name ?? 'John Doe',
        address: _addressController.text,
        description: _descController.text,
        wasteType: _selectedType,
        weightKg: double.tryParse(_weightController.text) ?? 0,
        dateTime: _selectedDate,
        contactNumber: _contactController.text,
        trackingNumber: 'ECO-${DateTime.now().millisecond}-SF',
        status: PickupStatus.pending,
      );

      if (!mounted) return;
      pickupProvider.addRequest(newRequest);
      setState(() => _isLoading = false);
      if (mounted) _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary, size: 64),
            const SizedBox(height: 16),
            Text('Request Sent!', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            const Text('A rider will be assigned shortly.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Go to Home',
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to home
              },
            ),
          ],
        ),
      ),
    );
  }
}
