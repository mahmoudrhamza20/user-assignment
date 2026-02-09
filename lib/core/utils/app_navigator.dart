import 'package:flutter/material.dart';

class AppNavigator {
  const AppNavigator._();

  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static Future<T?> pushReplacement<T, TO>(
      BuildContext context, Widget screen) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }
}
