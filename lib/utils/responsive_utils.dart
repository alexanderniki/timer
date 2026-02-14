import 'package:flutter/material.dart';

/// Breakpoints for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Device type enum for responsive layouts
enum DeviceType { mobile, tablet, desktop }

/// Utility class for responsive design
class ResponsiveUtils {
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < Breakpoints.mobile) {
      return DeviceType.mobile;
    } else if (width < Breakpoints.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  /// Get screen width
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Get screen height
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Returns the number of grid columns based on screen width
  static int getGridColumns(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 1;
      case DeviceType.tablet:
        return 2;
      case DeviceType.desktop:
        return 3;
    }
  }

  /// Scales a value based on screen width (base is 375px - iPhone SE width)
  static double scaleWidth(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 375;
    // Clamp scale factor to avoid extreme sizes
    return value * scaleFactor.clamp(0.8, 1.5);
  }

  /// Returns padding based on device type
  static EdgeInsets getScreenPadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(16);
      case DeviceType.tablet:
        return const EdgeInsets.all(24);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(horizontal: 48, vertical: 24);
    }
  }

  /// Returns horizontal padding that constrains content width on large screens
  static double getHorizontalPadding(BuildContext context) {
    final width = screenWidth(context);
    if (width > Breakpoints.desktop) {
      // Center content with max width on very large screens
      return (width - Breakpoints.desktop) / 2 + 48;
    }
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 32;
      case DeviceType.desktop:
        return 48;
    }
  }
}

/// Extension on BuildContext for easy responsive access
extension ResponsiveContext on BuildContext {
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);
  bool get isMobile => ResponsiveUtils.isMobile(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  double get screenWidth => ResponsiveUtils.screenWidth(this);
  double get screenHeight => ResponsiveUtils.screenHeight(this);
  int get gridColumns => ResponsiveUtils.getGridColumns(this);
  EdgeInsets get screenPadding => ResponsiveUtils.getScreenPadding(this);
  double get horizontalPadding => ResponsiveUtils.getHorizontalPadding(this);
}
