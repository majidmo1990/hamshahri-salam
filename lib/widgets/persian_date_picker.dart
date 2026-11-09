import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// تقویم شمسی ساده (بدون پکیج خارجی)
/// تبدیل میلادی به شمسی (الگوریتم)
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

/// دیالوگ تقویم شمسی ساده (روز/ماه/سال)
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
          return AlertDialog(
            title: const Text('انتخاب تاریخ'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // سال
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedYear,
                        items: List.generate(10, (i) => now.year + i).map((y) {
                          return DropdownMenuItem(value: y, child: Text('$y'));
                        }).toList(),
                        onChanged: (v) => setState(() => selectedYear = v!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ماه
                    Expanded(
                      flex: 2,
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedMonth,
                        items: List.generate(12, (i) => i + 1).map((m) {
                          return DropdownMenuItem(
                            value: m,
                            child: Text(PersianDate.monthName(m)),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => selectedMonth = v!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // روز
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedDay,
                        items: List.generate(31, (i) => i + 1).map((d) {
                          return DropdownMenuItem(value: d, child: Text('$d'));
                        }).toList(),
                        onChanged: (v) => setState(() => selectedDay = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  PersianDate(selectedYear, selectedMonth, selectedDay).longFormatted,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('لغو'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx, PersianDate(selectedYear, selectedMonth, selectedDay));
                },
                child: const Text('تایید'),
              ),
            ],
          );
        },
      );
    },
  );

  if (result == null) return null;

  // تبدیل شمسی به میلادی (تقریبی)
  return _shamsiToMiladi(result.year, result.month, result.day);
}

/// تبدیل شمسی به میلادی (الگوریتم)
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
