import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../utils/responsive_utils.dart';
import '../widgets/timer_card.dart';
import '../widgets/timer_dialog.dart';
import '../l10n/app_localizations.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final horizontalPadding = context.horizontalPadding;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.timersTitle,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: isDesktop ? 24 : 20,
          ),
        ),
        centerTitle: true,
        toolbarHeight: isDesktop ? 72 : 56,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          SizedBox(width: horizontalPadding / 2),
        ],
      ),
      body: Consumer<TimerProvider>(
        builder: (context, provider, child) {
          if (provider.timers.isEmpty) {
            return Center(
              child: Text(
                l10n.noTimersActive,
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 1,
                  fontSize: isDesktop ? 18 : 14,
                ),
              ),
            );
          }

          // Use grid layout for tablet and desktop
          if (isTablet || isDesktop) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final columns = context.gridColumns;
                final spacing = isDesktop ? 20.0 : 16.0;

                return GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: isDesktop ? 1.5 : 1.2,
                  ),
                  itemCount: provider.timers.length,
                  itemBuilder: (context, index) {
                    return TimerCard(timer: provider.timers[index]);
                  },
                );
              },
            );
          }

          // List view for mobile
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.timers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TimerCard(timer: provider.timers[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => TimerDialog.showCreate(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
