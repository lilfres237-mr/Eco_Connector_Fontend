import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/auth/screens/rider_register_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/dashboard/screens/create_request_screen.dart';
import '../../features/profile/screens/address_settings_screen.dart';
import '../../features/profile/screens/help_center_screen.dart';
import '../../features/profile/screens/language_settings_screen.dart';
import '../../features/profile/screens/settings_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/dashboard/screens/pickups_screen.dart';
import '../../features/dashboard/screens/post_waste_screen.dart';
import '../../features/dashboard/screens/checkout_screen.dart';
import '../../features/dashboard/screens/product_details_screen.dart';
import '../../features/dashboard/screens/tip_details_screen.dart';
import '../../features/dashboard/screens/search_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/notifications/screens/chat_details_screen.dart';
import '../../models/market_listing_model.dart';
import '../../models/tip_model.dart';

import '../../features/profile/screens/about_screen.dart';
import '../../features/profile/screens/privacy_policy_screen.dart';
import '../../features/profile/screens/terms_of_service_screen.dart';

import '../../features/profile/screens/rider_control_panel_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case AppRoutes.otp:
        return MaterialPageRoute(builder: (_) => const OTPScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case AppRoutes.createRequest:
        return MaterialPageRoute(builder: (_) => const CreateRequestScreen());
      case AppRoutes.pickups:
        return MaterialPageRoute(builder: (_) => const PickupsScreen());
      case AppRoutes.postWaste:
        return MaterialPageRoute(builder: (_) => const PostWasteScreen());
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case AppRoutes.tipDetails:
        if (args is TipModel) {
          return MaterialPageRoute(builder: (_) => TipDetailsScreen(tip: args));
        }
        return _errorRoute();
      case AppRoutes.riderControlPanel:
        return MaterialPageRoute(builder: (_) => const RiderControlPanelScreen());
      case AppRoutes.riderRegister:
        return MaterialPageRoute(builder: (_) => const RiderRegisterScreen());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.addressSettings:
        return MaterialPageRoute(builder: (_) => const AddressSettingsScreen());
      case AppRoutes.helpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
      case AppRoutes.languageSettings:
        return MaterialPageRoute(builder: (_) => const LanguageSettingsScreen());
      case AppRoutes.about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case AppRoutes.termsOfService:
        return MaterialPageRoute(builder: (_) => const TermsOfServiceScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case '/product-details':
        if (args is MarketListing) {
          return MaterialPageRoute(builder: (_) => ProductDetailsScreen(listing: args));
        }
        return _errorRoute();
      case '/checkout':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => CheckoutScreen(
              listing: args['listing'],
              quantity: args['quantity'],
            ),
          );
        }
        return _errorRoute();
      case '/chat-details':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => ChatDetailsScreen(chatRoomId: args));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
