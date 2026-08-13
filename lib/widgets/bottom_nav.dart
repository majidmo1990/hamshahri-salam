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

  static const List<_NavItem> _leftItems = [
    _NavItem(icon: Icons.home_outlined, label: 'خانه', index: 0),
    _NavItem(icon: Icons.search_rounded, label: 'جستجو', index: 1),
  ];

  static const List<_NavItem> _rightItems = [
    _NavItem(icon: Icons.favorite_border_rounded, label: 'علاقه‌مندی', index: 2),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'رزروها', index: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BottomAppBar(
      color: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF7F7F7),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ..._leftItems.map((item) => _buildItem(item, isDark)),
          const SizedBox(width: 40),
          ..._rightItems.map((item) => _buildItem(item, isDark)),
          _buildProfileItem(isDark),
        ],
      ),
    );
  }

  Widget _buildItem(_NavItem item, bool isDark) {
    final selected = item.index == currentIndex;
    final color = selected
        ? AppColors.primaryBlue
        : (isDark ? Colors.grey[500] : Colors.grey[600]);

    return InkWell(
      onTap: () => onTap(item.index),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(item.label, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(bool isDark) {
    const index = 4;
    final selected = index == currentIndex;
    final color = selected
        ? AppColors.primaryBlue
        : (isDark ? Colors.grey[500] : Colors.grey[600]);

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline_rounded, size: 22, color: color),
            const SizedBox(height: 3),
            Text('پروفایل', style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final int index;
  const _NavItem({required this.icon, required this.label, required this.index});
}
