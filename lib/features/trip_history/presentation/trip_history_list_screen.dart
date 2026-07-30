import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import 'history_provider.dart';

/// C.13 Trip History List — reverse-chronological list of past trips.
class TripHistoryListScreen extends ConsumerWidget {
  const TripHistoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    final colors = Theme.of(context).extension<TripSyncColors>()!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(title: const Text('Trip History')),
      body: history.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$e', style: TextStyle(color: colors.statusError)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(historyProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (trips) {
          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No trips yet', style: theme.textTheme.headlineLarge),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: () => context.go('/create-trip'),
                    child: const Text('Plan your first trip'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: trips.length,
            separatorBuilder: (_, _) => Divider(color: colors.borderDefault),
            itemBuilder: (_, i) {
              final t = trips[i];
              return ListTile(
                title: Text('${t.source} → ${t.destination}'),
                subtitle: Text(t.departureDate ?? ''),
                trailing: Chip(label: Text(t.status)),
                onTap: () => context.go('/history/${t.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
