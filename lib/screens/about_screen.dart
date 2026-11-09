import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('باز کردن لینک ممکن نشد: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(title: const Text('درباره ما')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // لوگو
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.goldLight.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home_rounded,
                      size: 50, color: AppColors.goldLight),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'همشهری سلام',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'نسخه ۱.۰.۰',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // توضیحات
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkGoldBorder
                        : AppColors.skyBlue,
                  ),
                ),
                child: Text(
                  'همشهری سلام یک پلتفرم برای ثبت و جستجوی آگهی املاک است. '
                  'کاربران می‌توانند آگهی ملک خود را ثبت کنند، '
                  'آگهی‌های دیگران را ببینند و برای بازدید درخواست دهند.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.8,
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // سازنده
              Text(
                'سازنده',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkGoldBorder
                        : AppColors.skyBlue,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.business_rounded,
                            size: 20, color: AppColors.goldLight),
                        const SizedBox(width: 8),
                        Text(
                          'رومیلند',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      Icons.language,
                      'rumiland.org',
                      isDark,
                      onTap: () => _openUrl(context, 'https://rumiland.org'),
                    ),
                    _infoRow(
                      Icons.email_outlined,
                      'support@rumiland.org',
                      isDark,
                      onTap: () => _openUrl(
                          context, 'mailto:support@rumiland.org'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // لینک‌ها
              _menuTile(
                'حریم خصوصی',
                Icons.privacy_tip_outlined,
                isDark,
                () => _openUrl(context,
                    'https://hamshahri.rumiland.org/hamshahri/privacy'),
              ),
              _menuTile(
                'شرایط استفاده',
                Icons.description_outlined,
                isDark,
                () => _openUrl(context,
                    'https://hamshahri.rumiland.org/hamshahri/privacy'),
              ),
              const SizedBox(height: 30),

              // کپی‌رایت
              Center(
                child: Text(
                  '© ۱۴۰۴ رومیلند. تمامی حقوق محفوظ است.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, bool isDark,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: isDark ? Colors.grey[500] : Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const Spacer(),
            Icon(Icons.open_in_new_rounded,
                size: 14,
                color: isDark ? Colors.grey[600] : Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(
      String title, IconData icon, bool isDark, VoidCallback onTap) {
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
          title,
          style: TextStyle(
            fontSize: 13.5,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.chevron_left_rounded,
          color: isDark ? Colors.grey[500] : Colors.grey[400],
        ),
      ),
    );
  }
}
