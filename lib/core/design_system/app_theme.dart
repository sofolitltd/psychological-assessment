import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF6750A4);
  static const primaryLight = Color(0xFFEADDFF);
  static const background = Color(0xFFFBFDF9);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF1C1B1F);
  static const textSecondary = Color(0xFF49454F);
  static const border = Color(0xFFCAC4D0);

  // Dark Mode
  static const backgroundDark = Color(0xFF0D1117);
  static const surfaceDark = Color(0xFF161B22);
  static const textPrimaryDark = Color(0xFFE6E1E5);
  static const textSecondaryDark = Color(0xFFCAC4D0);
  static const borderDark = Color(0xFF30363D);

  static const cardShadow = Color(0x14000000);
}

Color sensitivityColor(String level) {
  switch (level) {
    case 'High':
      return const Color(0xFFE53935);
    case 'Medium':
      return const Color(0xFFFB8C00);
    case 'Low':
      return const Color(0xFF43A047);
    default:
      return const Color(0xFFD9D7D7);
  }
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class AppRadius {
  static final roundedSm = BorderRadius.circular(8);
  static final roundedMd = BorderRadius.circular(12);
  static final roundedLg = BorderRadius.circular(16);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.outfit().fontFamily,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: GoogleFonts.outfit().fontFamily,
    );
  }
}

class MaxWidthContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const MaxWidthContainer({super.key, required this.child, this.maxWidth = 600});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
