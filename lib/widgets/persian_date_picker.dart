import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PersianDate {
  final int year;
  final int month;
  final int day;

  PersianDate(this.year, this.month, this.day);

  static PersianDate fromDateTime(DateTime d) {
    const gDaysInMonth = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    int gy = d.year;
    int gm = d.month;
    int gd = d.day;
    int gy2 = (gm > 2) ? (gy + 1) : gy;
    int days = 355666 + (365 * gy) + ((gy2 + 3) ~/ 4) - ((gy2 + 99) ~/ 100) + ((gy2 + 399) ~/ 400) + gd + gDaysInMonth[gm - 1];
    int jy = -1595 + (33 * (days ~/ 12053));
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;
    if (days > 365) {
      jy += (days - 1) ~/ 365;
      days = (days - 1) % 365;
    }
    int jm, jd;
    if (days < 186) {
      jm = 1 + (days ~/ 31);
      jd = 1 + (days % 31);
    } else {
      jm = 7 + ((days - 186) ~/ 30);
      jd = 1 + ((days - 186) % 30);
    }
    return PersianDate(jy, jm, jd);
  }

  static String monthName(int m) {
    const names = [
      'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
      'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'
    ];
    return names[(m - 1).clamp(0, 11)];
  }

  String get formatted => '$year/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
  String get longFormatted => '$day ${monthName(month)} $year';
}

Future<DateTime?> showSimplePersianDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final now = PersianDate.fromDateTime(initialDate);
  int selectedYear = now.year;
  int selectedMonth = now.month;
  int selectedDay = now.day;

  final result = await showDialog<PersianDate>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                'انتخاب تاریخ بازدید',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // نمایش تاریخ انتخاب شده در یک باکس
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBg : AppColors.skyBlue.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      PersianDate(selectedYear, selectedMonth, selectedDay).longFormatted,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // ردیف انتخاب سال، ماه، روز با استایل بهتر
                  Row(
                    children: [
                      // سال (فیلد بزرگ‌تر)
                      Expanded(
                        flex: 3,
                        child: _buildDropdown<int>(
                          value: selectedYear,
                          items: List.generate(10, (i) => now.year + i),
                          label: (y) => '$y',
                          onChanged: (v) => setState(() => selectedYear = v!),
                          isDark: isDark,
                          hint: 'سال',
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ماه
                      Expanded(
                        flex: 4,
                        child: _buildDropdown<int>(
                          value: selectedMonth,
                          items: List.generate(12, (i) => i + 1),
                          label: (m) => PersianDate.monthName(m),
                          onChanged: (v) => setState(() => selectedMonth = v!),
                          isDark: isDark,
                          hint: 'ماه',
                        ),
                      ),
                      const SizedBox(width: 8),
                      // روز
                      Expanded(
                        flex: 2,
                        child: _buildDropdown<int>(
                          value: selectedDay,
                          items: List.generate(31, (i) => i + 1),
                          label: (d) => '$d',
                          onChanged: (v) => setState(() => selectedDay = v!),
                          isDark: isDark,
                          hint: 'روز',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'لغو',
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx, PersianDate(selectedYear, selectedMonth, selectedDay));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldPrimary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('تایید تاریخ', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );

  if (result == null) return null;
  return _shamsiToMiladi(result.year, result.month, result.day);
}

Widget _buildDropdown<T>({
  required T value,
  required List<T> items,
  required String Function(T) label,
  required ValueChanged<T?> onChanged,
  required bool isDark,
  required String hint,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isDark ? AppColors.darkBg : Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade300),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        isExpanded: true,
        value: value,
        icon: Icon(Icons.expand_more, size: 18, color: isDark ? Colors.grey[400] : Colors.grey[600]),
        dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black87,
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              label(item),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        hint: Text(hint, style: const TextStyle(fontSize: 12)),
      ),
    ),
  );
}

DateTime _shamsiToMiladi(int jy, int jm, int jd) {
  const gDaysInMonth = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  int jy2 = jy;
  int days = (jy2 - 1) * 365 + (jy2 ~/ 4) - (jy2 ~/ 100) + (jy2 ~/ 400) + 226894;
  if (jm < 7) {
    days += (jm - 1) * 31 + jd - 1;
  } else {
    days += 186 + (jm - 7) * 30 + jd - 1;
  }
  int gy = 400 * (days ~/ 146097);
  days %= 146097;
  if (days > 36524) {
    gy += 100 * ((days - 1) ~/ 36524);
    days = (days - 1) % 36524;
  }
  gy += 4 * (days ~/ 1461);
  days %= 1461;
  if (days > 365) {
    gy += (days - 1) ~/ 365;
    days = (days - 1) % 365;
  }
  gy += 1;
  int gm = 1;
  int gd = 1;
  for (int i = 0; i < 12; i++) {
    int daysInMonth = (i == 1 && _isLeap(gy)) ? 29 : gDaysInMonth[i + 1] - gDaysInMonth[i];
    if (days < daysInMonth) {
      gm = i + 1;
      gd = days + 1;
      break;
    }
    days -= daysInMonth;
  }
  return DateTime(gy, gm, gd);
}

bool _isLeap(int y) => (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
