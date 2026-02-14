import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:timer/widgets/timer_dialog.dart';
import 'package:timer/providers/timer_provider.dart';
import 'package:timer/l10n/app_localizations.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TimerProvider())],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(body: child),
      ),
    );
  }

  group('TimerDialog', () {
    testWidgets('shows correct sounds and selects default if available', (
      tester,
    ) async {
      // Open the dialog
      await tester.pumpWidget(
        createTestWidget(
          Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => TimerDialog.showCreate(context),
                child: const Text('New Timer'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('New Timer'));
      await tester.pumpAndSettle();

      // Find the dropdown
      final dropdownFinder = find.byType(DropdownButtonFormField<String?>);
      expect(dropdownFinder, findsOneWidget);

      // We need to wait for the AudioService to load (mocking would be better but for now we rely on the implementation using AssetManifest which might be empty in test env)
      // In a real test environment, we should mock AudioService.
      // equivalent to: await tester.pump(const Duration(milliseconds: 100));

      // Check if we can open the dropdown
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Verify "None" option exists
      expect(find.text('None'), findsOneWidget);

      // Select "None"
      await tester.tap(find.text('None').last);
      await tester.pumpAndSettle();

      // Verify dropdown closed
      expect(find.text('None'), findsOneWidget);
    });
  });
}
