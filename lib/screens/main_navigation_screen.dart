import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/property_card.dart';
import 'home_content_screen.dart';
import 'favorites_screen.dart';
import 'reservations_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _navIndex = 0;

  final List<PropertyPreview> _allProperties = const [
    PropertyPreview(
      id: 'prop1',
      title: 'آپارتمان ۱۲۰ متری',
      location: 'سعادت‌آباد',
      price: '۳ میلیارد تومان',
      area: '۱۲۰ متر',
      imageUrl: 'assets/images/slider1.jpg',
      views: 340,
    ),
    PropertyPreview(
      id: 'prop2',
      title: 'مغازه تجاری',
      location: 'خیابان ولیعصر',
      price: 'رهن ۲۰۰ / اجاره ۱۵',
      area: '۴۵ متر',
      imageUrl: 'assets/images/slider2.jpg',
      views: 210,
    ),
    PropertyPreview(
      id: 'prop3',
      title: 'زمین مزروعی',
      location: 'کرج، اطراف',
      price: '۸۰۰ میلیون تومان',
      area: '۱۰۰۰ متر',
      imageUrl: 'assets/images/slider3.jpg',
      views: 150,
    ),
    PropertyPreview(
      id: 'prop4',
      title: 'واحد ویلایی نوساز',
      location: 'لواسان',
      price: 'رهن ۵۰۰ / اجاره ۴۰',
      area: '۲۰۰ متر',
      imageUrl: 'assets/images/slider1.jpg',
      views: 95,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      HomeContentScreen(allProperties: _allProperties),
      FavoritesScreen(allProperties: _allProperties),
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
        bottomNavigationBar: BottomNav(
          currentIndex: _navIndex,
          onTap: (index) => setState(() => _navIndex = index),
        ),
      ),
    );
  }
}
