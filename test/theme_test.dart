import 'package:flutter_test/flutter_test.dart';
import 'package:tripsync/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  test('ThemeData builds without error', () {
    final theme = tripsyncTheme(brightness: Brightness.light);
    expect(theme, isA<ThemeData>());
    expect(theme.brightness, Brightness.light);
  });

  test('Dark theme builds without error', () {
    final theme = tripsyncTheme(brightness: Brightness.dark);
    expect(theme, isA<ThemeData>());
    expect(theme.brightness, Brightness.dark);
  });
}
