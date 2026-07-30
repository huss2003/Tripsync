import 'package:flutter/material.dart';

/// TripSync color tokens — maps 1:1 to UCL/Frontend Spec section A.1.
/// Access via `Theme.of(context).extension<TripSyncColors>()`.
class TripSyncColors extends ThemeExtension<TripSyncColors> {
  final Color bgPrimary;
  final Color bgSurface;
  final Color textPrimary;
  final Color textSecondary;
  final Color brandPrimary;
  final Color accentCheap;
  final Color accentBalanced;
  final Color accentPremium;
  final Color statusError;
  final Color statusWarning;
  final Color statusSuccess;
  final Color borderDefault;

  const TripSyncColors({
    required this.bgPrimary,
    required this.bgSurface,
    required this.textPrimary,
    required this.textSecondary,
    required this.brandPrimary,
    required this.accentCheap,
    required this.accentBalanced,
    required this.accentPremium,
    required this.statusError,
    required this.statusWarning,
    required this.statusSuccess,
    required this.borderDefault,
  });

  static const light = TripSyncColors(
    bgPrimary: Color(0xFFFFFFFF),
    bgSurface: Color(0xFFF7F8FA),
    textPrimary: Color(0xFF16181D),
    textSecondary: Color(0xFF6B7280),
    brandPrimary: Color(0xFF2453FF),
    accentCheap: Color(0xFF1DA05C),
    accentBalanced: Color(0xFF2453FF),
    accentPremium: Color(0xFFC9922B),
    statusError: Color(0xFFD33A3A),
    statusWarning: Color(0xFFC9922B),
    statusSuccess: Color(0xFF1DA05C),
    borderDefault: Color(0xFFE4E6EB),
  );

  static const dark = TripSyncColors(
    bgPrimary: Color(0xFF121212),
    bgSurface: Color(0xFF1E1E1E),
    textPrimary: Color(0xFFF2F2F2),
    textSecondary: Color(0xFFA0A3A8),
    brandPrimary: Color(0xFF5B7FFF),
    accentCheap: Color(0xFF34C97A),
    accentBalanced: Color(0xFF5B7FFF),
    accentPremium: Color(0xFFE0AB4C),
    statusError: Color(0xFFE85C5C),
    statusWarning: Color(0xFFE0AB4C),
    statusSuccess: Color(0xFF34C97A),
    borderDefault: Color(0xFF2C2C2E),
  );

  @override
  TripSyncColors copyWith({
    Color? bgPrimary,
    Color? bgSurface,
    Color? textPrimary,
    Color? textSecondary,
    Color? brandPrimary,
    Color? accentCheap,
    Color? accentBalanced,
    Color? accentPremium,
    Color? statusError,
    Color? statusWarning,
    Color? statusSuccess,
    Color? borderDefault,
  }) =>
      TripSyncColors(
        bgPrimary: bgPrimary ?? this.bgPrimary,
        bgSurface: bgSurface ?? this.bgSurface,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        brandPrimary: brandPrimary ?? this.brandPrimary,
        accentCheap: accentCheap ?? this.accentCheap,
        accentBalanced: accentBalanced ?? this.accentBalanced,
        accentPremium: accentPremium ?? this.accentPremium,
        statusError: statusError ?? this.statusError,
        statusWarning: statusWarning ?? this.statusWarning,
        statusSuccess: statusSuccess ?? this.statusSuccess,
        borderDefault: borderDefault ?? this.borderDefault,
      );

  @override
  TripSyncColors lerp(ThemeExtension<TripSyncColors>? other, double t) {
    if (other is! TripSyncColors) return this;
    return TripSyncColors(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      accentCheap: Color.lerp(accentCheap, other.accentCheap, t)!,
      accentBalanced: Color.lerp(accentBalanced, other.accentBalanced, t)!,
      accentPremium: Color.lerp(accentPremium, other.accentPremium, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
    );
  }
}
