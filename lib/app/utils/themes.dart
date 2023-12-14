//This files manages the themes of the app

import 'package:flutter/material.dart';

final asLightTheme = _buildLightTheme();
final asDarkTheme = _buildDarkTheme();

ThemeData baseTheme() {
  return ThemeData(
    useMaterial3: true,
    applyElevationOverlayColor: true,
    primarySwatch: Colors.blue,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      elevation: 2,
    ),
  );
}

ThemeData _buildLightTheme() {
  return baseTheme().copyWith(
    brightness: Brightness.light,
  );
}

ThemeData _buildDarkTheme() {
  return baseTheme().copyWith(
    brightness: Brightness.dark,
  );
}
