import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'support_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _openLogin(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('خوش آمدید 👋'),
          backgroundColor: AppColors.goldDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('خروج از حساب'),
        content: const Text('مطمئنی می‌خوای خارج بشی؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('لغو'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'خروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      await context.read<AuthProvider>().logout();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('خارج شدید'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();

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
                    auth.isLoggedIn
                        ? (auth.fullName?.isNotEmpty == true
                            ? auth.fullName!
                            : 'کاربر')
                        : 'کاربر مهمان',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    auth.isLoggedIn
                        ? (auth.phone ?? '')
                        : 'برای ثبت اطلاعات کامل، وارد شوید',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!auth.isLoggedIn)
                    SizedBox(
                      width: 200,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () => _openLogin(context),
                        icon: const Icon(Icons.login_rounded, size: 18),
                        label: const Text(
                          'ورود / ثبت‌نام',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldPrimary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: 200,
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text(
                          'خروج از حساب',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              isDark ? Colors.white : Colors.black87,
                          side: BorderSide(
                            color: isDark
                                ? AppColors.darkGoldBorder
                                : AppColors.lightBorder,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
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
