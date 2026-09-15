import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../widgets/bottom_nav.dart';
import 'home_content_screen.dart';
import 'favorites_screen.dart';
import 'reservations_screen.dart';
import 'profile_screen.dart';
import 'property_type_screen.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _navIndex = 0;

  Future<void> _onAddPropertyTap() async {
    final auth = context.read<AuthProvider>();

    // اگه لاگین نبود، اول صفحه ورود
    if (!auth.isLoggedIn) {
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      if (ok != true) return;
      if (!mounted) return;
    }

    // حالا برو به انتخاب نوع ملک
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PropertyTypeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      const HomeContentScreen(),
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
        extendBody: true,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 26),
          child: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.goldHighlight, AppColors.goldLight],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldHighlight.withValues(alpha: 0.55),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: isDark ? AppColors.darkBg : Colors.white,
                width: 3,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _onAddPropertyTap,
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNav(
          currentIndex: _navIndex,
          onTap: (index) => setState(() => _navIndex = index),
        ),
      ),
    );
  }
}
