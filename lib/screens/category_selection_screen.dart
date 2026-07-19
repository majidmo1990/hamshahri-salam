import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'property_type_screen.dart';
import 'property_form_screen.dart';

class PropertyCategory {
  final String id;
  final String label;
  final IconData icon;

  const PropertyCategory({
    required this.id,
    required this.label,
    required this.icon,
  });
}

class CategorySelectionScreen extends StatelessWidget {
  final DealType dealType;

  const CategorySelectionScreen({super.key, required this.dealType});

  List<PropertyCategory> get _categories {
    if (dealType == DealType.rent) {
      return const [
        PropertyCategory(
          id: 'rent_shop',
          label: 'اجاره مغازه',
          icon: Icons.storefront_outlined,
        ),
        PropertyCategory(
          id: 'rent_unit',
          label: 'اجاره واحد',
          icon: Icons.apartment_outlined,
        ),
        PropertyCategory(
          id: 'rent_farmland',
          label: 'اجاره زمین مزروعی',
          icon: Icons.grass_outlined,
        ),
        PropertyCategory(
          id: 'rent_villa',
          label: 'اجاره واحد ویلایی',
          icon: Icons.villa_outlined,
        ),
      ];
    } else {
      return const [
        PropertyCategory(
          id: 'sell_shop',
          label: 'مغازه',
          icon: Icons.storefront_outlined,
        ),
        PropertyCategory(
          id: 'sell_villa',
          label: 'واحد ویلایی',
          icon: Icons.villa_outlined,
        ),
        PropertyCategory(
          id: 'sell_apartment',
          label: 'واحد آپارتمانی',
          icon: Icons.apartment_outlined,
        ),
        PropertyCategory(
          id: 'sell_farmland',
          label: 'زمین مزروعی',
          icon: Icons.grass_outlined,
        ),
        PropertyCategory(
          id: 'sell_land',
          label: 'زمین',
          icon: Icons.terrain_outlined,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(dealType == DealType.rent ? 'اجاره' : 'فروش'),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final category = _categories[index];
            return _CategoryTile(
              category: category,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PropertyFormScreen(
                      dealType: dealType,
                      category: category,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final PropertyCategory category;
  final VoidCallback onTap;

  const _CategoryTile({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
              width: 1.1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryBlue.withValues(alpha: 0.15)
                      : AppColors.skyBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  category.icon,
                  color: AppColors.primaryBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  category.label,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_left_rounded,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
