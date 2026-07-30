import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';

/// C.12 Calendar Export Bottom Sheet.
class CalendarExportSheet extends StatelessWidget {
  const CalendarExportSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<TripSyncColors>()!;
    return Container(
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
            onTap: () {
              // Google Calendar API — Phase 7b enhancement
              Navigator.pop(context);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download .ics file'),
            onTap: () {
              // ICS generation — Phase 7b enhancement
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// C.15 Settings / Profile & Preferences.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<TripSyncColors>()!;
    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.borderDefault),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Preferred Airlines'),
          // Airlines multi-select — future
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'budget', label: Text('Budget')),
              ButtonSegment(value: 'mid', label: Text('Mid')),
              ButtonSegment(value: 'luxury', label: Text('Luxury')),
            ],
            selected: const {'mid'},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              context.go('/phone-entry');
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: colors.statusError),
            title: Text('Delete Account', style: TextStyle(color: colors.statusError)),
            onTap: () {
              showDialog(context: context, builder: (_) =>
                AlertDialog(
                  title: const Text('Delete Account'),
                  content: const Text('This cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Delete')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
