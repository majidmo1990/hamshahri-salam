import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressor {
  /// فشرده‌سازی عکس با حفظ کیفیت
  /// 
  /// - [file]: فایل اصلی
  /// - [quality]: کیفیت (پیشنهاد: ۸۵)
  /// - [maxWidth]: حداکثر عرض (پیشنهاد: ۱۴۰۰)
  /// - [maxHeight]: حداکثر ارتفاع (پیشنهاد: ۱۴۰۰)
  static Future<File> compress(
    File file, {
    int quality = 85,
    int maxWidth = 1400,
    int maxHeight = 1400,
  }) async {
    try {
      final compressedPath = '${file.parent.path}/compressed_${file.path.split('/').last}';
      
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        compressedPath,
        quality: quality,
        minWidth: maxWidth,
        minHeight: maxHeight,
        format: CompressFormat.jpeg,
      );
      
      if (result == null) {
        return file;
      }
      
      final compressedFile = File(result.path);
      
      final originalSize = await file.length();
      final compressedSize = await compressedFile.length();
      
      print('📦 فشرده‌سازی: $originalSize → $compressedSize bytes '
          '(${(compressedSize / originalSize * 100).toStringAsFixed(1)}%)');
      
      if (compressedSize >= originalSize) {
        await compressedFile.delete();
        return file;
      }
      
      return compressedFile;
    } catch (e) {
      print('⚠️ خطا در فشرده‌سازی: $e');
      return file;
    }
  }
}
