import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/property_card.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String _filter = 'all'; // all, rent, sell

  final List<PropertyPreview> _allProperties = const [
    PropertyPreview(
      title: 'آپارتمان ۱۲۰ متری',
      location: 'سعادت‌آباد',
      price: '۳ میلیارد تومان',
      area: '۱۲۰ متر',
      imageUrl: 'assets/images/slider1.jpg',
      views: 340,
    ),
    PropertyPreview(
      title: 'مغازه تجاری',
      location: 'خیابان ولیعصر',
      price: 'رهن ۲۰۰ / اجاره ۱۵',
      area: '۴۵ متر',
      imageUrl: 'assets/images/slider2.jpg',
      views: 210,
    ),
    PropertyPreview(
      title: 'زمین مزروعی',
      location: 'کرج، اطراف',
      price: '۸۰۰ میلیون تومان',
      area: '۱۰۰۰ متر',
      imageUrl: 'assets/images/slider3.jpg',
      views: 150,
    ),
    PropertyPreview(
      title: 'واحد ویلایی نوساز',
      location: 'لواسان',
      price: 'رهن ۵۰۰ / اجاره ۴۰',
      area: '۲۰۰ متر',
      imageUrl: 'assets/images/slider1.jpg',
      views: 95,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(title: const Text('مشاهده ملک‌ها')),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildFilterChips(isDark),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: _allProperties.length,
                  itemBuilder: (context, index) {
                    return PropertyCard(property: _allProperties[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = {'all': 'همه', 'rent': 'اجاره', 'sell': 'فروش'};

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = _filter == entry.key;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (_) => setState(() => _filter = entry.key),
              selectedColor: AppColors.primaryBlue,
              backgroundColor:
                  isDark ? AppColors.darkSurface : AppColors.skyBlue,
              labelStyle: TextStyle(
                fontSize: 12.5,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
