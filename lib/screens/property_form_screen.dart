import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_data.dart';
import '../state/districts.dart';
import '../widgets/property_details_step.dart';
import '../widgets/media_upload_step.dart';
import 'property_type_screen.dart';
import 'category_selection_screen.dart';
import 'main_navigation_screen.dart';
import 'dart:io';
import '../services/api_service.dart';

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
  final _landAreaController = TextEditingController();
  final _buildAreaController = TextEditingController();
  final _priceController = TextEditingController();
  final _depositController = TextEditingController();
  final _rentController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedDistrict;
  String? _phoneError;

  bool get _isVilla => widget.category.id == 'villa';
  bool get _isApartment => widget.category.id == 'apartment';

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _landAreaController.dispose();
    _buildAreaController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _rentController.dispose();
    _phoneController.dispose();
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

  int _parseNumber(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? 0 : int.parse(digits);
  }

  String _buildPriceDisplay() {
    if (widget.dealType == DealType.rent) {
      final deposit = _depositController.text.trim();
      final rent = _rentController.text.trim();
      return 'رهن ${deposit.isEmpty ? '۰' : deposit} / اجاره ${rent.isEmpty ? '۰' : rent}';
    }
    final price = _priceController.text.trim();
    return price.isEmpty ? 'توافقی' : '$price تومان';
  }

  int _buildPriceValue() {
    if (widget.dealType == DealType.rent) {
      return _parseNumber(_rentController.text);
    }
    return _parseNumber(_priceController.text);
  }

  bool _validatePhoneAndProceed() {
    final phone = _phoneController.text.trim();
    final isValid = RegExp(r'^09[0-9]{9}$').hasMatch(phone);
    setState(() {
      _phoneError = isValid ? null : 'شماره موبایل معتبر وارد کنید (مثال: ۰۹۱۲۱۲۳۴۵۶۷)';
    });
    return isValid;
  }

  Future<void> _submitProperty(List<String> images, String? video) async {
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          title: const Text('خطا'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('باشه'),
            ),
          ],
        );
      },
    );
  }
    if (!mounted) return;

    // ۱. آپلود عکس‌ها به سرور
    final api = ApiService();
    final uploadedImagePaths = <String>[];

    try {
      for (final path in images) {
        final file = File(path);
        if (await file.exists()) {
          final relPath = await api.uploadImage(file);
          uploadedImagePaths.add(relPath);
        }
      }

      // ۲. آپلود ویدیو
      String? uploadedVideoPath;
      if (video != null) {
        final videoFile = File(video);
        if (await videoFile.exists()) {
          uploadedVideoPath = await api.uploadVideo(videoFile);
        }
      }

      // ۳. ساخت داده برای ارسال
      final data = <String, dynamic>{
        'deal_type': widget.dealType == DealType.rent ? 'rent' : 'sell',
        'category_id': widget.category.id,
        'category_label': widget.category.label,
        'title': _titleController.text.trim().isEmpty
            ? widget.category.label
            : _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'district': _selectedDistrict ?? kDistricts.first,
        'land_area': _landAreaController.text.trim().isEmpty
            ? null
            : _landAreaController.text.trim(),
        'build_area': _buildAreaController.text.trim().isEmpty
            ? null
            : _buildAreaController.text.trim(),
        'price_display': _buildPriceDisplay(),
        'price_value': _buildPriceValue(),
        'details': Map<String, dynamic>.from(formData),
        'description': formData['formData_description'] as String? ?? '',
        'image_paths': uploadedImagePaths,
        'video_path': uploadedVideoPath,
        'seller_phone': _phoneController.text.trim(),
      };

      // ۴. ارسال به سرور
      final appData = Provider.of<AppData>(context, listen: false);
      final listing = await appData.addListing(data);

      if (!mounted) return;

      if (listing == null) {
        _showErrorDialog(appData.error ?? 'خطا در ثبت ملک');
        return;
      }

    } catch (e) {
      if (!mounted) return;
      _showErrorDialog('خطا در آپلود: $e');
      return;
    }

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
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const MainNavigationScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('بازگشت به صفحه اصلی'),
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
                    _buildStep1(isDark),
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
                      ? const Icon(Icons.check, size: 16, color: Colors.black)
                      : Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: active
                                ? Colors.black
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

  Widget _buildStep1(bool isDark) {
    final isRent = widget.dealType == DealType.rent;

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
          _fieldLabel('محدوده', isDark),
          _districtPicker(isDark),
          const SizedBox(height: 16),
          _fieldLabel('موقعیت (آدرس دقیق)', isDark),
          _textField(_locationController, 'کوچه، پلاک...'),
          const SizedBox(height: 16),
          if (_isVilla) ...[
            _fieldLabel('متراژ زمین (متر مربع)', isDark),
            _textField(_landAreaController, 'وارد کنید', isNumber: true),
            const SizedBox(height: 16),
            _fieldLabel('متراژ بنا (متر مربع)', isDark),
            _textField(_buildAreaController, 'وارد کنید', isNumber: true),
          ] else if (_isApartment) ...[
            _fieldLabel('متراژ بنا (متر مربع)', isDark),
            _textField(_buildAreaController, 'وارد کنید', isNumber: true),
          ] else ...[
            _fieldLabel('متراژ زمین (متر مربع)', isDark),
            _textField(_landAreaController, 'وارد کنید', isNumber: true),
          ],
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
          const SizedBox(height: 16),
          _fieldLabel('شماره تماس شما', isDark,
              hint: 'برای هماهنگی بازدید و تماس خریداران'),
          _textField(_phoneController, 'مثال: ۰۹۱۲۱۲۳۴۵۶۷', isNumber: true),
          if (_phoneError != null) ...[
            const SizedBox(height: 6),
            Text(
              _phoneError!,
              style: const TextStyle(fontSize: 11.5, color: Colors.redAccent),
            ),
          ],
          const SizedBox(height: 28),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_validatePhoneAndProceed()) {
                  _goToStep(1);
                }
              },
              child: const Text('بعدی'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _districtPicker(bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openDistrictSheet(isDark),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedDistrict ?? 'انتخاب محدوده',
                style: TextStyle(
                  fontSize: 13,
                  color: _selectedDistrict != null
                      ? (isDark ? Colors.white : Colors.black87)
                      : (isDark ? Colors.grey[500] : Colors.grey[400]),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark ? Colors.grey[400] : Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }

  void _openDistrictSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: kDistricts.map((district) {
                final isSelected = _selectedDistrict == district;
                return ListTile(
                  onTap: () {
                    setState(() => _selectedDistrict = district);
                    Navigator.pop(context);
                  },
                  title: Text(
                    district,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primaryBlue
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primaryBlue, size: 20)
                      : null,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _fieldLabel(String text, bool isDark, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 2),
            Text(
              hint,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ],
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
