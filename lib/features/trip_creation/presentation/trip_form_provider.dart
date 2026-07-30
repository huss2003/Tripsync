import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Trip form state — mirrors the trips table columns.
class TripFormState {
  final String source;
  final String destination;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final String purpose;
  final String meetingAddress;
  final int travellerCount;
  final String budget;
  final bool isSubmitting;
  final String? error;

  const TripFormState({
    this.source = '',
    this.destination = '',
    this.departureDate,
    this.returnDate,
    this.purpose = '',
    this.meetingAddress = '',
    this.travellerCount = 1,
    this.budget = '',
    this.isSubmitting = false,
    this.error,
  });

  bool get isValid =>
      source.isNotEmpty &&
      destination.isNotEmpty &&
      source != destination &&
      departureDate != null &&
      travellerCount >= 1;

  TripFormState copyWith({
    String? source,
    String? destination,
    DateTime? departureDate,
    DateTime? returnDate,
    String? purpose,
    String? meetingAddress,
    int? travellerCount,
    String? budget,
    bool? isSubmitting,
    String? error,
  }) =>
      TripFormState(
        source: source ?? this.source,
        destination: destination ?? this.destination,
        departureDate: departureDate ?? this.departureDate,
        returnDate: returnDate ?? this.returnDate,
        purpose: purpose ?? this.purpose,
        meetingAddress: meetingAddress ?? this.meetingAddress,
        travellerCount: travellerCount ?? this.travellerCount,
        budget: budget ?? this.budget,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: error,
      );
}

class TripFormNotifier extends StateNotifier<TripFormState> {
  TripFormNotifier() : super(const TripFormState());

  void setSource(String v) => state = state.copyWith(source: v, error: null);
  void setDestination(String v) => state = state.copyWith(destination: v, error: null);
  void setDepartureDate(DateTime? v) => state = state.copyWith(departureDate: v, error: null);
  void setReturnDate(DateTime? v) => state = state.copyWith(returnDate: v, error: null);
  void setPurpose(String v) => state = state.copyWith(purpose: v);
  void setMeetingAddress(String v) => state = state.copyWith(meetingAddress: v);
  void setTravellerCount(int v) => state = state.copyWith(travellerCount: v.clamp(1, 20));
  void setBudget(String v) => state = state.copyWith(budget: v);

  Future<void> submit() async {
    if (!state.isValid) return;
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      // POST /trips via Supabase — handled by the caller.
      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }
}

final tripFormProvider = StateNotifierProvider<TripFormNotifier, TripFormState>(
    (_) => TripFormNotifier());
