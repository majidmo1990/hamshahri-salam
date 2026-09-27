import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ActionCards extends StatelessWidget {
  final VoidCallback onViewProperties;
  final VoidCallback onSell;
  final VoidCallback onRent;

  const ActionCards({
    super.key,
    required this.onViewProperties,
    required this.onSell,
    required this.onRent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.search_rounded,
            label: 'خرید',
            filled: true,
            onTap: onViewProperties,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionCard(
            icon: Icons.sell_outlined,
            label: 'فروش',
            filled: false,
            onTap: onSell,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionCard(
            icon: Icons.home_work_outlined,
            label: 'اجاره',
            filled: false,
            onTap: onRent,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = filled
        ? AppColors.primaryBlue
        : (isDark ? AppColors.darkSurface : Colors.white);
    final foreground = filled
        ? Colors.black
        : (isDark ? AppColors.lightBlue : AppColors.primaryBlue);
    final border = filled
        ? null
        : Border.all(
            color: isDark ? AppColors.darkGoldBorder : AppColors.skyBlue,
            width: 1.2,
          );

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: border,
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            children: [
              Icon(icon, size: 26, color: foreground),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      color: foreground,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
