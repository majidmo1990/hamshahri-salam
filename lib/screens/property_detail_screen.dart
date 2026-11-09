import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_theme.dart';
import '../state/app_data.dart';
import '../widgets/property_image.dart';
import '../services/api_service.dart';

class PropertyDetailScreen extends StatefulWidget {
  final PropertyListing property;

  const PropertyDetailScreen({super.key, required this.property});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppData>(context, listen: false)
          .incrementViews(widget.property.id);
    });
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appData = context.watch<AppData>();
    final property = appData.listings.firstWhere(
      (p) => p.id == widget.property.id,
      orElse: () => widget.property,
    );
    final isFavorite = appData.isFavorite(property.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderImage(context, isDark, isFavorite, property),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (property.isVilla)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.goldLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ویلایی',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      Text(
                        property.title,
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
                              color: isDark ? Colors.grey[400] : Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${property.district} - ${property.location}',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          if (property.landArea != null)
                            _infoChip(
                              icon: Icons.crop_square_rounded,
                              label: 'زمین ${property.landArea} متر',
                              isDark: isDark,
                            ),
                          if (property.buildArea != null)
                            _infoChip(
                              icon: Icons.home_outlined,
                              label: 'بنا ${property.buildArea} متر',
                              isDark: isDark,
                            ),
                          _infoChip(
                            icon: Icons.remove_red_eye_outlined,
                            label: '${property.views} بازدید',
                            isDark: isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                                color: isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                            Text(
                              property.priceDisplay,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (property.details.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          'مشخصات ملک',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildDetailsGrid(isDark, property),
                      ],
                      if (property.description.isNotEmpty) ...[
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
                          property.description,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.7,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => _showReserveSheet(context, isDark, property),
                          icon: const Icon(Icons.calendar_month_rounded),
                          label: const Text(
                            'رزرو و درخواست تماس',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage(
    BuildContext context,
    bool isDark,
    bool isFavorite,
    PropertyListing property,
  ) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => _openGallery(context, property),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: buildPropertyImage(
              property.imagePaths.isNotEmpty
                  ? property.imagePaths.first
                  : 'assets/images/slider1.jpg',
              height: 240,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 240,
                color: isDark ? AppColors.darkSurface : AppColors.skyBlue,
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: _circleButton(
            icon: Icons.arrow_forward_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Row(
            children: [
              _circleButton(
                icon: Icons.share_rounded,
                onTap: () => _shareProperty(context, property),
              ),
              const SizedBox(width: 8),
              _circleButton(
                icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                iconColor: isFavorite ? Colors.redAccent : Colors.white,
                onTap: () => context.read<AppData>().toggleFavorite(property.id),
              ),
            ],
          ),
        ),
        if (property.imagePaths.length > 1 || property.videoPath != null)
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => _openGallery(context, property),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.photo_library_outlined, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text('مشاهده گالری', style: TextStyle(fontSize: 11, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsGrid(bool isDark, PropertyListing property) {
    final labels = _detailLabels();
    final entries = property.details.entries
        .where((e) => labels.containsKey(e.key) && e.value != null && e.value != '')
        .toList();

    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      children: entries.map((entry) {
        final label = labels[entry.key]!;
        String value;
        if (entry.value is bool) {
          value = entry.value == true ? 'دارد' : 'ندارد';
        } else {
          value = entry.value.toString();
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColors.darkGoldBorder : AppColors.skyBlue,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, String> _detailLabels() {
    return const {
      'formData_bedrooms': 'تعداد اتاق‌ها',
      'formData_floor': 'طبقه',
      'formData_unitsPerFloor': 'تعداد واحد در طبقه',
      'formData_buildYear': 'سن بنا (سال)',
      'formData_deed': 'نوع سند',
      'formData_landDeed': 'نوع سند',
      'formData_parking': 'پارکینگ',
      'formData_storage': 'انباری',
      'formData_elevator': 'آسانسور',
      'formData_insurance': 'بیمه',
      'formData_utilities': 'آب، برق و گاز',
    };
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  Widget _infoChip({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.skyBlue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkGoldBorder : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AppColors.primaryBlue),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareProperty(BuildContext context, PropertyListing property) async {
    final url = 'https://hamshahri.rumiland.org/property/${property.id}';
    final text = '${property.title}\n'
        '${property.district} - ${property.location}\n'
        'قیمت: ${property.priceDisplay}\n\n'
        'مشاهده در همشهری سلام:\n$url';
    
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      text,
      subject: property.title,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null,
    );
  }

  void _openGallery(BuildContext context, PropertyListing property) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _GalleryScreen(property: property),
        fullscreenDialog: true,
      ),
    );
  }

  void _showReserveSheet(BuildContext context, bool isDark, PropertyListing property) {
    final phoneController = TextEditingController();
    final nameController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool sending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'رزرو و درخواست تماس',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'اطلاعات خود را وارد کنید تا کارشناسان ما با شما تماس بگیرند.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          enabled: !sending,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87),
                          decoration: _inputDecoration(
                            'شماره تماس *',
                            'مثال: ۰۹۱۲۳۴۵۶۷۸۹',
                            isDark,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'شماره تماس الزامی است';
                            }
                            final normalized = v.trim().replaceAllMapped(RegExp(r'[۰-۹]'), (m) => '${'۰۱۲۳۴۵۶۷۸۹'.indexOf(m.group(0)!)}');
                            if (!RegExp(r'^09[0-9]{9}$').hasMatch(normalized)) {
                              return 'شماره موبایل معتبر وارد کنید';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: nameController,
                          enabled: !sending,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87),
                          decoration: _inputDecoration(
                            'نام (اختیاری)',
                            'نام و نام خانوادگی',
                            isDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: notesController,
                          enabled: !sending,
                          maxLines: 3,
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87),
                          decoration: _inputDecoration(
                            'توضیحات (اختیاری)',
                            'مثلاً: بعدازظهرها در دسترس هستم',
                            isDark,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: sending
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) {
                                      return;
                                    }
                                    setSheetState(() => sending = true);
                                    final rawPhone = phoneController.text.trim();
                                    final phone = rawPhone.replaceAllMapped(RegExp(r'[۰-۹]'), (m) => '${'۰۱۲۳۴۵۶۷۸۹'.indexOf(m.group(0)!)}');
                                    try {
                                      await ApiService().init();
                                      await ApiService().createPropertyVisit(
                                        propertyId: property.id,
                                        phone: phone,
                                        name: nameController.text.trim(),
                                        notes: notesController.text.trim(),
                                      );
                                      if (!mounted) return;
                                      if (!sheetContext.mounted) return;
                                      Navigator.pop(sheetContext);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'درخواست شما ثبت شد ✅ کارشناسان ما تا ۲۴ ساعت آینده با شما تماس می‌گیرند',
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 4),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!sheetContext.mounted) return;
                                      setSheetState(() => sending = false);
                                      ScaffoldMessenger.of(sheetContext)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('خطا: $e'),
                                          backgroundColor: Colors.red[600],
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.goldPrimary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: sending
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'ثبت درخواست',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _inputDecoration(String label, String hint, bool isDark) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(
        color: isDark ? Colors.grey[400] : Colors.grey[700],
        fontSize: 12.5,
      ),
      hintStyle: TextStyle(
        color: isDark ? Colors.grey[500] : Colors.grey[400],
        fontSize: 12.5,
      ),
      filled: true,
      fillColor:
          isDark ? AppColors.darkBg : AppColors.skyBlue.withValues(alpha: 0.4),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
    );
  }
}

class _GalleryScreen extends StatefulWidget {
  final PropertyListing property;

  const _GalleryScreen({required this.property});

  @override
  State<_GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<_GalleryScreen> {
  late final PageController _controller;
  int _index = 0;

  List<String> get _items {
    return [
      ...widget.property.imagePaths,
      if (widget.property.videoPath != null) 'video:${widget.property.videoPath}',
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: items.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final item = items[i];
                if (item.startsWith('video:')) {
                  return _VideoPlayerView(path: item.replaceFirst('video:', ''));
                }
                return InteractiveViewer(
                  child: Center(
                    child: buildPropertyImage(item, fit: BoxFit.contain),
                  ),
                );
              },
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${_index + 1} / ${items.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayerView extends StatefulWidget {
  final String path;

  const _VideoPlayerView({required this.path});

  @override
  State<_VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<_VideoPlayerView> {
  VideoPlayerController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = (widget.path.startsWith('http://') || widget.path.startsWith('https://')) ? VideoPlayerController.networkUrl(Uri.parse(widget.path)) : VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        if (mounted) setState(() => _ready = true);
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _controller == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller!),
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                });
              },
              child: AnimatedOpacity(
                opacity: _controller!.value.isPlaying ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
