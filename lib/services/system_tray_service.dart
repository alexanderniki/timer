import 'dart:io';
import 'dart:ui';
import '../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import '../models/timer_model.dart';
import '../providers/timer_provider.dart';
import '../providers/settings_provider.dart';

class SystemTrayService with WindowListener, TrayListener {
  final TimerProvider timerProvider;
  final SettingsProvider settingsProvider;

  bool _isInitialized = false;

  SystemTrayService(this.timerProvider, this.settingsProvider) {
    windowManager.addListener(this);
  }

  Future<void> init() async {
    if (_isInitialized) return;

    String iconPath = await _getIconPath();

    if (settingsProvider.settings.showTrayIcon) {
      await trayManager.setIcon(iconPath);

      try {
        final localizations = _getLocalizations();
        await trayManager.setToolTip(localizations.trayTooltip);
      } catch (e) {
        // Tooltip might not be supported on some platforms (e.g. Linux)
      }

      trayManager.addListener(this);

      // key change: mark initialized BEFORE updating menu
      _isInitialized = true;
      await updateMenu();
    } else {
      // if not showing icon, we are still "initialized" in the sense that the service is ready
      _isInitialized = true;
    }

    settingsProvider.addListener(_onSettingsChanged);
    await windowManager.setPreventClose(true);
  }

  Future<String> _getIconPath() async {
    if (Platform.isWindows) {
      return 'assets/app_icon.ico';
    } else if (Platform.isLinux) {
      // On Linux, use absolute path to ensure menu works
      final byteData = await rootBundle.load('assets/app_icon.png');
      final tempDir = await getTemporaryDirectory();
      final iconFile = File(path.join(tempDir.path, 'app_icon.png'));
      await iconFile.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
      );
      return iconFile.path;
    }
    return 'assets/app_icon.png';
  }

  void _onSettingsChanged() async {
    if (settingsProvider.settings.showTrayIcon) {
      String iconPath = await _getIconPath();

      await trayManager.setIcon(iconPath);
      final localizations = _getLocalizations();
      await trayManager.setToolTip(localizations.trayTooltip);
      trayManager.addListener(this);
      await updateMenu();
    } else {
      await trayManager.destroy();
      trayManager.removeListener(this);
    }
  }

  Future<void> updateMenu() async {
    if (!_isInitialized) return;

    final timers = timerProvider.timers;

    final localizations = _getLocalizations();

    List<MenuItem> items = [];

    if (timers.isNotEmpty) {
      for (var timer in timers) {
        String timeStr = ' (${_formatDuration(timer.remainingTime)})';
        String statusStr = '';
        if (timer.status == TimerStatus.paused) {
          statusStr = ' - ${localizations.trayPaused}';
        }

        String label = '${timer.label}$timeStr$statusStr';

        items.add(MenuItem(key: 'timer_${timer.id}', label: label));
      }
      items.add(MenuItem.separator());
    }

    items.add(MenuItem(key: 'show_app', label: localizations.trayShowApp));
    items.add(MenuItem(key: 'exit', label: localizations.trayExit));

    Menu menu = Menu(items: items);
    await trayManager.setContextMenu(menu);
  }

  AppLocalizations _getLocalizations() {
    final languageCode = settingsProvider.settings.languageCode;
    Locale locale;
    if (languageCode != null) {
      locale = Locale(languageCode);
    } else {
      // Fallback to system locale
      final systemLocaleParts = Platform.localeName.split('_');
      locale = Locale(systemLocaleParts[0]);
    }
    return lookupAppLocalizations(locale);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _toggleTimer(String id) {
    final timer = timerProvider.timers.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception("Timer not found"),
    );

    if (timer.status == TimerStatus.running) {
      timerProvider.pauseTimer(id);
    } else {
      timerProvider.startTimer(id);
    }
  }

  // TrayListener callbacks
  @override
  void onTrayIconMouseDown() {
    windowManager.show();
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {
    // Not needed
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    debugPrint('SystemTrayService: onTrayMenuItemClick key=${menuItem.key}');
    if (menuItem.key == 'show_app') {
      debugPrint('SystemTrayService: Showing app...');
      windowManager.show();
      windowManager.focus(); // Add focus
    } else if (menuItem.key == 'exit') {
      debugPrint('SystemTrayService: Exiting...');
      exit(0);
    } else if (menuItem.key?.startsWith('timer_') == true) {
      final timerId = menuItem.key!.replaceFirst('timer_', '');
      _toggleTimer(timerId);
    }
  }

  // WindowListener callbacks
  @override
  void onWindowClose() {
    if (settingsProvider.settings.minimizeToTray) {
      bool isIconVisible = settingsProvider.settings.showTrayIcon;
      if (isIconVisible) {
        windowManager.hide();
      } else {
        exit(0);
      }
    } else {
      exit(0);
    }
  }

  void dispose() {
    windowManager.removeListener(this);
    trayManager.removeListener(this);
    settingsProvider.removeListener(_onSettingsChanged);
  }
}
