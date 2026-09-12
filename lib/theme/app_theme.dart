import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 0, 122, 255);
  static const Color secondaryColor = Color.fromARGB(255, 153, 153, 153);
  static const Color textColor = Colors.black;
  static const Color textSecondaryColor = Color.fromARGB(255, 72, 72, 72);
  static const Color backgroundColor = Color.fromARGB(255, 247, 247, 247);
  static const Color cardColor = Colors.white;

  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
      borderSide: BorderSide(color: secondaryColor, width: 1.5,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(16.0),
      ),
      borderSide: BorderSide(color: primaryColor, width: 2,
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    inputDecorationTheme: inputDecorationTheme,
  );
}

