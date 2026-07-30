import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../presentation/auth_notifier.dart';

/// C.2 Phone Entry — collect phone number, trigger OTP.
class PhoneEntryScreen extends ConsumerWidget {
  const PhoneEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final phoneCtrl = TextEditingController();
    final colors = Theme.of(context).extension<TripSyncColors>()!;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 2),
              Text('Enter your phone number',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: AppSpacing.sm),
              Text('We\'ll send you a one-time code.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: colors.textSecondary)),
              const SizedBox(height: AppSpacing.lg),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: colors.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.borderDefault),
                  ),
                  child: Text('+91',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colors.borderDefault),
                      ),
                    ),
                  ),
                ),
              ]),
              const Spacer(),
              if (authState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(authState.errorMessage!,
                      style: TextStyle(color: colors.statusError)),
                ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : () => ref
                          .read(authNotifierProvider.notifier)
                          .sendOtp('+91${phoneCtrl.text}'),
                  child: authState.status == AuthStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Send OTP'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
