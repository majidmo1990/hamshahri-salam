import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/property_image.dart';

class PropertyPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<String> imagePaths;

  const PropertyPreviewScreen({
    super.key,
    required this.data,
    required this.imagePaths,
  });

  List<String> get _imageUrls {
    final fromData = data['image_urls'];
    if (fromData is List && fromData.isNotEmpty) {
      return fromData.cast<String>();
    }
    return imagePaths;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(
          title: const Text('پیش‌نمایش آگهی'),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              if (_imageUrls.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  child: buildPropertyImage(
                    _imageUrls.first,
                    height: 240,
                    width: double.infinity,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (data['title'] ?? 'بدون عنوان').toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 16,
                            color: isDark
                                ? Colors.grey[400]
                                : Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${data['district'] ?? ''} - ${data['location'] ?? ''}',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkGoldBorder
                              : AppColors.skyBlue,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'قیمت',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                          Text(
                            (data['price_display'] ?? '').toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if ((data['description'] ?? '').toString().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text(
                        'توضیحات',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data['description'].toString(),
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.7,
                          color: isDark
                              ? Colors.grey[300]
                              : Colors.grey[800],
                        ),
                      ),
                    ],
                    if (_imageUrls.length > 1) ...[
                      const SizedBox(height: 20),
                      Text(
                        'عکس‌ها (${_imageUrls.length})',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _imageUrls.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (_, i) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: buildPropertyImage(_imageUrls[i],
                                width: 80, height: 80, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context, 'edit'),
                    icon: const Icon(Icons.edit_rounded, size: 18),
                    label: const Text('ویرایش'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, 'submit'),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: const Text('تایید و ثبت'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldPrimary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
