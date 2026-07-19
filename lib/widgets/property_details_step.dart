import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum PropertyGroup { shop, residential, land }

PropertyGroup groupForCategory(String categoryId) {
  if (categoryId.contains('shop')) return PropertyGroup.shop;
  if (categoryId.contains('farmland') || categoryId == 'sell_land') {
    return PropertyGroup.land;
  }
  return PropertyGroup.residential;
}

class PropertyDetailsStep extends StatefulWidget {
  final String categoryId;
  final Map<String, dynamic> formData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PropertyDetailsStep({
    super.key,
    required this.categoryId,
    required this.formData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<PropertyDetailsStep> createState() => _PropertyDetailsStepState();
}

class _PropertyDetailsStepState extends State<PropertyDetailsStep> {
  @override
  Widget build(BuildContext context) {
    final group = groupForCategory(widget.categoryId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (group == PropertyGroup.shop) ..._shopFields(isDark),
          if (group == PropertyGroup.residential) ..._residentialFields(isDark),
          if (group == PropertyGroup.land) ..._landFields(isDark),
          const SizedBox(height: 12),
          _fieldLabel('توضیحات', isDark, hint: 'هرچیزی که فکر می‌کنید به فروش/اجاره بهتر کمک می‌کند'),
          _textArea(isDark),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: widget.onBack,
                    child: const Text(
                      'قبلی',
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: widget.onNext,
                    child: const Text(
                      'بعدی',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<Widget> _shopFields(bool isDark) {
    return [
      _fieldLabel(
        'عرض جلوی مغازه (متر)',
        isDark,
        hint: 'عرض قسمتی از مغازه که رو به خیابان یا پاساژ است',
      ),
      _textField('formData_frontage', 'مثال: ۴', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel('نوع کاربری مغازه', isDark),
      _pickerField(context, 'formData_shopUsage', 'انتخاب کنید', [
        'خواربارفروشی',
        'پوشاک',
        'مواد غذایی',
        'خدماتی',
        'عمومی',
      ]),
      const SizedBox(height: 16),
      _switchTile(
        'سرقفلی دارد',
        'دارنده حق تقدم در اجاره‌ی مجدد یا فروش امتیاز مغازه',
        'formData_hasKeyMoney',
        isDark,
      ),
      _switchTile(
        'آب، برق و گاز فعال است',
        null,
        'formData_utilities',
        isDark,
      ),
    ];
  }

  List<Widget> _residentialFields(bool isDark) {
    return [
      _fieldLabel('تعداد اتاق خواب', isDark),
      _pickerField(context, 'formData_bedrooms', 'انتخاب کنید',
          ['۱', '۲', '۳', '۴', '۵ به بالا']),
      const SizedBox(height: 16),
      _fieldLabel('طبقه واحد', isDark),
      _textField('formData_floor', 'مثال: ۳', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel('سن بنا (سال)', isDark, hint: 'اگر نوساز است بنویسید صفر'),
      _textField('formData_buildYear', 'مثال: ۵', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel(
        'نوع سند',
        isDark,
        hint: 'تک‌برگ: سند رسمی مستقل / منگوله‌دار: سند قدیمی مشاعی',
      ),
      _pickerField(context, 'formData_deed', 'انتخاب کنید',
          ['تک‌برگ', 'منگوله‌دار', 'قولنامه‌ای']),
      const SizedBox(height: 16),
      _switchTile('پارکینگ دارد', null, 'formData_parking', isDark),
      _switchTile('آسانسور دارد', null, 'formData_elevator', isDark),
      _switchTile('انباری دارد', null, 'formData_storage', isDark),
    ];
  }

  List<Widget> _landFields(bool isDark) {
    return [
      _fieldLabel(
        'نوع سند زمین',
        isDark,
        hint: 'زراعی: مخصوص کشاورزی / مسکونی و تجاری: قابل ساخت‌وساز',
      ),
      _pickerField(context, 'formData_landDeed', 'انتخاب کنید',
          ['زراعی', 'مسکونی', 'تجاری']),
      const SizedBox(height: 16),
      _fieldLabel(
        'کاربری مجاز زمین',
        isDark,
        hint: 'زمین برای چه هدفی مجوز استفاده دارد',
      ),
      _textField('formData_landUsage', 'مثال: کشاورزی، مسکونی'),
      const SizedBox(height: 16),
      _switchTile('آب و برق در دسترس است', null, 'formData_landUtilities', isDark),
    ];
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

  Widget _textField(String key, String hint, {bool isNumber = false}) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return TextField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: (value) => widget.formData[key] = value,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: _inputDecoration(hint, isDark),
      );
    });
  }

  Widget _textArea(bool isDark) {
    return TextField(
      maxLines: 3,
      onChanged: (value) => widget.formData['formData_description'] = value,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: _inputDecoration('توضیحات تکمیلی درباره ملک...', isDark),
    );
  }

  Widget _pickerField(
    BuildContext context,
    String key,
    String hint,
    List<String> options,
  ) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final selected = widget.formData[key] as String?;

      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openPickerSheet(context, key, options, isDark),
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
                  selected ?? hint,
                  style: TextStyle(
                    fontSize: 13,
                    color: selected != null
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
    });
  }

  void _openPickerSheet(
    BuildContext context,
    String key,
    List<String> options,
    bool isDark,
  ) {
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
              children: options.map((option) {
                final isSelected = widget.formData[key] == option;
                return ListTile(
                  onTap: () {
                    setState(() => widget.formData[key] = option);
                    Navigator.pop(context);
                  },
                  title: Text(
                    option,
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

  Widget _switchTile(
    String label,
    String? hint,
    String key,
    bool isDark,
  ) {
    final currentValue = widget.formData[key] as bool? ?? false;
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    if (hint != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          hint,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Switch(
                value: currentValue,
                activeThumbColor: AppColors.primaryBlue,
                onChanged: (value) {
                  setLocalState(() => widget.formData[key] = value);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration(String hint, bool isDark) {
    return InputDecoration(
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
    );
  }
}
