import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppNotification {
  final String title;
  final String message;
  final String time;
  final IconData icon;

  const AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const List<AppNotification> _notifications = [
    AppNotification(
      title: 'خوش آمدید',
      message: 'به همشهری سلام خوش آمدید! می‌توانید همین حالا اولین آگهی خود را ثبت کنید.',
      time: 'همین الان',
      icon: Icons.celebration_outlined,
    ),
    AppNotification(
      title: 'راهنمای ثبت ملک',
      message: 'برای ثبت سریع‌تر آگهی، عکس‌های باکیفیت و توضیحات کامل وارد کنید.',
      time: 'دیروز',
      icon: Icons.lightbulb_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(title: const Text('اعلان‌ها')),
        body: SafeArea(
          child: _notifications.isEmpty
              ? Center(
                  child: Text(
                    'اعلانی وجود ندارد',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[500] : Colors.grey[500],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final n = _notifications[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.goldLight.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(n.icon,
                                color: AppColors.goldLight, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      n.title,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      n.time,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: isDark
                                            ? Colors.grey[500]
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  n.message,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.6,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
