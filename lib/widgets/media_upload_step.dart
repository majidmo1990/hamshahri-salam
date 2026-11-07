import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class MediaUploadStep extends StatefulWidget {
  final VoidCallback onBack;
  final void Function(List<String> images) onSubmit;
  final List<String>? initialImages;

  const MediaUploadStep({
    super.key,
    required this.onBack,
    required this.onSubmit,
    this.initialImages,
  });

  @override
  State<MediaUploadStep> createState() => _MediaUploadStepState();
}

class _MediaUploadStepState extends State<MediaUploadStep> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];
  bool _isSubmitting = false;

  static const int maxImages = 7;

  @override
  void initState() {
    super.initState();
    // بارگذاری عکس‌های قبلی (اگه برگشتیم)
    if (widget.initialImages != null) {
      _images.addAll(widget.initialImages!.map((p) => File(p)));
    }
  }

  Future<void> _pickImagesFromGallery() async {
    if (_images.length >= maxImages) {
      _showError('حداکثر $maxImages عکس می‌توانید انتخاب کنید');
      return;
    }

    final remaining = maxImages - _images.length;
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    
    if (picked.isEmpty) return;

    // محدود کردن به تعداد باقی‌مانده
    final toAdd = picked.take(remaining).toList();
    
    if (picked.length > remaining) {
      _showError('فقط $remaining عکس دیگر می‌توانید اضافه کنید');
    }

    setState(() {
      _images.addAll(toAdd.map((p) => File(p.path)));
    });
  }

  Future<void> _pickImageFromCamera() async {
    if (_images.length >= maxImages) {
      _showError('حداکثر $maxImages عکس می‌توانید انتخاب کنید');
      return;
    }

    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _images.add(File(picked.path)));
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  bool get _canSubmit => _images.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionLabel('تصاویر ملک', isDark),
          const SizedBox(height: 4),
          Text(
            'حداقل ۱ و حداکثر $maxImages عکس — برای نتیجه بهتر، از زوایای مختلف عکس بگیرید',
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          _buildImageGrid(isDark),
          const SizedBox(height: 24),
          if (_images.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'آگهی بدون عکس تایید نمی‌شود. لطفاً حداقل یک عکس اضافه کنید.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    onPressed: _isSubmitting ? null : widget.onBack,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      disabledBackgroundColor: AppColors.primaryBlue
                          .withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _canSubmit && !_isSubmitting
                        ? () {
                            setState(() => _isSubmitting = true);
                            widget.onSubmit(_images.map((f) => f.path).toList());
                          }
                        : null,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'ثبت و ارسال',
                            style: TextStyle(color: Colors.white),
                          ),
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

  Widget _sectionLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : Colors.black87,
      ),
    );
  }

  Widget _buildImageGrid(bool isDark) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ..._images.asMap().entries.map((entry) {
          final index = entry.key;
          final file = entry.value;
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  file,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                left: 4,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        size: 14, color: Colors.white),
                  ),
                ),
              ),
              // شماره عکس
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        if (_images.length < maxImages)
          _addTile(
            isDark,
            icon: Icons.add_photo_alternate_outlined,
            label: 'افزودن (${_images.length}/$maxImages)',
            onTap: () => _showImageSourceSheet(isDark),
          ),
      ],
    );
  }

  Widget _addTile(
    bool isDark, {
    required IconData icon,
    required VoidCallback onTap,
    String? label,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 26),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined,
                    color: AppColors.primaryBlue),
                title: const Text('گرفتن با دوربین', textAlign: TextAlign.right),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: AppColors.primaryBlue),
                title: const Text('انتخاب از گالری (چندتایی)',
                    textAlign: TextAlign.right),
                subtitle: const Text('می‌توانید چند عکس را همزمان انتخاب کنید',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 11)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImagesFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
