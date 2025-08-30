import 'package:flutter/material.dart';

String token = '';
String role = '';

ThemeData theme = ThemeData(
  primaryColor: const Color.fromARGB(255, 129, 237, 194),
  colorScheme: ColorScheme.light(
    primary: const Color.fromARGB(255, 129, 237, 194),
    secondary: const Color.fromARGB(255, 129, 237, 194).withOpacity(0.8),
  ),
  scaffoldBackgroundColor: Colors.grey[50],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 129, 237, 194),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: const Color.fromARGB(255, 129, 237, 194).withOpacity(0.4),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 129, 237, 194),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color.fromARGB(255, 129, 237, 194),
      side: const BorderSide(color: Color.fromARGB(255, 129, 237, 194), width: 1.5),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
      const BorderSide(color: Color.fromARGB(255, 129, 237, 194), width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    labelStyle: TextStyle(color: Colors.grey[600]),
    floatingLabelStyle: const TextStyle(color: Color.fromARGB(255, 129, 237, 194)),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: -0.5),
    titleMedium: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
  ),
);
