import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../utils/responsive_utils.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;
    final maxSettingsWidth = isDesktop
        ? 800.0
        : (isTablet ? 700.0 : double.infinity);
    final sectionHeaderSize = isDesktop ? 20.0 : 16.0;
    final horizontalPadding = isDesktop ? 32.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settingsTitle,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: isDesktop ? 24 : 20,
          ),
        ),
        centerTitle: true,
        toolbarHeight: isDesktop ? 72 : 56,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          final l10n = AppLocalizations.of(context)!;
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxSettingsWidth),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: horizontalPadding,
                ),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              l10n.systemTraySection,
                              style: TextStyle(
                                fontSize: sectionHeaderSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildSwitchTile(
                            context,
                            title: l10n.showTrayIcon,
                            subtitle: l10n.showTrayIconSubtitle,
                            value: provider.settings.showTrayIcon,
                            onChanged: provider.toggleShowTrayIcon,
                          ),
                          _buildSwitchTile(
                            context,
                            title: l10n.minimizeToTray,
                            subtitle: l10n.minimizeToTraySubtitle,
                            value: provider.settings.minimizeToTray,
                            onChanged: provider.settings.showTrayIcon
                                ? provider.toggleMinimizeToTray
                                : null, // Disable if tray icon is hidden
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              l10n.languageSection,
                              style: TextStyle(
                                fontSize: sectionHeaderSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              l10n.language,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: DropdownButton<String?>(
                              value: provider.settings.languageCode,
                              underline: const SizedBox(),
                              onChanged: (String? newValue) {
                                provider.setLanguage(newValue);
                              },
                              items: [
                                DropdownMenuItem(
                                  value: null,
                                  child: Text(l10n.systemDefault),
                                ),
                                const DropdownMenuItem(
                                  value: 'en',
                                  child: Text('English'),
                                ),
                                const DropdownMenuItem(
                                  value: 'es',
                                  child: Text('Español'),
                                ),
                                const DropdownMenuItem(
                                  value: 'ru',
                                  child: Text('Русский'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeThumbColor: Theme.of(context).colorScheme.primary,
    );
  }
}
