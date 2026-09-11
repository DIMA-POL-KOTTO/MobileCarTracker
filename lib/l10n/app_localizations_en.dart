// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home_page => 'Home';

  @override
  String get fuel_page => 'Refill';

  @override
  String get maintenance_page => 'Maintenance';

  @override
  String get more_page => 'More';

  @override
  String get update_btn => 'Update';

  @override
  String get current_mileage => 'Current mileage';

  @override
  String get add_fuel_page => 'Add refill';

  @override
  String get fuel_page_photo_btn_h => 'Take a photo of the receipt';

  @override
  String get fuel_page_photo_btn_p =>
      'The data will be recognized automatically';

  @override
  String get fuel_page_manual_btn_h => 'Enter manually';

  @override
  String get fuel_page_manual_btn_p => 'Manually enter refueling details';
}
