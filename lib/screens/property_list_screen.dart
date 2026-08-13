import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_data.dart';
import '../widgets/property_card.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final all = context.watch<AppData>().listings;

    final filtered = _filter == 'all'
        ? all
        : all.where((p) => p.dealType == _filter).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(title: const Text('خرید ملک')),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _buildFilterChips(isDark),
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
                    ? Colors.black
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
