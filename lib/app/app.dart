import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/router/app_router.dart';
import '../l10n/app_localizations.dart';

/// TripSync root widget — wires theme, router, Riverpod, and i18n.
class TripSyncApp extends ConsumerWidget {
  const TripSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'TripSync',
      debugShowCheckedModeBanner: false,
      theme: tripsyncTheme(brightness: Brightness.light),
      darkTheme: tripsyncTheme(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
