import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.2.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    // Using FlexColorScheme built-in FlexScheme enum based colors
    scheme: FlexScheme.cyanM3,
    // Component theme configurations for light mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.instantSplash,
      textButtonRadius: 4.0,
      filledButtonRadius: 4.0,
      elevatedButtonRadius: 6.0,
      outlinedButtonRadius: 4.0,
      segmentedButtonRadius: 8.0,
      inputDecoratorIsFilled: true,
      inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 6.0,
      alignedDropdown: true,
      searchBarRadius: 8.0,
      searchViewRadius: 8.0,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  static ThemeData dark = FlexThemeData.dark(
    // Using FlexColorScheme built-in FlexScheme enum based colors.
    scheme: FlexScheme.cyanM3,
    // Component theme configurations for dark mode.
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      splashType: FlexSplashType.instantSplash,
      textButtonRadius: 4.0,
      filledButtonRadius: 4.0,
      elevatedButtonRadius: 6.0,
      outlinedButtonRadius: 4.0,
      segmentedButtonRadius: 8.0,
      inputDecoratorIsFilled: true,
      inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
      inputDecoratorBackgroundAlpha: 50,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorRadius: 6.0,
      alignedDropdown: true,
      searchBarRadius: 8.0,
      searchViewRadius: 8.0,
      navigationRailUseIndicator: true,
    ),
    // Direct ThemeData properties.
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
