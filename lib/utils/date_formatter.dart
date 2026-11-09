import 'package:shamsi_date/shamsi_date.dart';

/// تبدیل DateTime میلادی به رشته شمسی (مثلاً ۱۴۰۴/۰۸/۱۹)
String toShamsi(DateTime? date, {String separator = '/'}) {
  if (date == null) return '';
  final j = Jalali.fromDateTime(date);
  return '${j.year}$separator${j.month.toString().padLeft(2, '0')}$separator${j.day.toString().padLeft(2, '0')}';
}

/// تبدیل DateTime میلادی به رشته شمسی با نام ماه (مثلاً ۱۹ آبان ۱۴۰۴)
String toShamsiLong(DateTime? date) {
  if (date == null) return '';
  final j = Jalali.fromDateTime(date);
  return '${j.day} ${j.month} ${j.year}';
}

/// تبدیل DateTime میلادی به رشته شمسی + ساعت (مثلاً ۱۹ آبان ۱۴۰۴ - ۱۴:۳۰)
String toShamsiWithTime(DateTime? date) {
  if (date == null) return '';
  final j = Jalali.fromDateTime(date);
  final h = date.hour.toString().padLeft(2, '0');
  final m = date.minute.toString().padLeft(2, '0');
  return '${j.day} ${j.month} ${j.year} - $h:$m';
}

/// تبدیل رشته تاریخ (ISO) به شمسی
String isoToShamsi(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  try {
    return toShamsi(DateTime.parse(iso));
  } catch (_) {
    return '';
  }
}
