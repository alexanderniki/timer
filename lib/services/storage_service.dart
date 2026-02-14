import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/timer_model.dart';
import '../models/settings_model.dart';

class StorageService {
  static const String _fileName = 'timers.json';
  static const String _settingsFileName = 'settings.json';

  Future<String> get _localPath async {
    // Use ./share/config/ directory
    final currentDir = Directory.current;
    final configPath = '${currentDir.path}/share/config';

    // Create directory if it doesn't exist
    final configDir = Directory(configPath);
    if (!await configDir.exists()) {
      await configDir.create(recursive: true);
      debugPrint('StorageService: Created config directory: $configPath');
    }

    return configPath;
  }

  /// Migrate old config files from root directory to share/config/
  Future<void> _migrateOldFiles() async {
    try {
      final currentDir = Directory.current;
      final oldTimersFile = File('${currentDir.path}/$_fileName');
      final oldSettingsFile = File('${currentDir.path}/$_settingsFileName');

      // Migrate timers.json
      if (await oldTimersFile.exists()) {
        final newFile = await _localFile;
        if (!await newFile.exists()) {
          await oldTimersFile.copy(newFile.path);
          await oldTimersFile.delete();
          debugPrint('StorageService: Migrated $_fileName to ${newFile.path}');
        }
      }

      // Migrate settings.json
      if (await oldSettingsFile.exists()) {
        final newFile = await _localSettingsFile;
        if (!await newFile.exists()) {
          await oldSettingsFile.copy(newFile.path);
          await oldSettingsFile.delete();
          debugPrint(
            'StorageService: Migrated $_settingsFileName to ${newFile.path}',
          );
        }
      }
    } catch (e) {
      debugPrint('StorageService: Migration error: $e');
    }
  }

  Future<File> get _localFile async {
    await _migrateOldFiles();
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<File> get _localSettingsFile async {
    await _migrateOldFiles();
    final path = await _localPath;
    return File('$path/$_settingsFileName');
  }

  Future<List<TimerModel>> loadTimers() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }

      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => TimerModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading timers: $e');
      return [];
    }
  }

  Future<void> saveTimers(List<TimerModel> timers) async {
    try {
      final file = await _localFile;
      final jsonList = timers.map((timer) => timer.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      debugPrint('Error saving timers: $e');
    }
  }

  Future<SettingsModel> loadSettings() async {
    try {
      final file = await _localSettingsFile;
      if (!await file.exists()) {
        return SettingsModel();
      }

      final contents = await file.readAsString();
      final Map<String, dynamic> jsonMap = json.decode(contents);
      return SettingsModel.fromJson(jsonMap);
    } catch (e) {
      debugPrint('Error loading settings: $e');
      return SettingsModel();
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    try {
      final file = await _localSettingsFile;
      await file.writeAsString(json.encode(settings.toJson()));
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}
