import 'package:flutter/material.dart';

class CustomTheme {
  static const Color darkCursorColor = Colors.grey;
  static const Color darkScaffoldColor = Color(0xFF1E1E1E);
  static const Color darkAppBarColor = Color(0xFF1E1E1E);
  static const Color darkPrimaryColor = Color(0xFF1E1E1E);
  static const Color darkPrimaryColorVariant = Color(0xFF0D0D0D);
  static const Color darkSecondaryColor = Color(0xFF4FE3A3);
  static const Color darkSecondaryColorVariant = Color(0xFFEDFE79);
  static const Color darkOutlineColor = Color(0xFF3D3D3D);

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFFCECECE),
      fontFamily: "Jost",
      fontWeight: FontWeight.w500,
      fontSize: 30,
    ),
    displayMedium: TextStyle(
      color: Color(0xFFCECECE),
      fontFamily: "Jost",
      fontWeight: FontWeight.w400,
      fontSize: 20,
    ),
    displaySmall: TextStyle(
      color: darkSecondaryColor,
      fontFamily: "Jost",
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
    headlineMedium: TextStyle(
      color: Color(0xFFC9C9C9),
      fontFamily: "Jost",
      fontWeight: FontWeight.w500,
      fontSize: 18,
    ),
    headlineSmall: TextStyle(
      color: darkSecondaryColor,
      fontFamily: "Jost",
      fontWeight: FontWeight.w500,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      color: Color(0xFFC9C9C9),
      fontFamily: "Jost",
      fontWeight: FontWeight.w500,
      fontSize: 11,
    ),
    labelSmall: TextStyle(
      color: Color(0xFFC9C9C9),
      fontFamily: "Jost",
      fontWeight: FontWeight.w500,
      fontSize: 11,
    ),
    bodyLarge: TextStyle(
      fontFamily: "Jost",
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: "Rufina-Regular",
      fontSize: 11,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontFamily: "Jost",
      fontSize: 14,
      color: Colors.white,
      decoration: TextDecoration.underline,
    ),
    labelLarge: TextStyle(
      color: Color(0xFFC9C9C9),
      fontFamily: "Jost",
      fontWeight: FontWeight.w500,
      fontSize: 13,
    ),
  );
}