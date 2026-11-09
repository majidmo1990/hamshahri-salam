import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_data.dart';
import '../providers/auth_provider.dart';
import '../widgets/home_slider.dart';
import '../widgets/action_cards.dart';
import '../widgets/featured_carousel.dart';
import 'property_type_screen.dart';
import 'category_selection_screen.dart';
import 'property_list_screen.dart';
import 'search_screen.dart';
import '../widgets/filter_sheet.dart';
import 'notifications_screen.dart';
import 'login_screen.dart';
import 'video_booking_screen.dart';

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  Future<bool> _ensureLogin(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn) return true;
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    return ok == true && context.mounted;
  }

  Future<void> _goToCategory(BuildContext context, DealType dealType) async {
    if (!await _ensureLogin(context)) return;
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CategorySelectionScreen(dealType: dealType)),
    );
  }

  Future<void> _openBooking(BuildContext context) async {
    if (!await _ensureLogin(context)) return;
    if (!context.mounted) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VideoBookingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listings = context.watch<AppData>().listings;
    final featured = listings.take(6).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(context, isDark),
          const SizedBox(height: 16),
          const HomeSlider(),
          const SizedBox(height: 20),
          ActionCards(
            onViewProperties: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PropertyListScreen()),
            ),
            onSell: () => _goToCategory(context, DealType.sell),
            onRent: () => _goToCategory(context, DealType.rent),
          ),
          const SizedBox(height: 16),
          _bookingBanner(context, isDark),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ملک‌های ویژه',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87)),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PropertyListScreen()),
                ),
                child: const Text('مشاهده همه',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.primaryBlue, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          featured.isEmpty
              ? SizedBox(
                  height: 100,
                  child: Center(
                    child: Text('هنوز ملکی ثبت نشده است',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  ),
                )
              : FeaturedCarousel(items: featured),
        ],
      ),
    );
  }

  Widget _bookingBanner(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _openBooking(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: isDark
                ? [AppColors.goldDark.withValues(alpha: 0.55), AppColors.darkSurface]
                : [AppColors.goldHighlight, AppColors.skyBlue],
          ),
          border: Border.all(color: AppColors.goldLight.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.goldLight.withValues(alpha: 0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.videocam_rounded, color: AppColors.goldLight, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('فیلمبرداری حرفه‌ای از ملک شما',
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 3),
                  Text('زمان رزرو کنید، ما برایتان فیلم می‌گیریم',
                      style: TextStyle(
                          fontSize: 11.5, color: isDark ? Colors.grey[300] : Colors.black54)),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white70 : Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.skyBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search_rounded,
                      size: 20, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text('جستجو در املاک...',
                      style: TextStyle(
                          fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600])),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            final result = await showFilterSheet(
              context,
              isDark,
            );
            if (result != null) {
              await context.read<AppData>().loadProperties(
                minPrice: result.minPrice,
                maxPrice: result.maxPrice,
                minArea: result.minArea,
                maxArea: result.maxArea,
              );
            }
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.skyBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.tune_rounded,
                color: isDark ? Colors.grey[300] : AppColors.primaryBlue),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          ),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.skyBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.notifications_none_rounded,
                color: isDark ? Colors.grey[300] : AppColors.primaryBlue),
          ),
        ),
      ],
    );
  }
}
