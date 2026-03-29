import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Calming colors suitable for PTSD users - Light theme only
  static const Color primaryBlue = Color(0xFF6B73FF);
  static const Color softGreen = Color(0xFF9CCC65);
  static const Color warmOrange = Color(0xFFFFB74D);
  static const Color lightBlue = Color(0xFF81C784);
  static const Color creamWhite = Color(0xFFFFFDF7);
  static const Color softGray = Color(0xFFF0F0F0);
  static const Color darkGray = Color(0xFF424242);
  static const Color emergencyRed = Color(0xFFE57373);
  static const Color calmPurple = Color(0xFFBA68C8);
  static const Color soothingTeal = Color(0xFF4DB6AC);
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryBlue,
      secondary: softGreen,
      tertiary: soothingTeal,
      surface: creamWhite,
      background: creamWhite,
      error: emergencyRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: darkGray,
      onBackground: darkGray,
    ),
    scaffoldBackgroundColor: creamWhite,
    fontFamily: GoogleFonts.poppins().fontFamily,
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkGray,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: darkGray,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkGray,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: darkGray,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: darkGray,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: creamWhite,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: darkGray,
      ),
      iconTheme: IconThemeData(color: darkGray),
    ),
    cardTheme: CardThemeData(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: softGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: softGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
    ),
  );
}
