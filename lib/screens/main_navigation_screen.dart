import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import 'home_content_screen.dart';
import 'favorites_screen.dart';
import 'reservations_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'property_type_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      const HomeContentScreen(),
      const SearchScreen(),
      const FavoritesScreen(),
      const ReservationsScreen(),
      const ProfileScreen(),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: SafeArea(
          child: IndexedStack(
            index: _navIndex,
            children: screens,
          ),
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.goldHighlight.withValues(alpha: 0.5),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: AppColors.goldLight,
            elevation: 0,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PropertyTypeScreen()),
              );
            },
            child: const Icon(Icons.add_rounded, color: Colors.black, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNav(
          currentIndex: _navIndex,
          onTap: (index) => setState(() => _navIndex = index),
        ),
      ),
    );
  }
}
