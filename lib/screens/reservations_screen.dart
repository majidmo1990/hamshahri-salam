import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'my_visits_screen.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: const Text('رزروهای من'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.goldLight,
          labelColor: isDark ? Colors.white : Colors.black87,
          unselectedLabelColor:
              isDark ? Colors.grey[500] : Colors.grey[600],
          tabs: const [
            Tab(text: 'رزرو فیلمبرداری'),
            Tab(text: 'رزرو بازدید'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            _VideoBookingsTab(),
            MyVisitsScreen(embedded: true),
          ],
        ),
      ),
    );
  }
}

class _VideoBookingsTab extends StatefulWidget {
  const _VideoBookingsTab();

  @override
  State<_VideoBookingsTab> createState() => _VideoBookingsTabState();
}

class _VideoBookingsTabState extends State<_VideoBookingsTab> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;
  String? _error;

  static const _statusMap = {
    'new': {'label': 'در انتظار تماس', 'color': Color(0xFF5b9dff)},
    'called': {'label': 'تماس گرفته شد', 'color': Color(0xFFf0b429)},
    'no_answer': {'label': 'پاسخگو نبود', 'color': Color(0xFFf97316)},
    'confirmed': {'label': 'تایید شده', 'color': Color(0xFF3ecf8e)},
    'done': {'label': 'انجام شد', 'color': Color(0xFFa89f8c)},
    'cancelled': {'label': 'لغو شد', 'color': Color(0xFFef5b5b)},
  };

  @override
  void initState() {
    super.initState();
    _api.init().then((_) => _loadBookings());
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _api.getMyBookings();
      if (!mounted) return;
      setState(() {
        _bookings = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _buildError(isDark);
    }
    if (_bookings.isEmpty) {
      return _buildEmptyState(isDark);
    }
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _buildBookingCard(_bookings[index], isDark),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> b, bool isDark) {
    final status = b['status'] as String? ?? 'new';
    final st = _statusMap[status] ?? _statusMap['new']!;
    final color = st['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ردیف اول: آدرس + badge
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 16, color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  b['address'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.4)),
                ),
                child: Text(
                  st['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ردیف دوم: تاریخ + ساعت
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                b['date'] ?? '',
                style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey[300] : Colors.grey[700]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time_rounded,
                  size: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                b['time'] ?? '',
                style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey[300] : Colors.grey[700]),
              ),
            ],
          ),

          // ردیف سوم: توضیحات
          if (b['notes'] != null && (b['notes'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBg : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes,
                      size: 14,
                      color: isDark ? Colors.grey[500] : Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      b['notes'],
                      style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey[400]
                              : Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildError(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'خطا در دریافت رزروها',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadBookings,
              child: const Text('تلاش دوباره'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 60,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'هنوز رزروی ثبت نکرده‌اید',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'برای رزرو فیلمبرداری، از صفحه اصلی اقدام کنید',
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
