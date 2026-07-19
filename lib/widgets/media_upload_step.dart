import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';

class MediaUploadStep extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const MediaUploadStep({
    super.key,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  State<MediaUploadStep> createState() => _MediaUploadStepState();
}

class _MediaUploadStepState extends State<MediaUploadStep> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];
  File? _video;
  String? _videoWarning;
  bool _isSubmitting = false;

  static const int maxVideoSizeBytes = 30 * 1024 * 1024; // 30 مگابایت

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() => _images.add(File(picked.path)));
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final picked = await _picker.pickVideo(
      source: source,
      maxDuration: const Duration(seconds: 60),
    );
    if (picked == null) return;

    final file = File(picked.path);
    final sizeBytes = await file.length();

    setState(() {
      _video = file;
      _videoWarning = sizeBytes > maxVideoSizeBytes
          ? 'حجم ویدیو ${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} مگابایت است. لطفاً ویدیویی با حجم کمتر از ۳۰ مگابایت انتخاب کنید یا با کیفیت پایین‌تر دوباره فیلمبرداری کنید.'
          : null;
    });
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  void _removeVideo() {
    setState(() {
      _video = null;
      _videoWarning = null;
    });
  }

  bool get _canSubmit =>
      _images.isNotEmpty && _video != null && _videoWarning == null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionLabel('تصاویر ملک', isDark),
          const SizedBox(height: 10),
          _buildImageGrid(isDark),
          const SizedBox(height: 24),
          _sectionLabel('ویدیوی ملک', isDark),
          const SizedBox(height: 4),
          Text(
            'ویدیو الزامی است. حداکثر مدت: ۱ دقیقه — حداکثر حجم: ۳۰ مگابایت',
            style: TextStyle(
              fontSize: 11.5,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          _buildVideoArea(isDark),
          if (_videoWarning != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.redAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _videoWarning!,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                    onPressed: widget.onBack,
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
                            widget.onSubmit();
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
            ],
          );
        }),
        _addTile(
          isDark,
          icon: Icons.add_photo_alternate_outlined,
          onTap: () => _showImageSourceSheet(isDark),
        ),
      ],
    );
  }

  Widget _buildVideoArea(bool isDark) {
    if (_video != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.skyBlue,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.videocam_rounded, color: AppColors.primaryBlue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _video!.path.split('/').last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              onPressed: _removeVideo,
            ),
          ],
        ),
      );
    }

    return _addTile(
      isDark,
      icon: Icons.videocam_outlined,
      label: 'افزودن ویدیو',
      fullWidth: true,
      onTap: () => _showVideoSourceSheet(isDark),
    );
  }

  Widget _addTile(
    bool isDark, {
    required IconData icon,
    required VoidCallback onTap,
    String? label,
    bool fullWidth = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : 90,
        height: fullWidth ? 60 : 90,
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
            Icon(icon, color: AppColors.primaryBlue, size: fullWidth ? 22 : 26),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showImageSourceSheet(bool isDark) {
    _showSourceSheet(
      isDark: isDark,
      onCamera: () => _pickImage(ImageSource.camera),
      onGallery: () => _pickImage(ImageSource.gallery),
    );
  }

  void _showVideoSourceSheet(bool isDark) {
    _showSourceSheet(
      isDark: isDark,
      onCamera: () => _pickVideo(ImageSource.camera),
      onGallery: () => _pickVideo(ImageSource.gallery),
    );
  }

  void _showSourceSheet({
    required bool isDark,
    required VoidCallback onCamera,
    required VoidCallback onGallery,
  }) {
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
                  onCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined,
                    color: AppColors.primaryBlue),
                title: const Text('انتخاب از گالری', textAlign: TextAlign.right),
                onTap: () {
                  Navigator.pop(context);
                  onGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
