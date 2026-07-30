import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import 'packages_provider.dart';

/// C.8 Package Comparison — swipeable deck of 3 package cards.
class PackageComparisonScreen extends ConsumerWidget {
  final String tripId;
  const PackageComparisonScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packagesStreamProvider(tripId));
    final colors = Theme.of(context).extension<TripSyncColors>()!;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(title: const Text('Compare Packages')),
      body: packagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$e', style: TextStyle(color: colors.statusError)),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => ref.invalidate(packagesStreamProvider(tripId)), child: const Text('Retry')),
            ],
          ),
        ),
        data: (packages) {
          if (packages.isEmpty) {
            return const Center(child: Text('No packages yet'));
          }
          return PageView.builder(
            itemCount: packages.length,
            itemBuilder: (_, i) => _PackageCard(
              pkg: packages[i],
              onTap: () => context.go('/package/${packages[i].id}'),
              colors: colors,
            ),
          );
        },
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final TripPackage pkg;
  final VoidCallback onTap;
  final TripSyncColors colors;

  const _PackageCard({
    required this.pkg, required this.onTap, required this.colors,
  });

  Color get _accent {
    switch (pkg.packageType) {
      case 'cheap': return colors.accentCheap;
      case 'premium': return colors.accentPremium;
      default: return colors.accentBalanced;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(pkg.packageType.toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(color: _accent)),
                Text('₹${pkg.totalCost.toStringAsFixed(0)}',
                    style: theme.textTheme.displayLarge),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Text('${pkg.totalTravelTimeMinutes} min travel',
                  style: theme.textTheme.bodyLarge),
              if (pkg.rationale != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(pkg.rationale!, style: theme.textTheme.bodyMedium),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: _accent),
                  onPressed: onTap,
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
