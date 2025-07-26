import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle heading1(BuildContext context) {
    return TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle heading2(BuildContext context) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle body1(BuildContext context) {
    return TextStyle(
      fontSize: 16,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle caption(BuildContext context) {
    return TextStyle(
      fontSize: 12,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
    );
  }
}
