import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ActionCards extends StatelessWidget {
  final VoidCallback onViewProperties;
  final VoidCallback onAddProperty;

  const ActionCards({
    super.key,
    required this.onViewProperties,
    required this.onAddProperty,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.search_rounded,
            label: 'مشاهده ملک',
            filled: true,
            onTap: onViewProperties,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            icon: Icons.add_circle_outline_rounded,
            label: 'ثبت ملک',
            filled: false,
            onTap: onAddProperty,
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

    final Color background = filled
        ? AppColors.primaryBlue
        : (isDark ? AppColors.darkSurface : Colors.white);

    final Color foreground = filled
        ? Colors.white
        : (isDark ? AppColors.lightBlue : AppColors.primaryBlue);

    final Border? border = filled
        ? null
        : Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
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
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            children: [
              Icon(icon, size: 30, color: foreground),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
