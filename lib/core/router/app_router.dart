import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

Widget _stub(String title) => Scaffold(
  appBar: AppBar(title: Text(title)),
  body: Center(child: Text(title)),
);

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', name: AppRoutes.splash, builder: (_, _) => _stub('Splash')),
    GoRoute(path: '/phone-entry', name: AppRoutes.phoneEntry, builder: (_, _) => _stub('Phone Entry')),
    GoRoute(path: '/otp', name: AppRoutes.otpVerification, builder: (_, _) => _stub('OTP Verification')),
    GoRoute(path: '/profile-setup', name: AppRoutes.profileSetup, builder: (_, _) => _stub('Profile Setup')),
    GoRoute(path: '/home', name: AppRoutes.home, builder: (_, _) => _stub('Home')),
    GoRoute(path: '/create-trip', name: AppRoutes.createTrip, builder: (_, _) => _stub('Create Trip')),
    GoRoute(path: '/generating', name: AppRoutes.packageGeneration, builder: (_, _) => _stub('Generating Packages')),
    GoRoute(path: '/compare', name: AppRoutes.packageComparison, builder: (_, _) => _stub('Compare Packages')),
    GoRoute(path: '/package/:id', name: AppRoutes.packageDetail, builder: (_, state) => _stub('Package ${state.pathParameters['id']}')),
    GoRoute(path: '/itinerary', name: AppRoutes.itinerary, builder: (_, _) => _stub('Itinerary')),
    GoRoute(path: '/history', name: AppRoutes.tripHistoryList, builder: (_, _) => _stub('Trip History')),
    GoRoute(path: '/history/:id', name: AppRoutes.tripHistoryDetail, builder: (_, state) => _stub('Trip ${state.pathParameters['id']}')),
    GoRoute(path: '/settings', name: AppRoutes.settings, builder: (_, _) => _stub('Settings')),
    GoRoute(path: '/error', name: AppRoutes.errorConnectivity, builder: (_, _) => _stub('No Connectivity')),
  ],
);
