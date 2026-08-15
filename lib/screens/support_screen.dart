import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
              Text(
                'چطور می‌توانیم کمکتان کنیم؟',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _contactTile(
                icon: Icons.call_outlined,
                label: 'تماس تلفنی',
                value: '۰۲۱-۱۲۳۴۵۶۷۸',
                isDark: isDark,
              ),
              _contactTile(
                icon: Icons.telegram,
                label: 'تلگرام',
                value: '@hamshahrisalam_support',
                isDark: isDark,
              ),
              _contactTile(
                icon: Icons.email_outlined,
                label: 'ایمیل',
                value: 'support@hamshahrisalam.ir',
                isDark: isDark,
              ),
              const SizedBox(height: 24),
              Text(
                'سوالات متداول',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _faqTile(
                isDark,
                question: 'چگونه ملک خود را ثبت کنم؟',
                answer:
                    'از صفحه اصلی، روی دکمه فروش ملک یا دکمه + پایین صفحه بزنید و مراحل فرم را تکمیل کنید.',
              ),
              _faqTile(
                isDark,
                question: 'چه زمانی آگهی من نمایش داده می‌شود؟',
                answer:
                    'پس از بررسی و تایید توسط مدیریت، آگهی شما در لیست ملک‌ها قابل مشاهده خواهد بود.',
              ),
              _faqTile(
                isDark,
                question: 'چگونه با فروشنده تماس بگیرم؟',
                answer:
                    'در صفحه جزئیات ملک، دکمه رزرو و درخواست تماس را بزنید و شماره خود را وارد کنید.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkGoldBorder : AppColors.skyBlue,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldLight, size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _faqTile(bool isDark, {required String question, required String answer}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkGoldBorder : AppColors.skyBlue,
        ),
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          iconColor: AppColors.goldLight,
          collapsedIconColor: isDark ? Colors.grey[400] : Colors.grey[600],
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 12,
                height: 1.7,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
