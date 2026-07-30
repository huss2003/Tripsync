import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// C.5 Home / Dashboard — one-tap trip creation + recent trips.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TripSync'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            width: double.infinity,
            height: 64,
            child: FilledButton.icon(
              onPressed: () => context.go('/create-trip'),
              icon: const Icon(Icons.flight_takeoff),
              label: const Text('Create Trip',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 32),
          Text('Recent Trips',
              style: theme.textTheme.headlineLarge),
          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text('Plan your first trip',
                  style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ),
          ),
        ],
      ),
    );
  }
}
