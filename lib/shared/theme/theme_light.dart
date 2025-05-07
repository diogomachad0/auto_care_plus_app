import 'package:flutter/material.dart';

class ThemeLight {
  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor:  const Color(0xFF0D80BF)
    ,
    primary: const Color(0xFF0D80BF)
    ,
    secondary: const Color(0xFF063C59)
    ,
    brightness: Brightness.light,
  );
}