// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settingsTitle => 'НАСТРОЙКИ';

  @override
  String get systemTraySection => 'Системный трей';

  @override
  String get showTrayIcon => 'Показывать значок в трее';

  @override
  String get showTrayIconSubtitle => 'Отображать значок в системном трее';

  @override
  String get minimizeToTray => 'Сворачивать в трей';

  @override
  String get minimizeToTraySubtitle => 'Сворачивать окно в трей при закрытии';

  @override
  String get languageSection => 'Язык';

  @override
  String get language => 'Язык';

  @override
  String get systemDefault => 'По умолчанию';

  @override
  String get timersTitle => 'ТАЙМЕРЫ';

  @override
  String get noTimersActive => 'НЕТ АКТИВНЫХ ТАЙМЕРОВ';

  @override
  String get pleaseSetDuration => 'ПОЖАЛУЙСТА, УСТАНОВИТЕ ДЛИТЕЛЬНОСТЬ';

  @override
  String get defaultTimerLabel => 'ТАЙМЕР';

  @override
  String get editTimerTitle => 'РЕДАКТИРОВАТЬ ТАЙМЕР';

  @override
  String get newTimerTitle => 'НОВЫЙ ТАЙМЕР';

  @override
  String get nameLabel => 'НАЗВАНИЕ';

  @override
  String get nameHint => 'Работа, Тренировка, Яйца...';

  @override
  String get durationLabel => 'ДЛИТЕЛЬНОСТЬ';

  @override
  String get hoursLabel => 'Ч';

  @override
  String get minutesLabel => 'М';

  @override
  String get secondsLabel => 'С';

  @override
  String get shellCommandLabel => 'КОМАНДА ОБОЛОЧКИ (ОПЦИОНАЛЬНО)';

  @override
  String get shellCommandHint => 'напр. notify-send \"Таймер завершен\"';

  @override
  String get soundLabel => 'ЗВУК';

  @override
  String get defaultSound => 'По умолчанию';

  @override
  String get saveChanges => 'СОХРАНИТЬ';

  @override
  String get createTimer => 'СОЗДАТЬ ТАЙМЕР';

  @override
  String get deleteTimer => 'УДАЛИТЬ ТАЙМЕР';

  @override
  String get trayShowApp => 'Показать приложение';

  @override
  String get trayExit => 'Выход';

  @override
  String get trayPaused => 'Пауза';

  @override
  String get trayTooltip => 'Таймер Antigravity';

  @override
  String get none => 'Без звука';
}
