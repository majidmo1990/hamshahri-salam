import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'category_selection_screen.dart';

enum DealType { rent, sell }

class PropertyTypeScreen extends StatelessWidget {
  const PropertyTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(title: const Text('ثبت ملک')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'نوع معامله',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _DealCard(
                      icon: Icons.sell_outlined,
                      label: 'فروش',
                      onTap: () => _goToCategories(context, DealType.sell),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _DealCard(
                      icon: Icons.home_work_outlined,
                      label: 'اجاره',
                      onTap: () => _goToCategories(context, DealType.rent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToCategories(BuildContext context, DealType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategorySelectionScreen(dealType: type),
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DealCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
              width: 1.2,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppColors.primaryBlue),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
