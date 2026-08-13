import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_data.dart';
import '../widgets/property_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final all = context.watch<AppData>().listings;

    final results = all.where((p) {
      final q = _query.trim();
      if (q.isEmpty) return true;
      return p.title.contains(q) || p.location.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.skyBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded,
                        color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) => setState(() => _query = value),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          hintText: 'جستجو بر اساس عنوان یا موقعیت...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text(
                        'نتیجه‌ای یافت نشد',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[500] : Colors.grey[500],
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return PropertyCard(property: results[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
