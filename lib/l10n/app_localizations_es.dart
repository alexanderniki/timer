// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'AJUSTES';

  @override
  String get systemTraySection => 'Bandeja del Sistema';

  @override
  String get showTrayIcon => 'Mostrar icono en bandeja';

  @override
  String get showTrayIconSubtitle =>
      'Mostrar un icono en la bandeja del sistema';

  @override
  String get minimizeToTray => 'Minimizar a la bandeja';

  @override
  String get minimizeToTraySubtitle =>
      'Minimizar ventana a la bandeja al cerrar';

  @override
  String get languageSection => 'Idioma';

  @override
  String get language => 'Idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get timersTitle => 'TEMPORIZADORES';

  @override
  String get noTimersActive => 'NO HAY TEMPORIZADORES ACTIVOS';

  @override
  String get pleaseSetDuration => 'POR FAVOR ESTABLEZCA UNA DURACIÓN';

  @override
  String get defaultTimerLabel => 'TEMPORIZADOR';

  @override
  String get editTimerTitle => 'EDITAR TEMPORIZADOR';

  @override
  String get newTimerTitle => 'NUEVO TEMPORIZADOR';

  @override
  String get nameLabel => 'NOMBRE';

  @override
  String get nameHint => 'Trabajo, Ejercicio, Huevos...';

  @override
  String get durationLabel => 'DURACIÓN';

  @override
  String get hoursLabel => 'H';

  @override
  String get minutesLabel => 'M';

  @override
  String get secondsLabel => 'S';

  @override
  String get shellCommandLabel => 'COMANDO DE SHELL (OPCIONAL)';

  @override
  String get shellCommandHint => 'ej. notify-send \"Temporizador terminado\"';

  @override
  String get soundLabel => 'SONIDO';

  @override
  String get defaultSound => 'Predeterminado';

  @override
  String get saveChanges => 'GUARDAR CAMBIOS';

  @override
  String get createTimer => 'CREAR TEMPORIZADOR';

  @override
  String get deleteTimer => 'ELIMINAR TEMPORIZADOR';

  @override
  String get trayShowApp => 'Mostrar Aplicación';

  @override
  String get trayExit => 'Salir';

  @override
  String get trayPaused => 'Pausado';

  @override
  String get trayTooltip => 'Antigravity Temporizador';

  @override
  String get none => 'Ninguno';
}
