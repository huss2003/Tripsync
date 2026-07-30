import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import '../../features/trip_creation/presentation/home_screen.dart';
import '../../features/trip_creation/presentation/create_trip_screen.dart';
import '../../features/packages/presentation/package_comparison_screen.dart';
import '../../features/packages/presentation/package_detail_screen.dart';

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

class GeneratingScreen extends StatefulWidget {
  final String tripId;
  const GeneratingScreen({super.key, required this.tripId});
  @override
  State<GeneratingScreen> createState() => _GeneratingScreenState();
}

class _GeneratingScreenState extends State<GeneratingScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate to compare after a brief delay (simulates generation)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/compare');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text('Generating your packages...',
              style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    ),
  );
}

List<RouteBase> authRoutes() => [
  GoRoute(path: '/home', name: AppRoutes.home, builder: (_, _) => const HomeScreen()),
  GoRoute(path: '/create-trip', name: AppRoutes.createTrip, builder: (_, _) => const CreateTripScreen()),
  GoRoute(path: '/generating', name: AppRoutes.packageGeneration, builder: (_, _) => const GeneratingScreen(tripId: 'new')),
  GoRoute(path: '/compare', name: AppRoutes.packageComparison, builder: (_, _) => const PackageComparisonScreen(tripId: 'new')),
  GoRoute(path: '/package/:id', name: AppRoutes.packageDetail, builder: (_, state) => PackageDetailScreen(packageId: state.pathParameters['id']!)),
  GoRoute(path: '/itinerary', name: AppRoutes.itinerary, builder: (_, _) => const StubScreen('Itinerary')),
  GoRoute(path: '/history', name: AppRoutes.tripHistoryList, builder: (_, _) => const StubScreen('Trip History')),
  GoRoute(path: '/history/:id', name: AppRoutes.tripHistoryDetail, builder: (_, state) => StubScreen('Trip ${state.pathParameters['id']}')),
  GoRoute(path: '/settings', name: AppRoutes.settings, builder: (_, _) => const StubScreen('Settings')),
  GoRoute(path: '/error', name: AppRoutes.errorConnectivity, builder: (_, _) => const ErrorScreen()),
];
