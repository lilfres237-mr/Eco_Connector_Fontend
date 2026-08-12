import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../home/screens/main_screen.dart';
import '../widgets/profile_menu_item.dart';
import '../../home/widgets/stat_card.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../widgets/app_logo.dart';
import '../../../widgets/eco_image.dart';
import '../../../core/constants/app_images.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<UserProvider>().user;
    final settings = context.watch<SettingsProvider>();
    final isRider = user?.role == UserRole.rider;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.profile,
          style: AppTextStyles.h3.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.primary), onPressed: () {
             Navigator.pushNamed(context, AppRoutes.notifications);
          }),
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileHeader(context, user),
            const SizedBox(height: 32),
            _buildStatsSection(context, user),
            const SizedBox(height: 32),
            _buildMenuSection(context, l10n, settings, isRider),
            const SizedBox(height: 32),
            _buildReferralCard(context),
            const SizedBox(height: 32),
            Text(
              'EcoConnect v2.4.1 (Household Edition)',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.termsOfService),
              child: Text(
                'Terms & Privacy Policy',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel? user) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              EcoImage(
                imagePath: user?.profileImageUrl,
                width: 100,
                height: 100,
                shape: BoxShape.circle,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user?.name ?? 'User', 
          style: AppTextStyles.h2.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.headlineMedium?.color)
        ),
        Text(
          user?.phoneNumber ?? '+1 (000) 000-0000',
          style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).textTheme.bodySmall?.color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, UserModel? user) {
    final isRider = user?.role == UserRole.rider;
    final wasteRecycled = user?.wasteRecycledKg ?? 0.0;
    
    return Row(
      children: [
        Expanded(
          child: StatCard(
            iconWidget: const AppLogo(size: 24, variant: LogoVariant.icon),
            value: isRider ? '42' : '${wasteRecycled.toStringAsFixed(0)}kg', 
            label: isRider ? 'Completed Jobs' : 'Waste Recycled'
          )
        ),
        const SizedBox(width: 16),
        Expanded(child: StatCard(icon: Icons.stars, value: user?.ecoRating.toString() ?? '0.0', label: 'Eco Rating')),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, AppLocalizations l10n, SettingsProvider settings, bool isRider) {
    final userProvider = context.read<UserProvider>();
    final currentMode = userProvider.user?.currentMode ?? AppMode.household;

    return Column(
      children: [
        if (userProvider.user?.role == UserRole.rider)
          ProfileMenuItem(
            icon: currentMode == AppMode.household ? Icons.directions_bike : Icons.home_outlined,
            title: currentMode == AppMode.household ? 'Switch to Rider Mode' : 'Switch to Household Mode',
            subtitle: currentMode == AppMode.household ? 'Access your rider control panel and jobs.' : 'Use EcoConnect as a household user.',
            bgColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
            trailing: Switch(
              value: currentMode == AppMode.rider,
              onChanged: (value) {
                userProvider.switchMode(value ? AppMode.rider : AppMode.household);
              },
            ),
            onTap: () {
              userProvider.switchMode(currentMode == AppMode.household ? AppMode.rider : AppMode.household);
            },
          ),
        ProfileMenuItem(
          icon: Icons.grid_view_rounded,
          title: currentMode == AppMode.rider ? 'Rider Dashboard' : 'Customer Dashboard',
          bgColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          onTap: () {
            if (currentMode == AppMode.rider) {
               Navigator.pushNamed(context, AppRoutes.riderControlPanel);
            } else {
              final mainState = context.findAncestorStateOfType<MainScreenState>();
              if (mainState != null) {
                mainState.setTab(0);
              }
            }
          },
        ),
        ProfileMenuItem(
          icon: Icons.person_outline, 
          title: l10n.editProfile, 
          onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
        ),
        ProfileMenuItem(
          icon: Icons.language,
          title: l10n.language,
          subtitle: settings.language == AppLanguage.english ? l10n.english : l10n.french,
          onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
        ),
        if (!isRider)
          ProfileMenuItem(
            icon: Icons.location_on_outlined, 
            title: 'Address Settings', 
            onTap: () => Navigator.pushNamed(context, AppRoutes.addressSettings),
          ),
        ProfileMenuItem(
          icon: Icons.help_outline, 
          title: 'Help Center', 
          onTap: () => Navigator.pushNamed(context, AppRoutes.helpCenter),
        ),
        ProfileMenuItem(
          icon: Icons.info_outline, 
          title: 'About EcoConnect', 
          onTap: () => Navigator.pushNamed(context, AppRoutes.about),
        ),
        if (!isRider)
          ProfileMenuItem(
            icon: Icons.directions_bike,
            title: 'Earn as a Rider',
            subtitle: 'Join our collection fleet and earn money while making your neighborhood cleaner.',
            bgColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            trailing: Text(
              'Register',
              style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
            ),
            onTap: () => Navigator.pushNamed(context, AppRoutes.riderRegister),
          ),
        ProfileMenuItem(
          icon: Icons.logout,
          title: l10n.logout,
          color: Colors.red,
          bgColor: Colors.red.withValues(alpha: 0.05),
          onTap: () async {
            final authProvider = context.read<AuthProvider>();
             final userProvider = context.read<UserProvider>();
             await authProvider.logout();
             if (!context.mounted) return;
             await userProvider.setUser(null);
             if (!context.mounted) return;
             Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
          },
        ),
      ],
    );
  }

  Widget _buildReferralCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Refer a Friend',
                  style: AppTextStyles.h3.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get \$5 credit for every neighbor who joins EcoConnect.',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: const Text('Share Code', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.people_outline, color: Colors.white.withValues(alpha: 0.2), size: 80),
        ],
      ),
    );
  }
}
