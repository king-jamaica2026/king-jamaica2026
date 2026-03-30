import 'package:flutter/material.dart';

class ScreenUtil {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMaxWidth;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static T responsiveValue<T>(
      BuildContext context, {
        required T mobile,
        T? tablet,
        T? desktop,
      }) {
    if (isDesktop(context) && desktop != null) return desktop;
    if (isTablet(context) && tablet != null) return tablet;
    return mobile;
  }
}

extension ResponsiveExtension on BuildContext {
  bool get isMobile => ScreenUtil.isMobile(this);
  bool get isTablet => ScreenUtil.isTablet(this);
  bool get isDesktop => ScreenUtil.isDesktop(this);
  double get screenWidth => ScreenUtil.width(this);
  double get screenHeight => ScreenUtil.height(this);

  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) =>
      ScreenUtil.responsiveValue(
        this,
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      );
}