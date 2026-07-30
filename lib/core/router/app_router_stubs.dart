import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../features/trip_creation/presentation/home_screen.dart';

/// C.16 Error / No Connectivity.
class ErrorScreen extends StatelessWidget {
  final String? message;
  const ErrorScreen({super.key, this.message});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message ?? 'Something went wrong',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go('/home'),
            child: const Text('Retry'),
          ),
        ],
      ),
    ),
  );
}

// Remaining stubs.
class StubScreen extends StatelessWidget {
  final String title;
  const StubScreen(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
}

List<RouteBase> authRoutes() => [
  GoRoute(path: '/home', name: AppRoutes.home, builder: (_, _) => const HomeScreen()),
  GoRoute(path: '/create-trip', name: AppRoutes.createTrip, builder: (_, _) => const StubScreen('Create Trip')),
  GoRoute(path: '/generating', name: AppRoutes.packageGeneration, builder: (_, _) => const StubScreen('Generating Packages')),
  GoRoute(path: '/compare', name: AppRoutes.packageComparison, builder: (_, _) => const StubScreen('Compare Packages')),
  GoRoute(path: '/package/:id', name: AppRoutes.packageDetail, builder: (_, state) => StubScreen('Package ${state.pathParameters['id']}')),
  GoRoute(path: '/itinerary', name: AppRoutes.itinerary, builder: (_, _) => const StubScreen('Itinerary')),
  GoRoute(path: '/history', name: AppRoutes.tripHistoryList, builder: (_, _) => const StubScreen('Trip History')),
  GoRoute(path: '/history/:id', name: AppRoutes.tripHistoryDetail, builder: (_, state) => StubScreen('Trip ${state.pathParameters['id']}')),
  GoRoute(path: '/settings', name: AppRoutes.settings, builder: (_, _) => const StubScreen('Settings')),
  GoRoute(path: '/error', name: AppRoutes.errorConnectivity, builder: (_, _) => const ErrorScreen()),
];
