import 'package:flutter/material.dart';

class MyThemes {
  ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
        background: Colors.deepPurple.shade100,
        primary: Colors.deepPurple,
        secondary: Colors.grey.shade800,
        tertiary: Colors.deepPurple.shade300),
    useMaterial3: true,
    brightness: Brightness.light,
  );

  ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
        background: Colors.grey.shade800,
        primary: Colors.grey.shade500,
        secondary: Colors.grey.shade300,
        tertiary: Colors.grey.shade700),
    useMaterial3: true,
    brightness: Brightness.dark,
  );
}
