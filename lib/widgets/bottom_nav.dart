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
    _NavItem(icon: Icons.home_outlined, label: 'خانه'),
    _NavItem(icon: Icons.favorite_border_rounded, label: 'علاقه‌مندی'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'رزروها'),
    _NavItem(icon: Icons.person_outline_rounded, label: 'پروفایل'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF9F5EB),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkGoldBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(0, _items[0], isDark),
            _buildItem(1, _items[1], isDark),
            const SizedBox(width: 56),
            _buildItem(2, _items[2], isDark),
            _buildItem(3, _items[3], isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index, _NavItem item, bool isDark) {
    final selected = index == currentIndex;
    final color =
        selected ? AppColors.goldLight : (isDark ? Colors.grey[500] : Colors.grey[600]);

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
