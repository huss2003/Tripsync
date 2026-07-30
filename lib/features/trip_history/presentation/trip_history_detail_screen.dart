import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';

/// C.14 Trip History Detail (Read-Only).
class TripHistoryDetailScreen extends StatelessWidget {
  final String tripId;
  const TripHistoryDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Details')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trip ID: $tripId', style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/create-trip'),
                icon: const Icon(Icons.content_copy),
                label: const Text('Duplicate this trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
