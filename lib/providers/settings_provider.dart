import 'package:flutter/foundation.dart';
import '../models/settings_model.dart';
import '../services/storage_service.dart';

class SettingsProvider with ChangeNotifier {
  SettingsModel _settings = SettingsModel();
  final StorageService _storageService = StorageService();

  SettingsModel get settings => _settings;

  SettingsProvider();

  Future<void> loadSettings() async {
    _settings = await _storageService.loadSettings();
    notifyListeners();
  }

  void toggleShowTrayIcon(bool value) {
    _settings.showTrayIcon = value;
    _save();
    notifyListeners();
  }

  void toggleMinimizeToTray(bool value) {
    _settings.minimizeToTray = value;
    _save();
    notifyListeners();
  }

  void setLanguage(String? languageCode) {
    _settings.languageCode = languageCode;
    _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await _storageService.saveSettings(_settings);
  }
}
