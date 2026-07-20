import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/property_details_step.dart';
import '../widgets/media_upload_step.dart';
import 'property_type_screen.dart';
import 'category_selection_screen.dart';
import 'home_screen.dart';

class PropertyFormScreen extends StatefulWidget {
  final DealType dealType;
  final PropertyCategory category;

  const PropertyFormScreen({
    super.key,
    required this.dealType,
    required this.category,
  });

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final Map<String, dynamic> formData = {};

  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _areaController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  final _rentController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _rentController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submitProperty() async {
    // شبیه‌سازی زمان ارسال به سرور (بعداً با ارسال واقعی جایگزین می‌شود)
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Dialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    color: AppColors.primaryBlue,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'ملک شما با موفقیت ثبت شد',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'آگهی شما در حال بررسی توسط مدیریت است و پس از تایید، در لیست ملک‌های قابل مشاهده قرار می‌گیرد.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'بازگشت به صفحه اصلی',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRent = widget.dealType == DealType.rent;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(
          title: Text('ثبت ملک - ${widget.category.label}'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildStepIndicator(isDark),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(isDark, isRent),
                    PropertyDetailsStep(
                      categoryId: widget.category.id,
                      formData: formData,
                      onNext: () => _goToStep(2),
                      onBack: () => _goToStep(0),
                    ),
                    MediaUploadStep(
                      onBack: () => _goToStep(1),
                      onSubmit: _submitProperty,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isDark) {
    final steps = ['اطلاعات اصلی', 'جزئیات', 'تصاویر'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(steps.length, (index) {
          final active = index == _currentStep;
          final done = index < _currentStep;

          return Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active || done
                      ? AppColors.primaryBlue
                      : (isDark ? AppColors.darkSurface : AppColors.skyBlue),
                  border: Border.all(
                    color: AppColors.primaryBlue,
                    width: active ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: active
                                ? Colors.white
                                : AppColors.primaryBlue,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[index],
                style: TextStyle(
                  fontSize: 10.5,
                  color: active
                      ? AppColors.primaryBlue
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStep1(bool isDark, bool isRent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _fieldLabel('عنوان ملک', isDark),
          _textField(
            _titleController,
            'مثال: واحد ۱۳۰ متری در سعادت‌آباد',
          ),
          const SizedBox(height: 16),
          _fieldLabel('موقعیت', isDark),
          _textField(_locationController, 'شهر، محله، خیابان...'),
          const SizedBox(height: 16),
          _fieldLabel('متراژ (متر مربع)', isDark),
          _textField(_areaController, 'وارد کنید', isNumber: true),
          const SizedBox(height: 16),
          if (isRent) ...[
            _fieldLabel('ودیعه / رهن (تومان)', isDark),
            _textField(_depositController, 'وارد کنید', isNumber: true),
            const SizedBox(height: 16),
            _fieldLabel('اجاره ماهانه (تومان)', isDark),
            _textField(_rentController, 'وارد کنید', isNumber: true),
          ] else ...[
            _fieldLabel('قیمت (تومان)', isDark),
            _textField(_priceController, 'وارد کنید', isNumber: true),
          ],
          const SizedBox(height: 28),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => _goToStep(1),
              child: const Text(
                'بعدی',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[400],
            fontSize: 13,
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkSurface : Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryBlue),
          ),
        ),
      );
    });
  }
}
