import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterResult {
  final int? minPrice;
  final int? maxPrice;
  final int? minArea;
  final int? maxArea;

  FilterResult({this.minPrice, this.maxPrice, this.minArea, this.maxArea});
}

Future<FilterResult?> showFilterSheet(BuildContext context, bool isDark) {
  return showModalBottomSheet<FilterResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _FilterSheet(isDark: isDark),
  );
}

class _FilterSheet extends StatefulWidget {
  final bool isDark;
  const _FilterSheet({required this.isDark});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  final _minPriceCtrl = TextEditingController();
  final _maxPriceCtrl = TextEditingController();
  final _minAreaCtrl = TextEditingController();
  final _maxAreaCtrl = TextEditingController();

  @override
  void dispose() {
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    _minAreaCtrl.dispose();
    _maxAreaCtrl.dispose();
    super.dispose();
  }

  String _toEnglishDigits(String s) {
    return s.split('').map((c) {
      final i = '۰۱۲۳۴۵۶۷۸۹'.indexOf(c);
      return i >= 0 ? '$i' : c;
    }).join();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'فیلتر پیشرفته',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'قیمت (تومان)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _numberField(_minPriceCtrl, 'حداقل', isDark)),
                  const SizedBox(width: 8),
                  Expanded(child: _numberField(_maxPriceCtrl, 'حداکثر', isDark)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'متراژ (متر مربع)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _numberField(_minAreaCtrl, 'حداقل', isDark)),
                  const SizedBox(width: 8),
                  Expanded(child: _numberField(_maxAreaCtrl, 'حداکثر', isDark)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, FilterResult()),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Text(
                        'پاک کردن',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        final result = FilterResult(
                          minPrice: int.tryParse(
                              _toEnglishDigits(_minPriceCtrl.text.trim())),
                          maxPrice: int.tryParse(
                              _toEnglishDigits(_maxPriceCtrl.text.trim())),
                          minArea: int.tryParse(
                              _toEnglishDigits(_minAreaCtrl.text.trim())),
                          maxArea: int.tryParse(
                              _toEnglishDigits(_maxAreaCtrl.text.trim())),
                        );
                        Navigator.pop(context, result);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldPrimary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('اعمال فیلتر'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField(TextEditingController c, String hint, bool isDark) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.grey[400],
          fontSize: 12,
        ),
        filled: true,
        fillColor: isDark
            ? AppColors.darkBg
            : AppColors.skyBlue.withValues(alpha: 0.4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
