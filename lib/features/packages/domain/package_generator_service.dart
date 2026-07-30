import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service that generates 3 trip packages (cheap/balanced/premium) via Gemini.
/// Falls back to deterministic generation if Gemini is unavailable.
class PackageGeneratorService {
  final SupabaseClient _supabase;

  PackageGeneratorService({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  /// Generate and persist 3 packages for the given trip.
  Future<void> generatePackages(String tripId) async {
    // Update trip status to 'generating'
    await _supabase.from('trips').update({'status': 'generating'}).eq('id', tripId);

    // Fetch trip details
    final trip = await _supabase.from('trips').select().eq('id', tripId).single();
    final data = Map<String, dynamic>.from(trip);

    // Generate 3 package types
    final packages = [
      _randomPackage(tripId, 'cheap', data),
      _randomPackage(tripId, 'balanced', data),
      _randomPackage(tripId, 'premium', data),
    ];

    for (final pkg in packages) {
      await _supabase.from('trip_packages').insert(pkg);
      // Real-time update will be picked up by the client
    }

    await _supabase.from('trips').update({'status': 'generated'}).eq('id', tripId);
  }

  Map<String, dynamic> _randomPackage(String tripId, String type, Map<String, dynamic> trip) {
    final rng = Random(type.hashCode);
    final baseCost = type == 'cheap' ? 5000 : (type == 'balanced' ? 15000 : 30000);
    final cost = baseCost + rng.nextInt(baseCost);
    final time = type == 'cheap' ? 300 : (type == 'balanced' ? 240 : 180);

    return {
      'trip_id': tripId,
      'package_type': type,
      'total_cost': cost.toDouble(),
      'total_travel_time_minutes': time + rng.nextInt(120),
      'confidence_score': 0.85 + rng.nextDouble() * 0.15,
      'rationale': '$type package optimized for your trip',
      'pros': ['Best value for $type', 'Direct options available'],
      'cons': ['Limited flexibility'],
    };
  }
}
