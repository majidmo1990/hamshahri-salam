import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._fieldsForCategory(isDark),
          const SizedBox(height: 12),
          _fieldLabel('توضیحات', isDark,
              hint: 'هرچیزی که فکر می‌کنید به فروش/اجاره بهتر کمک می‌کند'),
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
                    onPressed: widget.onNext,
                    child: const Text('بعدی'),
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

  List<Widget> _fieldsForCategory(bool isDark) {
    switch (widget.categoryId) {
      case 'villa':
        return _villaFields(isDark);
      case 'apartment':
        return _apartmentFields(isDark);
      case 'residential_land':
        return _residentialLandFields(isDark);
      case 'farmland':
      case 'commercial':
        return _landLikeFields(isDark);
      default:
        return _apartmentFields(isDark);
    }
  }

  List<Widget> _villaFields(bool isDark) {
    return [
      _fieldLabel('تعداد اتاق‌ها', isDark),
      _pickerField('formData_bedrooms', 'انتخاب کنید',
          ['۱', '۲', '۳', '۴', '۵ به بالا']),
      const SizedBox(height: 16),
      _infoNote('طبقه', 'این نوع ملک طبقه ندارد (واحد مستقل)', isDark),
      const SizedBox(height: 16),
      _fieldLabel('سن بنا (سال)', isDark, hint: 'اگر نوساز است بنویسید صفر'),
      _textField('formData_buildYear', 'مثال: ۵', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel('نوع سند', isDark),
      _pickerField('formData_deed', 'انتخاب کنید',
          ['تک‌برگ', 'منگوله‌دار', 'قولنامه‌ای']),
      const SizedBox(height: 16),
      _fieldLabel('امکانات', isDark),
      const SizedBox(height: 6),
      _checkTile('پارکینگ', 'formData_parking', isDark),
      _checkTile('انباری', 'formData_storage', isDark),
      _checkTile('آسانسور', 'formData_elevator', isDark),
      _checkTile('بیمه', 'formData_insurance', isDark),
    ];
  }

  List<Widget> _apartmentFields(bool isDark) {
    return [
      _fieldLabel('تعداد اتاق‌ها', isDark),
      _pickerField('formData_bedrooms', 'انتخاب کنید',
          ['۱', '۲', '۳', '۴', '۵ به بالا']),
      const SizedBox(height: 16),
      _fieldLabel('طبقه', isDark),
      _textField('formData_floor', 'مثال: ۳', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel('تعداد واحد در طبقه', isDark),
      _textField('formData_unitsPerFloor', 'مثال: ۲', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel('سن بنا (سال)', isDark, hint: 'اگر نوساز است بنویسید صفر'),
      _textField('formData_buildYear', 'مثال: ۵', isNumber: true),
      const SizedBox(height: 16),
      _fieldLabel('نوع سند', isDark),
      _pickerField('formData_deed', 'انتخاب کنید',
          ['قولنامه‌ای', 'سند تک‌برگ', 'سند رسمی']),
    ];
  }

  List<Widget> _residentialLandFields(bool isDark) {
    return [
      _fieldLabel('نوع سند', isDark),
      _pickerField('formData_landDeed', 'انتخاب کنید',
          ['قولنامه‌ای', 'سند تک‌برگ', 'سند رسمی']),
    ];
  }

  List<Widget> _landLikeFields(bool isDark) {
    return [
      _fieldLabel('نوع سند', isDark),
      _pickerField('formData_landDeed', 'انتخاب کنید',
          ['قولنامه‌ای', 'سند تک‌برگ', 'سند رسمی']),
      const SizedBox(height: 16),
      _checkTile('آب، برق و گاز در دسترس است', 'formData_utilities', isDark),
    ];
  }

  Widget _infoNote(String label, String note, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
            ),
          ),
          child: Text(
            note,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      ],
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

  Widget _pickerField(String key, String hint, List<String> options) {
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

  Widget _checkTile(String label, String key, bool isDark) {
    final currentValue = widget.formData[key] as bool? ?? false;
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setLocalState(() => widget.formData[key] = !currentValue);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  currentValue
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  color: currentValue
                      ? AppColors.primaryBlue
                      : (isDark ? Colors.grey[500] : Colors.grey[400]),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
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
