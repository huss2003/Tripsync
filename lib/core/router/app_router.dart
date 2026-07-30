import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../../features/auth/presentation/phone_entry_screen.dart';
import '../../features/auth/presentation/otp_verification_screen.dart';
import '../../features/auth/presentation/profile_setup_screen.dart';
import 'app_router_stubs.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final loggedIn = authState.status == AuthStatus.authenticated;
      final onAuthScreen = state.matchedLocation == '/phone-entry' ||
          state.matchedLocation.startsWith('/otp') ||
          state.matchedLocation == '/profile-setup';

      if (state.matchedLocation == '/splash') return null;
      if (!loggedIn && !onAuthScreen) return '/phone-entry';
      if (loggedIn && onAuthScreen) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const StubScreen('Splash')),
      GoRoute(path: '/phone-entry', builder: (_, _) => const PhoneEntryScreen()),
      GoRoute(path: '/otp', builder: (_, state) => OtpVerificationScreen(phone: state.extra as String? ?? '')),
      GoRoute(path: '/profile-setup', builder: (_, _) => const ProfileSetupScreen()),
      ...authRoutes(),
    ],
  );
});
