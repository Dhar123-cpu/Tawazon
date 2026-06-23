import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF3ECFBF);
  static const Color primaryDark = Color(0xFF00A896);
  static const Color secondaryColor = Color(0xFFB39DDB);
  static const Color accentLavender = Color(0xFF9C7FD4);
  static const Color backgroundColor = Color(0xFFF7F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Color(0xFF1E2D47);
  static const Color textSecondary = Color(0xFF6B7A99);
  static const Color cardColor = Colors.white;

  // Gradient presets used across the app
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF4DB6AC), Color(0xFF9C7FD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [Color(0xFF7C4DFF), Color(0xFFB39DDB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mintGradient = LinearGradient(
    colors: [Color(0xFF43E8D8), Color(0xFF4DB6AC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Reusable shadow presets
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get heroShadow => [
        BoxShadow(
          color: const Color(0xFF4DB6AC).withOpacity(0.30),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get lavendeShadow => [
        BoxShadow(
          color: const Color(0xFFB39DDB).withOpacity(0.28),
          blurRadius: 24,
          offset: const Offset(0, 10),
        ),
      ];

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: Color(0xFFE57373),
        surface: surfaceColor,
        onSurface: textColor,
        onPrimary: Colors.white,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          color: textColor,
          fontSize: 40.0,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
        ),
        headlineLarge: GoogleFonts.poppins(
          color: textColor,
          fontSize: 30.0,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: textColor,
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineSmall: GoogleFonts.poppins(
          color: textColor,
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.poppins(
          color: textColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.poppins(
          color: textColor,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: textColor,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: textSecondary,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.poppins(
          color: textSecondary,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: const EdgeInsets.all(0),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0.0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: textColor),
        titleTextStyle: GoogleFonts.poppins(
          color: textColor,
          fontSize: 17.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: const Color(0xFFB0BAD0),
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 10.0,
          fontWeight: FontWeight.w500,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Color(0xFFE57373), width: 1.5),
        ),
        hintStyle: GoogleFonts.poppins(
          color: const Color(0xFFB0BAD0),
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? primaryColor : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? primaryColor.withOpacity(0.4)
              : Colors.grey.shade200,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFF0F2F5),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
