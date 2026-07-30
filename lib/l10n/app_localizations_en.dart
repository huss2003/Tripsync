// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'TripSync';

  @override
  String get splashResolving => 'Resolving...';

  @override
  String get phoneEntryTitle => 'Enter your phone number';

  @override
  String get phoneEntryHint => 'Phone number';

  @override
  String get phoneEntrySend => 'Send OTP';

  @override
  String get otpTitle => 'Enter the code sent to';

  @override
  String get otpResend => 'Resend';

  @override
  String get profileSetupTitle => 'Tell us your travel style';

  @override
  String get profileSetupSkip => 'Skip for now';

  @override
  String get profileSetupSave => 'Save & Continue';

  @override
  String get homeCreateTrip => 'Create Trip';

  @override
  String get homeRecentTrips => 'Recent Trips';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get createTripTitle => 'Plan your trip';

  @override
  String get createTripGenerate => 'Generate Packages';

  @override
  String get comparisonTitle => 'Compare Packages';

  @override
  String get refineWithAI => 'Refine with AI';

  @override
  String get selectPackage => 'Select this Package';

  @override
  String get itineraryTitle => 'Itinerary';

  @override
  String get addToCalendar => 'Add to Calendar';

  @override
  String get historyTitle => 'Trip History';

  @override
  String get noTripsYet => 'No trips yet';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get signOut => 'Sign Out';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get errorNoConnectivity => 'No internet connection';

  @override
  String get errorRetry => 'Retry';
}
