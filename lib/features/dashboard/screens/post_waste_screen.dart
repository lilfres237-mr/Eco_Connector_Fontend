import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../models/market_listing_model.dart';
import '../../../providers/market_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/success_screen.dart';
import '../../../core/constants/app_images.dart';

import 'dart:io';
import '../../../services/image_picker_service.dart';

class PostWasteScreen extends StatefulWidget {
  const PostWasteScreen({super.key});

  @override
  State<PostWasteScreen> createState() => _PostWasteScreenState();
}

class _PostWasteScreenState extends State<PostWasteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  ListingCategory _selectedCategory = ListingCategory.plastic;
  final List<String> _localImagePaths = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Post Waste'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageUploader(),
              const SizedBox(height: 32),
              CustomTextField(
                label: 'Title',
                hint: 'e.g. Clean Plastic Bottles',
                controller: _titleController,
                validator: (v) => v!.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 24),
              Text('Category', style: AppTextStyles.label),
              const SizedBox(height: 8),
              DropdownButtonFormField<ListingCategory>(
                initialValue: _selectedCategory,
                items: ListingCategory.values.map((c) => DropdownMenuItem(value: c, child: Text(c.name.toUpperCase()))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Description',
                hint: 'Describe the waste condition...',
                controller: _descController,
                validator: (v) => v!.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Price (${l10n.pts}/kg)',
                      hint: '100',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Quantity (kg)',
                      hint: '10',
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Post Listing',
                isLoading: _isLoading,
                onPressed: _handlePostListing,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upload Images', style: AppTextStyles.label),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _localImagePaths.length + 1,
            itemBuilder: (context, index) {
              if (index == _localImagePaths.length) {
                return GestureDetector(
                  onTap: () async {
                    final paths = await ImagePickerService.pickMultiImage();
                    if (paths.isNotEmpty) {
                      setState(() {
                        _localImagePaths.addAll(paths);
                      });
                    }
                  },
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: AppColors.gray100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gray200, style: BorderStyle.solid),
                    ),
                    child: const Center(child: Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 32)),
                  ),
                );
              }
              return Stack(
                children: [
                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: FileImage(File(_localImagePaths[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => setState(() => _localImagePaths.removeAt(index)),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _handlePostListing() async {
    if (_formKey.currentState!.validate()) {
      if (_localImagePaths.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one image')));
        return;
      }

      setState(() => _isLoading = true);
      
      final user = context.read<UserProvider>().user;
      final newListing = MarketListing(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        category: _selectedCategory,
        pricePerKg: double.tryParse(_priceController.text) ?? 0,
        availableQuantity: double.tryParse(_quantityController.text) ?? 0,
        sellerId: user?.id ?? 'me',
        sellerName: user?.name ?? 'Anonymous',
        sellerAvatar: user?.profileImageUrl ?? AppImages.avatarPlaceholder,
        imageUrls: _localImagePaths, // Using local paths for mock session
        location: user?.address ?? 'Local Area',
        createdAt: DateTime.now(),
        condition: 'Good',
        isVerified: true,
      );

      final marketProvider = context.read<MarketProvider>();
      await marketProvider.addListing(newListing);

      if (mounted) {
        setState(() => _isLoading = false);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SuccessScreen(
              title: 'Posted Successfully!',
              subtitle: 'Your waste listing is now live in the marketplace.',
              buttonText: 'View Market',
              onButtonPressed: () => Navigator.pop(context),
            ),
          ),
        );
      }
    }
  }
}
