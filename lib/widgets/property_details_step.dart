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
          _fieldLabel('توضیحات (اختیاری)', isDark),
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
      _fieldLabel('عرض واجهه (متر)', isDark),
      _textField('formData_frontage', 'وارد کنید', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel('کاربری مغازه', isDark),
      _dropdown('formData_shopUsage', [
        'خواربارفروشی',
        'پوشاک',
        'مواد غذایی',
        'خدماتی',
        'عمومی',
      ]),
      const SizedBox(height: 16),
      _switchTile('دارا بودن سرقفلی', 'formData_hasKeyMoney', isDark),
      _switchTile('دسترسی به آب و برق و گاز', 'formData_utilities', isDark),
    ];
  }

  List<Widget> _residentialFields(bool isDark) {
    return [
      _fieldLabel('تعداد اتاق خواب', isDark),
      _dropdown('formData_bedrooms', ['۱', '۲', '۳', '۴', '۵ به بالا']),
      const SizedBox(height: 16),
      _fieldLabel('طبقه', isDark),
      _textField('formData_floor', 'مثال: ۳', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel('سن بنا', isDark),
      _textField('formData_buildYear', 'مثال: نوساز یا ۵ سال', isNumber: false),
      const SizedBox(height: 16),
      _fieldLabel('نوع سند', isDark),
      _dropdown('formData_deed', ['تک‌برگ', 'منگوله‌دار', 'قولنامه‌ای']),
      const SizedBox(height: 16),
      _switchTile('پارکینگ', 'formData_parking', isDark),
      _switchTile('آسانسور', 'formData_elevator', isDark),
      _switchTile('انباری', 'formData_storage', isDark),
    ];
  }

  List<Widget> _landFields(bool isDark) {
    return [
      _fieldLabel('نوع سند', isDark),
      _dropdown('formData_landDeed', ['زراعی', 'مسکونی', 'تجاری']),
      const SizedBox(height: 16),
      _fieldLabel('کاربری مجاز زمین', isDark),
      _textField('formData_landUsage', 'مثال: کشاورزی، مسکونی'),
      const SizedBox(height: 16),
      _switchTile('دسترسی به آب و برق', 'formData_landUtilities', isDark),
    ];
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

  Widget _dropdown(String key, List<String> options) {
    return Builder(builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return DropdownButtonFormField<String>(
        initialValue: widget.formData[key] as String?,
        decoration: _inputDecoration('انتخاب کنید', isDark),
        dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 13,
        ),
        items: options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (value) => widget.formData[key] = value,
      );
    });
  }

  Widget _switchTile(String label, String key, bool isDark) {
    final currentValue = widget.formData[key] as bool? ?? false;
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
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
