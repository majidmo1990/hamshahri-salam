import '../models/property_listing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/app_data.dart';
import 'property_image.dart';
import '../screens/property_detail_screen.dart';

class PropertyCard extends StatelessWidget {
  final PropertyListing property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appData = context.watch<AppData>();
    final isFavorite = appData.isFavorite(property.id);
    final dealLabel = property.dealType == 'rent' ? 'اجاره' : 'فروش';

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PropertyDetailScreen(property: property)),
      ),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.darkGoldBorder : AppColors.skyBlue),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldLight.withValues(alpha: isDark ? 0.10 : 0.18),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 120,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SizedBox.expand(
                      child: buildPropertyImage(
                        property.imagePaths.isNotEmpty
                            ? property.imagePaths.first
                            : 'assets/images/slider1.jpg',
                        errorBuilder: (c, e, s) => Container(
                          color: isDark ? AppColors.darkBg : AppColors.skyBlue,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0, right: 0, bottom: 0, height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.55)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8, top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.goldHighlight, AppColors.goldLight],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          property.isVilla ? 'ویلایی' : dealLabel,
                          style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8, top: 8,
                      child: GestureDetector(
                        onTap: () async {
                            try {
                              await context.read<AppData>().toggleFavorite(property.id);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('لطفاً وارد شوید'),
                                    backgroundColor: Colors.red[600],
                                  ),
                                );
                              }
                            }
                          },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 16,
                            color: isFavorite ? Colors.redAccent : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10, bottom: 8,
                      child: Row(
                        children: [
                          const Icon(Icons.remove_red_eye_outlined, size: 12, color: Colors.white70),
                          const SizedBox(width: 3),
                          Text('${property.views}',
                              style: const TextStyle(fontSize: 10.5, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(property.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        )),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 13,
                            color: isDark ? Colors.grey[400] : Colors.grey[600]),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(property.district,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(property.priceDisplay,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryBlue,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
