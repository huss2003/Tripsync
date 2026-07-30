import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import 'trip_form_provider.dart';

/// C.6 Create Trip (Trip Form) — captures all AI planning inputs.
class CreateTripScreen extends ConsumerWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(tripFormProvider);
    final notifier = ref.read(tripFormProvider.notifier);
    final colors = Theme.of(context).extension<TripSyncColors>()!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(title: const Text('Plan your trip')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _LocationField(
            label: 'From',
            value: form.source,
            onChanged: notifier.setSource,
            colors: colors,
            theme: theme,
          ),
          const SizedBox(height: AppSpacing.sm),
          _LocationField(
            label: 'To',
            value: form.destination,
            onChanged: notifier.setDestination,
            colors: colors,
            theme: theme,
          ),
          const SizedBox(height: AppSpacing.md),
          _DateField(
            label: 'Departure',
            value: form.departureDate,
            onChanged: notifier.setDepartureDate,
            colors: colors,
          ),
          const SizedBox(height: AppSpacing.sm),
          _DateField(
            label: 'Return (optional)',
            value: form.returnDate,
            onChanged: notifier.setReturnDate,
            colors: colors,
          ),
          const SizedBox(height: AppSpacing.md),
          _TextField(
            label: 'Purpose (optional)',
            value: form.purpose,
            onChanged: notifier.setPurpose,
            colors: colors,
          ),
          const SizedBox(height: AppSpacing.sm),
          _TextField(
            label: 'Meeting address (optional)',
            value: form.meetingAddress,
            onChanged: notifier.setMeetingAddress,
            colors: colors,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Travellers', style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          Row(children: [
            IconButton(
              onPressed: form.travellerCount > 1
                  ? () => notifier.setTravellerCount(form.travellerCount - 1)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('${form.travellerCount}',
                style: theme.textTheme.headlineLarge),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: () => notifier.setTravellerCount(form.travellerCount + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ]),
          const SizedBox(height: AppSpacing.md),
          TextField(
            decoration: InputDecoration(
              labelText: 'Budget (optional)',
              prefixText: '₹ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.borderDefault),
              ),
            ),
            keyboardType: TextInputType.number,
            onChanged: notifier.setBudget,
          ),
          if (form.error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(form.error!, style: TextStyle(color: colors.statusError)),
          ],
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: form.isValid && !form.isSubmitting
                  ? () async {
                      await notifier.submit();
                      if (context.mounted) context.go('/generating');
                    }
                  : null,
              child: form.isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Generate Packages'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

// ---- helpers ----

class _LocationField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final TripSyncColors colors;
  final ThemeData theme;
  const _LocationField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.colors,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colors.borderDefault),
      ),
    ),
    onChanged: onChanged,
  );
}

class _TextField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final TripSyncColors colors;
  const _TextField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colors.borderDefault),
      ),
    ),
    onChanged: onChanged,
  );
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final TripSyncColors colors;
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: value ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (picked != null) onChanged(picked);
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.borderDefault),
        ),
      ),
      child: Text(
        value != null
            ? '${value!.day}/${value!.month}/${value!.year}'
            : 'Select date',
      ),
    ),
  );
}
