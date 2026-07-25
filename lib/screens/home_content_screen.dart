import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/home_slider.dart';
import '../widgets/action_cards.dart';
import '../widgets/property_card.dart';
import 'property_type_screen.dart';
import 'property_list_screen.dart';

class HomeContentScreen extends StatelessWidget {
  final List<PropertyPreview> allProperties;

  const HomeContentScreen({super.key, required this.allProperties});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final popular = allProperties.take(3).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(context, isDark),
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
              itemCount: popular.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return PropertyCard(property: popular[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
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
