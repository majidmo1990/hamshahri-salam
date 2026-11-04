import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property_listing.dart';
import '../state/app_data.dart';
import '../theme/app_theme.dart';
import '../screens/property_detail_screen.dart';
import 'property_image.dart';

class FeaturedCarousel extends StatefulWidget {
  final List<PropertyListing> items;
  const FeaturedCarousel({super.key, required this.items});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  final PageController _c = PageController(viewportFraction: 0.84);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _c.addListener(() => setState(() => _page = _c.page ?? 0));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = widget.items;
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _c,
            itemCount: items.length,
            itemBuilder: (context, i) {
              final delta = (_page - i).abs().clamp(0.0, 1.0);
              return Transform.scale(
                scale: 1 - delta * 0.08,
                child: Opacity(
                  opacity: 1 - delta * 0.35,
                  child: _card(context, items[i], isDark),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(items.length, (i) {
            final active = i == _page.round();
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.goldLight : (isDark ? AppColors.darkBorder : AppColors.skyBlue),
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _card(BuildContext context, PropertyListing p, bool isDark) {
    final isFav = context.watch<AppData>().isFavorite(p.id);
    final label = p.isVilla ? 'ویلایی' : (p.dealType == 'rent' ? 'اجاره' : 'فروش');
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PropertyDetailScreen(property: p)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldLight.withValues(alpha: isDark ? 0.18 : 0.28),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              buildPropertyImage(
                p.imagePaths.isNotEmpty ? p.imagePaths.first : 'assets/images/slider1.jpg',
                errorBuilder: (c, e, s) => Container(color: isDark ? AppColors.darkSurface : AppColors.skyBlue),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.4, 1],
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.goldHighlight, AppColors.goldLight]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(label,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black)),
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: GestureDetector(
                  onTap: () => context.read<AppData>().toggleFavorite(p.id),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                    child: Icon(isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 18, color: isFav ? Colors.redAccent : Colors.white),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                left: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: Colors.white70),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(p.district,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        ),
                        const Icon(Icons.remove_red_eye_outlined, size: 13, color: Colors.white70),
                        const SizedBox(width: 3),
                        Text('${p.views}', style: const TextStyle(fontSize: 11.5, color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.goldLight.withValues(alpha: 0.5)),
                      ),
                      child: Text(p.priceDisplay,
                          style: const TextStyle(
                              fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.goldHighlight)),
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
}
