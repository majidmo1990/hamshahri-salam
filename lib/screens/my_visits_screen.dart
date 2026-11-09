import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../utils/date_formatter.dart';
import 'login_screen.dart';

class MyVisitsScreen extends StatefulWidget {
  final bool embedded;
  const MyVisitsScreen({super.key, this.embedded = false});

  @override
  State<MyVisitsScreen> createState() => _MyVisitsScreenState();
}

class _MyVisitsScreenState extends State<MyVisitsScreen> {
  final ApiService _api = ApiService();
  List<Map<String, dynamic>> _visits = [];
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
    _api.init().then((_) => _loadVisits());
  }

  Future<void> _loadVisits() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _api.getMyVisits();
      if (!mounted) return;
      setState(() {
        _visits = list;
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

  Future<void> _deleteVisit(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف رزرو'),
        content: const Text('مطمئنی می‌خوای این رزرو رو حذف کنی؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('لغو'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    if (!mounted) return;
    try {
      await _api.dio.delete('/api/my/visits/$id');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('رزرو حذف شد')),
      );
      _loadVisits();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حذف ناموفق: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? _buildError(isDark)
            : _visits.isEmpty
                ? _buildEmptyState(isDark)
                : RefreshIndicator(
                    onRefresh: _loadVisits,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _visits.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildVisitCard(_visits[index], isDark),
                    ),
                  );

    if (widget.embedded) return body;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(
          title: const Text('رزرو بازدید'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadVisits,
            ),
          ],
        ),
        body: SafeArea(child: body),
      ),
    );
  }

  Widget _buildVisitCard(Map<String, dynamic> v, bool isDark) {
    final status = v['status'] as String? ?? 'new';
    final st = _statusMap[status] ?? _statusMap['new']!;
    final color = st['color'] as Color;
    final imageUrl = v['property_image'] as String?;

    return Container(
      padding: const EdgeInsets.all(12),
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
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(isDark),
                      )
                    : _placeholder(isDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v['property_title'] ?? 'آگهی',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: color.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            st['label'] as String,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (status == 'new')
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'تا ۲۴ ساعت آینده تماس می‌گیریم',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    color: Colors.red[400], size: 20),
                tooltip: 'حذف رزرو',
                onPressed: () => _deleteVisit(v['id'] as int),
              ),
            ],
          ),
          if ((v['notes'] ?? '').toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                      v['notes'],
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              isDark ? Colors.grey[400] : Colors.grey[600]),
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

  Widget _placeholder(bool isDark) => Container(
        width: 70,
        height: 70,
        color: isDark ? AppColors.darkBg : AppColors.skyBlue,
        child: Icon(Icons.home_rounded,
            color: isDark ? Colors.grey[600] : Colors.grey[400]),
      );

  Widget _buildError(bool isDark) {
    final isAuthError = (_error ?? '').contains('وارد شوید') ||
        (_error ?? '').contains('unauthorized') ||
        (_error ?? '').contains('401');
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAuthError ? Icons.lock_outline : Icons.error_outline,
              size: 60,
              color: isAuthError ? AppColors.goldLight : Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              isAuthError ? 'ورود به حساب' : 'خطا در دریافت بازدیدها',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              isAuthError
                  ? 'برای مشاهده رزروها لطفاً وارد شوید'
                  : (_error ?? ''),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            if (isAuthError)
              ElevatedButton.icon(
                onPressed: () async {
                  final ok = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  if (ok == true && mounted) _loadVisits();
                },
                icon: const Icon(Icons.login_rounded, size: 18),
                label: const Text('ورود به حساب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldPrimary,
                  foregroundColor: Colors.black,
                ),
              )
            else
              ElevatedButton(
                  onPressed: _loadVisits, child: const Text('تلاش دوباره')),
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
          Icon(Icons.event_note_outlined,
              size: 60,
              color: isDark ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 16),
          Text('هنوز رزرو بازدیدی ثبت نکرده‌اید',
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[500] : Colors.grey[500])),
          const SizedBox(height: 8),
          Text('از صفحه جزئیات هر ملک، «رزرو و درخواست تماس» بزنید',
              style: TextStyle(
                  fontSize: 11.5,
                  color: isDark ? Colors.grey[600] : Colors.grey[400])),
        ],
      ),
    );
  }
}
