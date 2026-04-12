import 'package:flutter/material.dart';

/// Thin compatibility adapter so old FlutterFlow-style imports keep compiling
/// without reintroducing generated runtime dependencies.
class FlutterFlowTheme {
  FlutterFlowTheme._(this._theme);

  final ThemeData _theme;

  static FlutterFlowTheme of(BuildContext context) =>
      FlutterFlowTheme._(Theme.of(context));

  Color get primary => _theme.colorScheme.primary;
  Color get primaryText => _theme.colorScheme.onSurface;
  Color get secondaryText => _theme.colorScheme.onSurfaceVariant;
  Color get primaryBackground => _theme.scaffoldBackgroundColor;
  Color get secondaryBackground => _theme.colorScheme.surface;
  Color get error => _theme.colorScheme.error;
  Color get txHintTf => _theme.hintColor;
  Color get btnDAcBg => _theme.disabledColor.withValues(alpha: 0.2);
  Color get btnDAcTx => _theme.disabledColor;
  Color get referBox => _theme.colorScheme.primaryContainer;
  Color get iconDd => _theme.colorScheme.onSurfaceVariant;

  TextStyle get headlineLarge =>
      _theme.textTheme.headlineLarge ?? const TextStyle(fontSize: 32);
  TextStyle get headlineSmall =>
      _theme.textTheme.headlineSmall ?? const TextStyle(fontSize: 24);
  TextStyle get titleLarge =>
      _theme.textTheme.titleLarge ?? const TextStyle(fontSize: 22);
  TextStyle get titleMedium =>
      _theme.textTheme.titleMedium ?? const TextStyle(fontSize: 18);
  TextStyle get bodyMedium =>
      _theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
  TextStyle get bodySmall =>
      _theme.textTheme.bodySmall ?? const TextStyle(fontSize: 12);
  TextStyle get labelMedium =>
      _theme.textTheme.labelMedium ?? const TextStyle(fontSize: 12);
  TextStyle get labelSmall =>
      _theme.textTheme.labelSmall ?? const TextStyle(fontSize: 11);
}

extension FlutterFlowTextStyleCompat on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? lineHeight,
  }) {
    return copyWith(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: lineHeight,
    );
  }
}
