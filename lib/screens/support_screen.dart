import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _openUrl(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('برنامه مورد نظر نصب نیست')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در باز کردن لینک: $e')),
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
        appBar: AppBar(title: const Text('پشتیبانی')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // هدر
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.goldLight.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.support_agent_rounded,
                      size: 45, color: AppColors.goldLight),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'پشتیبانی همشهری سلام',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'برای سوال، پیشنهاد یا شکایت با ما در تماس باشید',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // تماس تلفنی
              _contactCard(
                icon: Icons.phone_rounded,
                title: 'تماس تلفنی',
                subtitle: '۰۹۱۲۷۴۵۸۱۷۲',
                color: Colors.green,
                isDark: isDark,
                onTap: () => _openUrl(context, 'tel:09127458172'),
              ),

              // پیامک
              _contactCard(
                icon: Icons.sms_rounded,
                title: 'پیامک',
                subtitle: '۰۹۱۲۷۴۵۸۱۷۲',
                color: Colors.orange,
                isDark: isDark,
                onTap: () => _openUrl(context, 'sms:09127458172'),
              ),

              // ایمیل
              _contactCard(
                icon: Icons.email_rounded,
                title: 'ایمیل',
                subtitle: 'hihamshahri@gmail.com',
                color: Colors.blue,
                isDark: isDark,
                onTap: () => _openUrl(context, 'mailto:hihamshahri@gmail.com'),
              ),

              // روبیکا
              _contactCard(
                icon: Icons.chat_bubble_rounded,
                title: 'روبیکا',
                subtitle: '@amlak_hamshahrisalam',
                color: const Color(0xFF8B5CF6),
                isDark: isDark,
                onTap: () =>
                    _openUrl(context, 'https://rubika.ir/amlak_hamshahrisalam'),
              ),

              const SizedBox(height: 30),

              // ساعات پاسخگویی
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
                child: Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 22, color: AppColors.goldLight),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ساعات پاسخگویی',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'شنبه تا پنجشنبه: ۹ صبح - ۶ عصر',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'پاسخگویی معمولاً کمتر از ۲۴ ساعت',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkGoldBorder : AppColors.skyBlue,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
        trailing: Icon(
          Icons.open_in_new_rounded,
          size: 18,
          color: isDark ? Colors.grey[500] : Colors.grey[400],
        ),
      ),
    );
  }
}
