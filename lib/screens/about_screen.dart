import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
              Center(
                child: Image.asset('assets/images/logo.png', width: 130),
              ),
              const SizedBox(height: 20),
              Text(
                'همشهری سلام',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'خدمات شهری هوشمند | یکپارچه',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              _sectionCard(
                isDark,
                title: 'درباره پلتفرم',
                text:
                    'همشهری سلام یک پلتفرم آنلاین برای ثبت، جستجو و معامله‌ی ملک است. ما تلاش می‌کنیم فرآیند خرید، فروش و اجاره‌ی ملک را ساده، سریع و قابل‌اعتماد کنیم.',
              ),
              const SizedBox(height: 14),
              _sectionCard(
                isDark,
                title: 'ماموریت ما',
                text:
                    'اتصال مستقیم مالکان و متقاضیان ملک، بدون واسطه‌های غیرضروری، با تمرکز بر شفافیت و سرعت در معاملات.',
              ),
              const SizedBox(height: 14),
              _sectionCard(
                isDark,
                title: 'نسخه اپلیکیشن',
                text: 'نسخه ۱.۰.۰',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(bool isDark, {required String title, required String text}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkGoldBorder : AppColors.skyBlue,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.7,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
