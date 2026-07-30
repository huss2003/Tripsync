import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A trip summary for the history list.
class TripSummary {
  final String id;
  final String source, destination;
  final String? departureDate, returnDate;
  final String status;
  final String? packageType;
  final double? totalCost;
  TripSummary({
    required this.id, required this.source, required this.destination,
    this.departureDate, this.returnDate, required this.status,
    this.packageType, this.totalCost,
  });
  factory TripSummary.fromJson(Map<String, dynamic> j) => TripSummary(
    id: j['id'] as String,
    source: j['source'] as String,
    destination: j['destination'] as String,
    departureDate: j['departure_date'] as String?,
    returnDate: j['return_date'] as String?,
    status: j['status'] as String,
    packageType: j['package_type'] as String?,
    totalCost: (j['total_cost'] as num?)?.toDouble(),
  );
}

final historyProvider = FutureProvider<List<TripSummary>>((ref) async {
  final data = await Supabase.instance.client
      .from('trips')
      .select('id, source, destination, departure_date, return_date, status')
      .order('created_at', ascending: false);
  return (data as List).map((e) => TripSummary.fromJson(e)).toList();
});
