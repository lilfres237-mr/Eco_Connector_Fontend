import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../core/constants/app_images.dart';

import 'dart:io';
import '../../../services/image_picker_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;
  String? _localImagePath;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _nameController = TextEditingController(text: user?.name);
    _phoneController = TextEditingController(text: user?.phoneNumber);
    _emailController = TextEditingController(text: user?.email);
    _addressController = TextEditingController(text: user?.address);
    _bioController = TextEditingController(text: user?.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.editProfile,
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatarPicker(user?.profileImageUrl),
              const SizedBox(height: 40),
              CustomTextField(
                label: l10n.fullName,
                hint: l10n.enterName,
                controller: _nameController,
                prefixIcon: Icons.person_outline,
                validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: l10n.phoneNumber,
                hint: l10n.enterPhone,
                controller: _phoneController,
                prefixIcon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.isEmpty ? l10n.requiredField : null,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: l10n.email,
                hint: l10n.enterEmail,
                controller: _emailController,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return l10n.requiredField;
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return l10n.invalidEmail;
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: l10n.address,
                hint: l10n.enterAddress,
                controller: _addressController,
                prefixIcon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: l10n.bio,
                hint: l10n.enterBio,
                controller: _bioController,
                prefixIcon: Icons.info_outline,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: l10n.saveChanges,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedUser = user!.copyWith(
                      name: _nameController.text,
                      email: _emailController.text,
                      phoneNumber: _phoneController.text,
                      address: _addressController.text,
                      bio: _bioController.text,
                      profileImageUrl: _localImagePath ?? user.profileImageUrl,
                    );
                    
                    // Update persistent state
                    await userProvider.updateUser(updatedUser);
                    
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.profileUpdated)),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker(String? imageUrl) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          final path = await ImagePickerService.pickImage();
          if (path != null) {
            setState(() {
              _localImagePath = path;
            });
          }
        },
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.gray200,
              backgroundImage: _localImagePath != null 
                  ? FileImage(File(_localImagePath!)) as ImageProvider
                  : AssetImage(AppImages.getSafeImage(imageUrl, fallback: AppImages.avatarPlaceholder)) as ImageProvider,
              child: (_localImagePath == null && imageUrl == null) ? const Icon(Icons.person, size: 60, color: AppColors.gray300) : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
