import 'dart:io';
import 'package:flutter/material.dart';

Widget buildPropertyImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
}) {
  if (path.startsWith('assets/')) {
    return Image.asset(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: errorBuilder,
    );
  }
  return Image.file(
    File(path),
    fit: fit,
    width: width,
    height: height,
    errorBuilder: errorBuilder,
  );
}
