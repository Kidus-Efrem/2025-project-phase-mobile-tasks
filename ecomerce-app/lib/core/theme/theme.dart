import 'package:flutter/material.dart';

class Apptheme {
  static final lightThemeMode = ThemeData.light().copyWith(
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide

        (
          color: Colors.black,
          width: 4,

          )
        ),
    ),
  );
}
