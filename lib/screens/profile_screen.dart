import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import 'notifications_screen.dart';
import 'support_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: AppColors.goldLight.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 42,
                      color: AppColors.goldLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'کاربر مهمان',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'برای ثبت اطلاعات کامل، وارد شوید',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _menuTile(
              icon: Icons.dark_mode_outlined,
              label: 'حالت تیره / روشن',
              isDark: isDark,
              trailing: Switch(
                value: isDark,
                activeThumbColor: AppColors.goldLight,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
            ),
            _menuTile(
              icon: Icons.notifications_none_rounded,
              label: 'اعلان‌ها',
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
            ),
            _menuTile(
              icon: Icons.support_agent_rounded,
              label: 'پشتیبانی',
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SupportScreen()),
                );
              },
            ),
            _menuTile(
              icon: Icons.info_outline_rounded,
              label: 'درباره ما',
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String label,
    required bool isDark,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkGoldBorder : AppColors.skyBlue,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.goldLight),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.chevron_left_rounded,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
      ),
    );
  }
}
