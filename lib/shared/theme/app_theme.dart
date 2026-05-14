import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seed = Color(0xFF1565C0);
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    searchBarTheme: SearchBarThemeData(
      elevation: WidgetStateProperty.all(1),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}
