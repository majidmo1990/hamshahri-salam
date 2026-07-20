import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/home_slider.dart';
import '../widgets/action_cards.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/property_card.dart';
import 'property_type_screen.dart';
import 'property_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  final List<PropertyPreview> _popularProperties = const [
    PropertyPreview(
      title: 'آپارتمان ۱۲۰ متری',
      location: 'سعادت‌آباد',
      price: '۳ میلیارد تومان',
      area: '۱۲۰ متر',
      imageUrl: 'assets/images/slider1.jpg',
      views: 340,
    ),
    PropertyPreview(
      title: 'مغازه تجاری',
      location: 'خیابان ولیعصر',
      price: 'رهن ۲۰۰ / اجاره ۱۵',
      area: '۴۵ متر',
      imageUrl: 'assets/images/slider2.jpg',
      views: 210,
    ),
    PropertyPreview(
      title: 'زمین مزروعی',
      location: 'کرج، اطراف',
      price: '۸۰۰ میلیون تومان',
      area: '۱۰۰۰ متر',
      imageUrl: 'assets/images/slider3.jpg',
      views: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopBar(isDark),
                const SizedBox(height: 16),
                const HomeSlider(),
                const SizedBox(height: 20),
                ActionCards(
                  onViewProperties: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PropertyListScreen(),
                      ),
                    );
                  },
                  onAddProperty: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PropertyTypeScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'پربازدیدترین‌ها',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PropertyListScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'مشاهده همه',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _popularProperties.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return PropertyCard(
                        property: _popularProperties[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: _navIndex,
          onTap: (index) {
            setState(() => _navIndex = index);
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.skyBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'جستجو در املاک...',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.skyBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: isDark ? Colors.grey[300] : AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
}
