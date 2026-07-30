import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

/// C.11 Itinerary / Timeline — chronological plan of a selected package.
class ItineraryScreen extends ConsumerWidget {
  final String packageId;
  const ItineraryScreen({super.key, required this.packageId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<TripSyncColors>()!;
    final theme = Theme.of(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Supabase.instance.client
          .from('package_legs')
          .select('leg_type, provider, price, details, deep_link_url')
          .eq('package_id', packageId)
          .eq('is_hidden', false)
          .then((d) => (d as List).cast<Map<String, dynamic>>()),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Itinerary')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final legs = snap.data ?? [];

        return Scaffold(
          backgroundColor: colors.bgPrimary,
          appBar: AppBar(title: const Text('Itinerary')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (legs.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text('No itinerary details yet',
                        style: theme.textTheme.bodyLarge),
                  ),
                )
              else
                for (var i = 0; i < legs.length; i++) ...[
                  _TimelineNode(
                    icon: _legIcon(legs[i]['leg_type'] as String),
                    label: '${legs[i]['leg_type']} — ${legs[i]['provider']}',
                    detail: '₹${(legs[i]['price'] as num).toStringAsFixed(0)}',
                    isLast: i == legs.length - 1,
                    colors: colors,
                    theme: theme,
                  ),
                ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    backgroundColor: colors.bgPrimary,
                    builder: (_) => _CalendarSheet(colors: colors),
                  ),
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('Add to Calendar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _legIcon(String type) => switch (type) {
    'flight' => Icons.flight,
    'hotel' => Icons.bed,
    'cab' => Icons.directions_car,
    'train' => Icons.train,
    'bus' => Icons.directions_bus,
    _ => Icons.place,
  };
}

class _TimelineNode extends StatelessWidget {
  final IconData icon;
  final String label, detail;
  final bool isLast;
  final TripSyncColors colors;
  final ThemeData theme;

  const _TimelineNode({
    required this.icon, required this.label, required this.detail,
    required this.isLast, required this.colors, required this.theme,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          Icon(icon, size: 24, color: colors.brandPrimary),
          if (!isLast)
            Expanded(
              child: VerticalDivider(
                width: 24, thickness: 2, color: colors.borderDefault,
              ),
            ),
        ]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.titleMedium),
              Text(detail, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CalendarSheet extends StatelessWidget {
  final TripSyncColors colors;
  const _CalendarSheet({required this.colors});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: colors.bgPrimary,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 40, height: 4,
          decoration: BoxDecoration(
            color: colors.borderDefault,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Add to calendar', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: AppSpacing.lg),
        ListTile(
          leading: const Icon(Icons.calendar_month),
          title: const Text('Add to Google Calendar'),
          onTap: () => Navigator.pop(context),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.download),
          title: const Text('Download .ics file'),
          onTap: () => Navigator.pop(context),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}
