import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @home_page.
  ///
  /// In ru, this message translates to:
  /// **'Главная'**
  String get home_page;

  /// No description provided for @fuel_page.
  ///
  /// In ru, this message translates to:
  /// **'Заправки'**
  String get fuel_page;

  /// No description provided for @maintenance_page.
  ///
  /// In ru, this message translates to:
  /// **'ТО'**
  String get maintenance_page;

  /// No description provided for @more_page.
  ///
  /// In ru, this message translates to:
  /// **'Ещё'**
  String get more_page;

  /// No description provided for @update_btn.
  ///
  /// In ru, this message translates to:
  /// **'Обновить'**
  String get update_btn;

  /// No description provided for @current_mileage.
  ///
  /// In ru, this message translates to:
  /// **'Текущий пробег'**
  String get current_mileage;

  /// No description provided for @year_point.
  ///
  /// In ru, this message translates to:
  /// **'г.'**
  String get year_point;

  /// No description provided for @km.
  ///
  /// In ru, this message translates to:
  /// **'км'**
  String get km;

  /// No description provided for @mi.
  ///
  /// In ru, this message translates to:
  /// **'миль'**
  String get mi;

  /// No description provided for @settings.
  ///
  /// In ru, this message translates to:
  /// **'Настройки'**
  String get settings;

  /// No description provided for @add_fuel_page.
  ///
  /// In ru, this message translates to:
  /// **'Добавить заправку'**
  String get add_fuel_page;

  /// No description provided for @fuel_page_photo_btn_h.
  ///
  /// In ru, this message translates to:
  /// **'Сфотографировать чек'**
  String get fuel_page_photo_btn_h;

  /// No description provided for @fuel_page_photo_btn_p.
  ///
  /// In ru, this message translates to:
  /// **'Данные будут распознаны автоматически'**
  String get fuel_page_photo_btn_p;

  /// No description provided for @fuel_page_manual_btn_h.
  ///
  /// In ru, this message translates to:
  /// **'Ввести вручную'**
  String get fuel_page_manual_btn_h;

  /// No description provided for @fuel_page_manual_btn_p.
  ///
  /// In ru, this message translates to:
  /// **'Самостоятельно указать данные заправки'**
  String get fuel_page_manual_btn_p;

  /// No description provided for @language.
  ///
  /// In ru, this message translates to:
  /// **'Язык'**
  String get language;

  /// No description provided for @russian_lang.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get russian_lang;

  /// No description provided for @english_lang.
  ///
  /// In ru, this message translates to:
  /// **'Английский'**
  String get english_lang;

  /// No description provided for @theme.
  ///
  /// In ru, this message translates to:
  /// **'Тема'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In ru, this message translates to:
  /// **'Светлая'**
  String get light;

  /// No description provided for @notifications.
  ///
  /// In ru, this message translates to:
  /// **'Уведомления'**
  String get notifications;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
