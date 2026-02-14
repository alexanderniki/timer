class SettingsModel {
  bool showTrayIcon;
  bool minimizeToTray;
  String? languageCode;

  SettingsModel({
    this.showTrayIcon = true,
    this.minimizeToTray = false,
    this.languageCode,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      showTrayIcon: json['showTrayIcon'] as bool? ?? true,
      minimizeToTray: json['minimizeToTray'] as bool? ?? false,
      languageCode: json['languageCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showTrayIcon': showTrayIcon,
      'minimizeToTray': minimizeToTray,
      'languageCode': languageCode,
    };
  }
}
