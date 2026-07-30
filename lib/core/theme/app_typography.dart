import 'package:flutter/material.dart';

/// TripSync typography — maps 1:1 to UCL/Frontend Spec §A.2.
/// Single type family (system default), max 3 weights in active use.
TextTheme tripsyncTextTheme() {
  const body = TextStyle(
    fontFamily: null, // platform default (SF Pro / Roboto)
    fontWeight: FontWeight.w400,
    fontSize: 15,
    letterSpacing: 0,
  );

  return const TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.w700, fontSize: 28,
    ), // type/display
    headlineLarge: TextStyle(
      fontWeight: FontWeight.w600, fontSize: 20,
    ), // type/heading
    titleLarge: TextStyle(
      fontWeight: FontWeight.w600, fontSize: 17,
    ), // type/subheading
    bodyLarge: body, // type/body
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w500, fontSize: 12,
    ), // type/caption
    labelLarge: TextStyle(
      fontWeight: FontWeight.w600, fontSize: 16,
    ), // type/button
  );
}
