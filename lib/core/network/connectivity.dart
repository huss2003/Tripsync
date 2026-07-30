import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Monitors connectivity state — surfaces a global offline banner.
final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map(
    (results) => results.any((r) => r != ConnectivityResult.none),
  );
});

/// C.16 Error / No Connectivity full-screen replacement.
class ConnectivityGuard extends ConsumerWidget {
  final Widget child;
  const ConnectivityGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(connectivityProvider).value ?? true;
    if (online) return child;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 64),
            const SizedBox(height: 16),
            Text('No internet connection',
                style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            const Text('Please check your connection and retry.'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref.invalidate(connectivityProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
