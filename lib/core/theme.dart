import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateProvider<bool>((ref) => false);

class AppColors {
  static const Color primaryBlue = Colors.blue;
  static const Color successGreen = Colors.green;
  static const Color warningOrange = Colors.orange;
  static const Color dangerRed = Colors.red;
}