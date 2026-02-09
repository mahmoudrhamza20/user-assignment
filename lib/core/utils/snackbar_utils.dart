import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class SnackBarUtils {
  const SnackBarUtils._();

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, AppColors.info);
  }

  static void _show(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
