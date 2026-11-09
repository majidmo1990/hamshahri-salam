import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../utils/date_formatter.dart';
import '../widgets/persian_date_picker.dart';
import 'reservations_screen.dart';

class VideoBookingScreen extends StatefulWidget {
  const VideoBookingScreen({super.key});

  @override
  State<VideoBookingScreen> createState() => _VideoBookingScreenState();
}

class _VideoBookingScreenState extends State<VideoBookingScreen> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _date;
  String? _time;  // ← String به جای TimeOfDay
  bool _submitted = false;
  bool _sending = false;

  // ساعت‌های مجاز
  static const List<String> _allowedTimes = [
    '09:00', '10:00', '11:00',
    '14:00', '15:00', '16:00',
  ];

  // تبدیل تاریخ میلادی به شمسی

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showSimplePersianDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'ساعت مورد نظر را انتخاب کنید',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ساعت‌های کاری: ۹ تا ۱۱ و ۱۴ تا ۱۶',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Time slots
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _allowedTimes.map((time) {
                    final selected = _time == time;
                    return InkWell(
                      onTap: () => Navigator.pop(ctx, time),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryBlue
                              : (isDark ? AppColors.darkBg : Colors.grey[100]),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selected
                                ? AppColors.primaryBlue
                                : (isDark ? AppColors.darkBorder : Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.white : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() => _time = result);
    }
  }

  Future<void> _submit() async {
    if (_sending) return;
    if (_addressController.text.trim().isEmpty || _date == null || _time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('آدرس، تاریخ و ساعت را وارد کنید')),
      );
      return;
    }
    _sending = true;
    try {
      final d = _date!;
      await ApiService().createVideoBooking(
        address: _addressController.text.trim(),
        date: '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
        time: _time!,  // ← String
        notes: _notesController.text.trim(),
      );
      if (!mounted) return;
      setState(() => _submitted = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ثبت درخواست ناموفق بود. دوباره تلاش کنید.')),
      );
    } finally {
      _sending = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(title: const Text('رزرو زمان فیلمبرداری')),
        body: SafeArea(
          child: _submitted ? _success(isDark) : _form(isDark),
        ),
      ),
    );
  }

  Widget _success(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, size: 64, color: AppColors.goldLight),
            const SizedBox(height: 16),
            Text('درخواست شما ثبت شد',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87)),
            const SizedBox(height: 8),
            Text('کارشناسان ما برای هماهنگی نهایی با شما تماس می‌گیرند.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey[400] : Colors.grey[600])),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ReservationsScreen()),
                  );
                },
                icon: const Icon(Icons.list_alt_rounded, size: 18),
                label: const Text('مشاهده رزروها'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('بازگشت'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _form(bool isDark) {
    final dateText = _date == null
        ? 'انتخاب تاریخ'
        : toShamsi(_date!);
    final timeText = _time ?? 'انتخاب ساعت';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('برای ملک خودتان یک فیلمبردار حرفه‌ای رزرو کنید.',
            style: TextStyle(
                fontSize: 13, color: isDark ? Colors.grey[400] : Colors.grey[600])),
        const SizedBox(height: 20),
        _label('آدرس ملک', isDark),
        _field(_addressController, 'محدوده، کوچه، پلاک...', isDark),
        const SizedBox(height: 16),
        _label('تاریخ', isDark),
        _picker(dateText, Icons.calendar_today_rounded, _pickDate, isDark, _date != null),
        const SizedBox(height: 16),
        _label('ساعت', isDark),
        _picker(timeText, Icons.access_time_rounded, _pickTime, isDark, _time != null),
        const SizedBox(height: 4),
        Text('ساعت‌های کاری: ۹ تا ۱۱ و ۱۴ تا ۱۶',
            style: TextStyle(
                fontSize: 11.5,
                color: isDark ? Colors.grey[500] : Colors.grey[500])),
        const SizedBox(height: 16),
        _label('توضیحات (اختیاری)', isDark),
        _field(_notesController, 'مثلاً: ملک ساکن دارد، ورودی از کوچه‌ی فرعی', isDark, lines: 3),
        const SizedBox(height: 28),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _sending ? null : _submit,
            icon: _sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.videocam_rounded),
            label: Text(_sending ? 'در حال ثبت...' : 'ثبت درخواست',
                style: const TextStyle(fontSize: 15)),
          ),
        ),
      ],
    );
  }

  Widget _label(String t, bool isDark) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87)),
      );

  Widget _field(TextEditingController c, String hint, bool isDark, {int lines = 1}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.skyBlue),
    );
    return TextField(
      controller: c,
      maxLines: lines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[400], fontSize: 13),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        border: border,
        enabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
      ),
    );
  }

  Widget _picker(String text, IconData icon, VoidCallback onTap, bool isDark, bool selected) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.skyBlue),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primaryBlue),
            const SizedBox(width: 10),
            Text(text,
                style: TextStyle(
                    fontSize: 13,
                    color: selected
                        ? (isDark ? Colors.white : Colors.black87)
                        : (isDark ? Colors.grey[500] : Colors.grey[400]))),
          ],
        ),
      ),
    );
  }
}
