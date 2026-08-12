import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/user_provider.dart';
import '../../../models/user_model.dart';
import 'home_screen.dart';
import '../../dashboard/screens/market_screen.dart';
import '../../dashboard/screens/tips_screen.dart';
import '../../notifications/screens/messages_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../dashboard/screens/pickups_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void setTab(int index) {
    setState(() => _selectedIndex = index);
  }

  List<Widget> _getScreens(AppMode mode) {
    if (mode == AppMode.rider) {
      return [
        const HomeScreen(),
        const PickupsScreen(),
        const TipsScreen(),
        const MessagesScreen(),
        const ProfileScreen(),
      ];
    }
    return [
      const HomeScreen(),
      const MarketScreen(),
      const TipsScreen(),
      const MessagesScreen(),
      const ProfileScreen(),
    ];
  }

  List<BottomNavigationBarItem> _getNavItems(AppMode mode) {
    if (mode == AppMode.rider) {
      return const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), activeIcon: Icon(Icons.local_shipping), label: 'Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), activeIcon: Icon(Icons.lightbulb), label: 'Tips'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
      ];
    }
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), activeIcon: Icon(Icons.storefront), label: 'Market'),
      BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), activeIcon: Icon(Icons.lightbulb), label: 'Tips'),
      BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userMode = context.watch<UserProvider>().user?.currentMode ?? AppMode.household;
    final screens = _getScreens(userMode);
    
    // Safety check for index out of bounds when switching modes
    if (_selectedIndex >= screens.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: setTab,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          selectedLabelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedLabelStyle: AppTextStyles.bodySmall.copyWith(fontSize: 10),
          items: _getNavItems(userMode),
        ),
      ),
    );
  }
}
