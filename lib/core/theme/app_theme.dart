import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Builds the TripSync ThemeData for light/dark mode.
ThemeData tripsyncTheme({required Brightness brightness}) {
  final isDark = brightness == Brightness.dark;
  final colors = isDark ? TripSyncColors.dark : TripSyncColors.light;

  final colorScheme = ColorScheme(
    brightness: brightness,
    primary: colors.brandPrimary,
    onPrimary: isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
    secondary: colors.accentBalanced,
    onSecondary: isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF),
    error: colors.statusError,
    onError: const Color(0xFFFFFFFF),
    surface: colors.bgSurface,
    onSurface: colors.textPrimary,
    outline: colors.borderDefault,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    textTheme: tripsyncTextTheme(),
    scaffoldBackgroundColor: colors.bgPrimary,
    extensions: [colors],
    cardTheme: CardThemeData(
      color: colors.bgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.borderDefault),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.bgPrimary,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dividerTheme: DividerThemeData(color: colors.borderDefault, thickness: 1),
  );
}
