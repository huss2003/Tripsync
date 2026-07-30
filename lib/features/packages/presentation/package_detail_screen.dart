import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/ai_chat/presentation/chat_panel.dart';
import 'packages_provider.dart';

/// C.9 Package Detail — full breakdown of a selected package.
class PackageDetailScreen extends ConsumerWidget {
  final String packageId;
  const PackageDetailScreen({super.key, required this.packageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<TripSyncColors>()!;
    final theme = Theme.of(context);

    return FutureBuilder<List<TripPackage>>(
      future: Supabase.instance.client
          .from('trip_packages')
          .select()
          .eq('id', packageId)
          .then((d) => (d as List).map((e) => TripPackage.fromJson(e)).toList()),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
        }
        final pkg = snap.data?.firstOrNull;
        if (pkg == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Package not found')),
          );
        }

        final accent = switch (pkg.packageType) {
          'cheap' => colors.accentCheap,
          'premium' => colors.accentPremium,
          _ => colors.accentBalanced,
        };

        return Scaffold(
          backgroundColor: colors.bgPrimary,
          appBar: AppBar(title: Text('${pkg.packageType.toUpperCase()} Package')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text('₹${pkg.totalCost.toStringAsFixed(0)}',
                  style: theme.textTheme.displayLarge?.copyWith(color: accent)),
              const SizedBox(height: AppSpacing.sm),
              Text('${pkg.totalTravelTimeMinutes} min total travel',
                  style: theme.textTheme.bodyLarge),
              if (pkg.confidenceScore != null) ...[
                const SizedBox(height: AppSpacing.sm),
                LinearProgressIndicator(value: pkg.confidenceScore),
                Text('AI confidence: ${(pkg.confidenceScore! * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodyMedium),
              ],
              if (pkg.rationale != null) ...[
                const SizedBox(height: AppSpacing.md),
                const Text('Why this package', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: AppSpacing.sm),
                Text(pkg.rationale!),
              ],
              if (pkg.pros.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                const Text('Pros', style: TextStyle(fontWeight: FontWeight.w600)),
                ...pkg.pros.map((p) => ListTile(leading: Icon(Icons.check_circle, color: colors.statusSuccess), title: Text(p))),
              ],
              if (pkg.cons.isNotEmpty) ...[
                const Text('Cons', style: TextStyle(fontWeight: FontWeight.w600)),
                ...pkg.cons.map((c) => ListTile(leading: Icon(Icons.warning, color: colors.statusWarning), title: Text(c))),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: accent),
                  onPressed: () => context.go('/itinerary'),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Select this Package'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: colors.bgPrimary,
                  builder: (_) => ChatPanel(packageId: packageId),
                ),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Refine with AI'),
              ),
            ],
          ),
        );
      },
    );
  }
}
