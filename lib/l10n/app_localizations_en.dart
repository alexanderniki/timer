// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get systemTraySection => 'System Tray';

  @override
  String get showTrayIcon => 'Show Tray Icon';

  @override
  String get showTrayIconSubtitle => 'Display an icon in the system tray';

  @override
  String get minimizeToTray => 'Minimize to Tray';

  @override
  String get minimizeToTraySubtitle =>
      'Minimize window to system tray when closed';

  @override
  String get languageSection => 'Language';

  @override
  String get language => 'Language';

  @override
  String get systemDefault => 'System Default';

  @override
  String get timersTitle => 'TIMERS';

  @override
  String get noTimersActive => 'NO TIMERS ACTIVE';

  @override
  String get pleaseSetDuration => 'PLEASE SET A DURATION';

  @override
  String get defaultTimerLabel => 'TIMER';

  @override
  String get editTimerTitle => 'EDIT TIMER';

  @override
  String get newTimerTitle => 'NEW TIMER';

  @override
  String get nameLabel => 'NAME';

  @override
  String get nameHint => 'Work, Workout, Eggs...';

  @override
  String get durationLabel => 'DURATION';

  @override
  String get hoursLabel => 'H';

  @override
  String get minutesLabel => 'M';

  @override
  String get secondsLabel => 'S';

  @override
  String get shellCommandLabel => 'SHELL COMMAND (OPTIONAL)';

  @override
  String get shellCommandHint => 'e.g. notify-send \"Timer done\"';

  @override
  String get soundLabel => 'SOUND';

  @override
  String get defaultSound => 'Default';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get createTimer => 'CREATE TIMER';

  @override
  String get deleteTimer => 'DELETE TIMER';

  @override
  String get trayShowApp => 'Show App';

  @override
  String get trayExit => 'Exit';

  @override
  String get trayPaused => 'Paused';

  @override
  String get trayTooltip => 'Antigravity Timer';

  @override
  String get none => 'None';
}
