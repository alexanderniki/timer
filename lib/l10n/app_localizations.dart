import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
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
    Locale('es'),
    Locale('ru'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @systemTraySection.
  ///
  /// In en, this message translates to:
  /// **'System Tray'**
  String get systemTraySection;

  /// No description provided for @showTrayIcon.
  ///
  /// In en, this message translates to:
  /// **'Show Tray Icon'**
  String get showTrayIcon;

  /// No description provided for @showTrayIconSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display an icon in the system tray'**
  String get showTrayIconSubtitle;

  /// No description provided for @minimizeToTray.
  ///
  /// In en, this message translates to:
  /// **'Minimize to Tray'**
  String get minimizeToTray;

  /// No description provided for @minimizeToTraySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Minimize window to system tray when closed'**
  String get minimizeToTraySubtitle;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSection;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @timersTitle.
  ///
  /// In en, this message translates to:
  /// **'TIMERS'**
  String get timersTitle;

  /// No description provided for @noTimersActive.
  ///
  /// In en, this message translates to:
  /// **'NO TIMERS ACTIVE'**
  String get noTimersActive;

  /// No description provided for @pleaseSetDuration.
  ///
  /// In en, this message translates to:
  /// **'PLEASE SET A DURATION'**
  String get pleaseSetDuration;

  /// No description provided for @defaultTimerLabel.
  ///
  /// In en, this message translates to:
  /// **'TIMER'**
  String get defaultTimerLabel;

  /// No description provided for @editTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'EDIT TIMER'**
  String get editTimerTitle;

  /// No description provided for @newTimerTitle.
  ///
  /// In en, this message translates to:
  /// **'NEW TIMER'**
  String get newTimerTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Work, Workout, Eggs...'**
  String get nameHint;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get durationLabel;

  /// No description provided for @hoursLabel.
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get hoursLabel;

  /// No description provided for @minutesLabel.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get minutesLabel;

  /// No description provided for @secondsLabel.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get secondsLabel;

  /// No description provided for @shellCommandLabel.
  ///
  /// In en, this message translates to:
  /// **'SHELL COMMAND (OPTIONAL)'**
  String get shellCommandLabel;

  /// No description provided for @shellCommandHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. notify-send \"Timer done\"'**
  String get shellCommandHint;

  /// No description provided for @soundLabel.
  ///
  /// In en, this message translates to:
  /// **'SOUND'**
  String get soundLabel;

  /// No description provided for @defaultSound.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultSound;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @createTimer.
  ///
  /// In en, this message translates to:
  /// **'CREATE TIMER'**
  String get createTimer;

  /// No description provided for @deleteTimer.
  ///
  /// In en, this message translates to:
  /// **'DELETE TIMER'**
  String get deleteTimer;

  /// No description provided for @trayShowApp.
  ///
  /// In en, this message translates to:
  /// **'Show App'**
  String get trayShowApp;

  /// No description provided for @trayExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get trayExit;

  /// No description provided for @trayPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get trayPaused;

  /// No description provided for @trayTooltip.
  ///
  /// In en, this message translates to:
  /// **'Antigravity Timer'**
  String get trayTooltip;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;
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
      <String>['en', 'es', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
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
