import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_data.dart';
import '../state/districts.dart';
import '../widgets/property_card.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String _dealFilter = 'all';
  String? _districtFilter;
  RangeValues _priceRange = const RangeValues(0, 5000000000);
  bool _priceFilterActive = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final all = context.watch<AppData>().listings;

    var filtered = _dealFilter == 'all'
        ? all
        : all.where((p) => p.dealType == _dealFilter).toList();

    if (_districtFilter != null) {
      filtered = filtered.where((p) => p.district == _districtFilter).toList();
    }

    if (_priceFilterActive) {
      filtered = filtered
          .where((p) =>
              p.priceValue >= _priceRange.start &&
              p.priceValue <= _priceRange.end)
          .toList();
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(title: const Text('خرید ملک')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildFilterRow(isDark),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'ملکی یافت نشد',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return PropertyCard(property: filtered[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow(bool isDark) {
    final dealFilters = {'all': 'همه', 'rent': 'اجاره', 'sell': 'فروش'};

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...dealFilters.entries.map((entry) {
              final isSelected = _dealFilter == entry.key;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _dealFilter = entry.key),
                  selectedColor: AppColors.primaryBlue,
                  backgroundColor:
                      isDark ? AppColors.darkSurface : AppColors.skyBlue,
                  labelStyle: TextStyle(
                    fontSize: 12.5,
                    color: isSelected
                        ? Colors.black
                        : (isDark ? Colors.white70 : Colors.black87),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ActionChip(
                avatar: Icon(
                  Icons.place_outlined,
                  size: 16,
                  color: _districtFilter != null
                      ? Colors.black
                      : (isDark ? Colors.grey[300] : Colors.grey[700]),
                ),
                label: Text(_districtFilter ?? 'محدوده'),
                onPressed: () => _openDistrictFilterSheet(isDark),
                backgroundColor: _districtFilter != null
                    ? AppColors.primaryBlue
                    : (isDark ? AppColors.darkSurface : AppColors.skyBlue),
                labelStyle: TextStyle(
                  fontSize: 12.5,
                  color: _districtFilter != null
                      ? Colors.black
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
              ),
            ),
            ActionChip(
              avatar: Icon(
                Icons.sell_outlined,
                size: 16,
                color: _priceFilterActive
                    ? Colors.black
                    : (isDark ? Colors.grey[300] : Colors.grey[700]),
              ),
              label: const Text('قیمت'),
              onPressed: () => _openPriceFilterSheet(isDark),
              backgroundColor: _priceFilterActive
                  ? AppColors.primaryBlue
                  : (isDark ? AppColors.darkSurface : AppColors.skyBlue),
              labelStyle: TextStyle(
                fontSize: 12.5,
                color: _priceFilterActive
                    ? Colors.black
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDistrictFilterSheet(bool isDark) {
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
              children: [
                ListTile(
                  onTap: () {
                    setState(() => _districtFilter = null);
                    Navigator.pop(context);
                  },
                  title: Text(
                    'همه محدوده‌ها',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _districtFilter == null
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: _districtFilter == null
                          ? AppColors.primaryBlue
                          : (isDark ? Colors.white : Colors.black87),
                    ),
                  ),
                  trailing: _districtFilter == null
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primaryBlue, size: 20)
                      : null,
                ),
                ...kDistricts.map((district) {
                  final isSelected = _districtFilter == district;
                  return ListTile(
                    onTap: () {
                      setState(() => _districtFilter = district);
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openPriceFilterSheet(bool isDark) {
    RangeValues tempRange = _priceRange;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'بازه قیمت (تومان)',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'برای اجاره بر اساس اجاره ماهانه، برای فروش بر اساس قیمت کل',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatPrice(tempRange.start),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        Text(
                          _formatPrice(tempRange.end),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: tempRange,
                      min: 0,
                      max: 5000000000,
                      divisions: 50,
                      activeColor: AppColors.primaryBlue,
                      inactiveColor:
                          isDark ? AppColors.darkBorder : AppColors.skyBlue,
                      onChanged: (values) {
                        setSheetState(() => tempRange = values);
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: AppColors.primaryBlue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _priceFilterActive = false;
                                  _priceRange =
                                      const RangeValues(0, 5000000000);
                                });
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'حذف فیلتر',
                                style: TextStyle(color: AppColors.primaryBlue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _priceRange = tempRange;
                                  _priceFilterActive = true;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('اعمال فیلتر'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatPrice(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)} میلیارد';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(0)} میلیون';
    }
    return value.toStringAsFixed(0);
  }
}
