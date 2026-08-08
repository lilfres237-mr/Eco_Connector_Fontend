import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/app_logo.dart';
import '../../../core/routes/app_routes.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/user_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rememberMe = context.read<AuthProvider>().rememberMe;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: AppLogo(size: 150),
                ),
                const SizedBox(height: 60),
                Text(
                  'Login', 
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 12),
                Text(
                  'Welcome back. Enter your credentials to manage your waste services.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  label: 'Phone Number',
                  hint: '+237 000 0000',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your phone number';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Password',
                  hint: '........',
                  controller: _passwordController,
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your password';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: Theme.of(context).colorScheme.primary,
                              onChanged: (val) => setState(() => _rememberMe = val ?? false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Remember me',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
                      child: Text(
                        'Forgot Password?',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Login',
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      
                      // Mock login logic
                      await Future.delayed(const Duration(seconds: 1));
                      
                      // Determine role based on phone number for demo
                      // Riders use 600, Customers use everything else
                      final isRider = _phoneController.text.startsWith('600');
                      
                      final user = UserModel(
                        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
                        name: isRider ? 'Rider Marcus' : 'John Doe',
                        email: isRider ? 'marcus@rider.com' : 'john.doe@example.com',
                        phoneNumber: _phoneController.text,
                        role: isRider ? UserRole.rider : UserRole.customer,
                        address: isRider ? 'Rider Station A' : '123 Maple St, Springfield',
                      );

                      await authProvider.login(user, _rememberMe);
                      if (!context.mounted) return;
                      await context.read<UserProvider>().setUser(user);
                      setState(() => _isLoading = false);
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                    }
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(child: Divider(color: Theme.of(context).dividerColor, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR LOG IN WITH', 
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0)
                      ),
                    ),
                    Expanded(child: Divider(color: Theme.of(context).dividerColor, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildSocialButton(context, Icons.g_mobiledata, 'Google'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSocialButton(context, Icons.apple, 'Apple'),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Register',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon, String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Theme.of(context).dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Icon(icon, size: 32, color: Theme.of(context).iconTheme.color),
    );
  }
}
