import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.search_rounded, label: 'جستجو'),
    _NavItem(icon: Icons.favorite_border_rounded, label: 'علاقه‌مندی‌ها'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'رزروها'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'پروفایل'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF7F7F7),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFDDDDDD),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final selected = index == currentIndex;
          final color = selected
              ? AppColors.primaryBlue
              : (isDark ? Colors.grey[500] : Colors.grey[600]);

          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_items[index].icon, size: 22, color: color),
                  const SizedBox(height: 3),
                  Text(
                    _items[index].label,
                    style: TextStyle(fontSize: 10, color: color),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
