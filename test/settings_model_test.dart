import 'package:flutter_test/flutter_test.dart';
import 'package:timer/models/settings_model.dart';

// Since we use a file-based StorageService, testing it directly in unit tests might be tricky without mocking path_provider.
// However, we can test the SettingsModel logic and simple provider logic if we mock the storage service or its dependencies.
// For now, let's just create a simple test to verify the model serialization.

void main() {
  group('SettingsModel', () {
    test('should have default values', () {
      final settings = SettingsModel();
      expect(settings.showTrayIcon, true);
      expect(settings.minimizeToTray, false);
    });

    test('should serialize to JSON', () {
      final settings = SettingsModel(showTrayIcon: false, minimizeToTray: true);
      final json = settings.toJson();
      expect(json['showTrayIcon'], false);
      expect(json['minimizeToTray'], true);
    });

    test('should deserialize from JSON', () {
      final json = {'showTrayIcon': false, 'minimizeToTray': true};
      final settings = SettingsModel.fromJson(json);
      expect(settings.showTrayIcon, false);
      expect(settings.minimizeToTray, true);
    });
  });
}
