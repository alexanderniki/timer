import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/timer_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';

import 'package:window_manager/window_manager.dart';
import 'services/system_tray_service.dart';
import 'l10n/app_localizations.dart';

late SystemTrayService systemTrayService;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final timerProvider = TimerProvider();
  final settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  systemTrayService = SystemTrayService(timerProvider, settingsProvider);

  // Set up listener for menu updates
  timerProvider.addListener(() {
    systemTrayService.updateMenu();
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: timerProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
      ],
      child: const TimerApp(),
    ),
  );
}

class TimerApp extends StatefulWidget {
  const TimerApp({super.key});

  @override
  State<TimerApp> createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  @override
  void initState() {
    super.initState();
    // Initialize tray after first frame to avoid blocking startup
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await windowManager.show();
      await windowManager.focus();
      // Initialize tray after window is shown
      await systemTrayService.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'Antigravity Timer',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          locale: settingsProvider.settings.languageCode != null
              ? Locale(settingsProvider.settings.languageCode!)
              : null,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Exo2',
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Exo2',
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              color: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}
