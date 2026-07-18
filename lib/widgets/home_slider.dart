import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'image':
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
      'title': 'خانه رویایی شما اینجاست',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
      'title': 'ویلاهای لوکس و مدرن',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=800',
      'title': 'بهترین قیمت‌های بازار',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 190,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
            ),
            items: _slides.map((slide) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    slide['image']!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.skyBlue,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.skyBlue,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 30, 16, 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          slide['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: _slides.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.primaryBlue,
            dotColor: isDark ? AppColors.darkBorder : AppColors.skyBlue,
          ),
        ),
      ],
    );
  }
}
