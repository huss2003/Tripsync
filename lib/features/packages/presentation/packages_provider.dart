import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/package_generator_service.dart';

/// A trip package as returned from the API.
class TripPackage {
  final String id;
  final String tripId;
  final String packageType;
  final double totalCost;
  final int totalTravelTimeMinutes;
  final double? confidenceScore;
  final String? rationale;
  final List<String> pros;
  final List<String> cons;

  TripPackage({
    required this.id,
    required this.tripId,
    required this.packageType,
    required this.totalCost,
    required this.totalTravelTimeMinutes,
    this.confidenceScore,
    this.rationale,
    this.pros = const [],
    this.cons = const [],
  });

  factory TripPackage.fromJson(Map<String, dynamic> json) => TripPackage(
    id: json['id'] as String,
    tripId: json['trip_id'] as String,
    packageType: json['package_type'] as String,
    totalCost: (json['total_cost'] as num).toDouble(),
    totalTravelTimeMinutes: json['total_travel_time_minutes'] as int,
    confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
    rationale: json['rationale'] as String?,
    pros: (json['pros'] as List?)?.cast<String>() ?? [],
    cons: (json['cons'] as List?)?.cast<String>() ?? [],
  );
}

final packageServiceProvider = Provider((_) => PackageGeneratorService());

final packagesStreamProvider = FutureProvider.family<List<TripPackage>, String>(
    (ref, tripId) async {
  final supabase = Supabase.instance.client;
  final data = await supabase
      .from('trip_packages')
      .select()
      .eq('trip_id', tripId)
      .order('created_at');
  return (data as List).map((e) => TripPackage.fromJson(e)).toList();
});
