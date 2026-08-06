import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo(size: 24, variant: LogoVariant.icon),
            const SizedBox(width: 8),
            Text('EcoConnect', style: AppTextStyles.h3.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text('Forgot Password', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              Text(
                'Enter your phone number and we will send you a code to reset your password.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              const CustomTextField(
                label: 'Phone Number',
                hint: '+1 (555) 000-0000',
                prefixIcon: Icons.phone_android_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 48),
              CustomButton(
                text: 'Send Code',
                onPressed: () {
                  // In a real app, this would trigger the OTP flow
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification code sent!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
