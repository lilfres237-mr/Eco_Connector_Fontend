import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/app_logo.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../dashboard/screens/pickup_details_screen.dart';
import '../../../providers/pickup_provider.dart';
import '../../../models/pickup_request.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/user_model.dart';
import '../widgets/quick_action_button.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/config/app_config.dart';
import '../../../widgets/map_fallback.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<UserProvider>().user;
    final currentMode = user?.currentMode ?? AppMode.household;
    final isRiderMode = currentMode == AppMode.rider;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(variant: LogoVariant.icon),
        ),
        title: Text(
          l10n.appTitle,
          style: AppTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_none, color: Theme.of(context).iconTheme.color),
                Consumer<NotificationProvider>(
                  builder: (context, provider, child) {
                    if (provider.unreadCount == 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                        child: Text(
                          '${provider.unreadCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.tune, color: Theme.of(context).iconTheme.color),
            onSelected: (value) {
              if (value == 'pickups') {
                Navigator.pushNamed(context, AppRoutes.pickups);
              } else if (value == 'settings') {
                Navigator.pushNamed(context, isRiderMode ? AppRoutes.riderControlPanel : AppRoutes.settings);
              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pickups',
                child: Row(
                  children: [
                    Icon(Icons.local_shipping_outlined, size: 20, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(isRiderMode ? 'Available Jobs' : 'View Pickups', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(isRiderMode ? Icons.dashboard_outlined : Icons.settings_outlined, size: 20, color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 12),
                    Text(isRiderMode ? 'Control Panel' : 'Settings', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user?.name ?? "User"}', 
              style: AppTextStyles.h2.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headlineMedium?.color,
              )
            ),
            Text(
              isRiderMode 
                ? 'Check available pickups and start earning!'
                : 'Your contribution is making a difference today!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            if (isRiderMode) _buildRiderEarningsCard(context) else _buildRewardsCard(context, l10n),
            const SizedBox(height: 24),
            _buildNewsCarousel(),
            const SizedBox(height: 24),
            if (isRiderMode) _buildRiderPickupsButton(context) else _buildRequestButton(context, l10n),
            const SizedBox(height: 32),
            _buildSectionHeader(
              context,
              isRiderMode ? 'Available Requests' : l10n.upcomingPickup, 
              l10n.manage, 
              () => Navigator.pushNamed(context, AppRoutes.pickups)
            ),
            const SizedBox(height: 16),
            if (isRiderMode) _buildAvailablePickupsList(context) else _buildUpcomingPickupCard(context, l10n),
            const SizedBox(height: 32),
            _buildQuickActions(context, l10n, isRiderMode),
            const SizedBox(height: 32),
            Text(
              isRiderMode ? 'Active Route' : l10n.nearbyRider,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 16),
            _buildNearbyRiderMap(context, l10n, isRiderMode, user?.id),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRiderEarningsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Earnings', 
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.7))
          ),
          const SizedBox(height: 8),
          Text(
            '\$1,240.00', 
            style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32)
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Completed', '42'),
              _buildStatItem('Rating', '4.9'),
              _buildStatItem('EcoPoints', '850'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildRewardsCard(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.ecoRewards,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'FHD',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '120 ${l10n.pts}',
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.trending_up, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              l10n.goalProgress(60),
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderPickupsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.pickups),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text('View Available Jobs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildRequestButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.createRequest),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                l10n.requestPickup,
                style: AppTextStyles.button.copyWith(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCarousel() {
    return SizedBox(
      height: 180,
      child: PageView(
        children: [
          _buildCarouselItem(
            AppImages.paperDefault,
            'Did you know?',
            'Recycling 1 ton of paper saves 17 trees and 7,000 gallons of water.',
          ),
          _buildCarouselItem(
            AppImages.plasticDefault,
            'Plastic Awareness',
            'Over 8 million tons of plastic enter our oceans every year.',
          ),
          _buildCarouselItem(
            AppImages.metalDefault,
            'Metal Recycling',
            'Recycling aluminum saves 95% of the energy needed to make new metal.',
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(String imagePath, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(AppImages.getSafeImage(imagePath)),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.5), BlendMode.darken),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('TIPS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20), maxLines: 2, overflow: TextOverflow.ellipsis),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.3), maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String action, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            action,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailablePickupsList(BuildContext context) {
    return Consumer<PickupProvider>(
      builder: (context, provider, child) {
        final available = provider.availableForRiders;
        if (available.isEmpty) {
          return Center(
            child: Text(
              'No available pickups at the moment.',
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
            ),
          );
        }
        return Column(
          children: available.take(2).map((request) => _buildRiderJobCard(context, request)).toList(),
        );
      }
    );
  }

  Widget _buildRiderJobCard(BuildContext context, PickupRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), 
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.address, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ), 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis
                ),
                Text(
                  '${request.wasteType} • ${request.weightKg}kg', 
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  )
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PickupDetailsScreen(request: request))),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: const Text('View', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingPickupCard(BuildContext context, AppLocalizations l10n) {
    return Consumer<PickupProvider>(
      builder: (context, provider, child) {
        final requests = provider.activeRequests;
        if (requests.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            child: Center(
              child: Text(
                'No upcoming pickups scheduled.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          );
        }
        final request = requests.first;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${request.dateTime.day}/${request.dateTime.month}, 9:00 AM',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${request.wasteType} (${request.weightKg} Kg)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.status.name.toUpperCase(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => PickupDetailsScreen(request: request))
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.viewDetails,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16, color: Theme.of(context).colorScheme.primary),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, AppLocalizations l10n, bool isRider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickActionButton(icon: isRider ? Icons.map_outlined : Icons.location_on_outlined, label: isRider ? 'Route' : l10n.trackRider, onTap: () {}),
        QuickActionButton(icon: Icons.calendar_today_outlined, label: l10n.schedule, onTap: () {}),
        QuickActionButton(icon: Icons.history, label: l10n.history, onTap: () {}),
        QuickActionButton(icon: isRider ? Icons.account_balance_outlined : Icons.account_balance_wallet_outlined, label: isRider ? 'Bank' : l10n.wallet, onTap: () {}),
      ],
    );
  }

  Widget _buildNearbyRiderMap(BuildContext context, AppLocalizations l10n, bool isRider, String? userId) {
    return Consumer<PickupProvider>(
      builder: (context, provider, child) {
        final activeRequest = isRider 
          ? provider.getRiderJobs(userId ?? '').isNotEmpty ? provider.getRiderJobs(userId ?? '').first : null
          : provider.activeRequests.isNotEmpty ? provider.activeRequests.first : null;
          
        final isSearching = !isRider && activeRequest?.status == PickupStatus.searching;

        return Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: AppConfig.isGoogleMapsConfigured
                          ? GoogleMap(
                              initialCameraPosition: const CameraPosition(target: LatLng(37.7749, -122.4194), zoom: 13),
                              zoomControlsEnabled: false,
                              markers: !isSearching
                                  ? {
                                      const Marker(
                                        markerId: MarkerId('rider1'),
                                        position: LatLng(37.7849, -122.4294),
                                        infoWindow: InfoWindow(title: 'Rider: Marcus Chen'),
                                      ),
                                    }
                                  : {},
                            )
                          : const MapFallback(),
                    ),
                    if (isSearching)
                      Container(
                        color: Colors.black.withValues(alpha: 0.4),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(color: Colors.white),
                              const SizedBox(height: 16),
                              Text('Searching for Rider...', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Row(
                          children: [
                            Container(width: 8, height: 8, decoration: BoxDecoration(color: isSearching ? Colors.orange : Colors.green, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text(isSearching ? 'Pending' : l10n.available, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: !isSearching ? Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(AppImages.avatarPlaceholder),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isRider ? 'Customer: Alice Green' : 'Rider: Marcus Chen', 
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
                          ),
                          Text(
                            isRider ? '1.2 km away • Pick up scheduled' : '2.4 km away • 8 mins', 
                            style: Theme.of(context).textTheme.bodySmall
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(context, '/chat-details', arguments: isRider ? (activeRequest?.customerId ?? 'u2') : 'r1'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.primary, size: 20),
                      ),
                    ),
                  ],
                ) : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    isRider ? 'Looking for new jobs...' : 'You can contact your rider once assigned.',
                    style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
