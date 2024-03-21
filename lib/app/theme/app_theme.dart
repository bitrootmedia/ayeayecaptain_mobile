import 'package:ayeayecaptain_mobile/app/constants.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: seedColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: seedColor,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
