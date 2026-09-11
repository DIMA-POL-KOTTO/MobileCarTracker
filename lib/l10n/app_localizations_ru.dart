// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get home_page => 'Главная';

  @override
  String get fuel_page => 'Заправки';

  @override
  String get maintenance_page => 'ТО';

  @override
  String get more_page => 'Ещё';

  @override
  String get update_btn => 'Обновить';

  @override
  String get current_mileage => 'Текущий пробег';

  @override
  String get add_fuel_page => 'Добавить заправку';

  @override
  String get fuel_page_photo_btn_h => 'Сфотографировать чек';

  @override
  String get fuel_page_photo_btn_p => 'Данные будут распознаны автоматически';

  @override
  String get fuel_page_manual_btn_h => 'Ввести вручную';

  @override
  String get fuel_page_manual_btn_p => 'Самостоятельно указать данные заправки';
}
