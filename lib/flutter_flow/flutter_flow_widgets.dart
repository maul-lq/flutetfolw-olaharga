import 'package:flutter/material.dart';

class FFButtonOptions {
  const FFButtonOptions({
    this.height,
    this.padding,
    this.iconPadding,
    this.color,
    this.textStyle,
    this.elevation,
    this.borderSide,
    this.borderRadius,
    this.disabledColor,
    this.disabledTextColor,
  });

  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? iconPadding;
  final Color? color;
  final TextStyle? textStyle;
  final double? elevation;
  final BorderSide? borderSide;
  final double? borderRadius;
  final Color? disabledColor;
  final Color? disabledTextColor;
}

class FFButtonWidget extends StatelessWidget {
  const FFButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    required this.options,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String text;
  final FFButtonOptions options;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      minimumSize: Size(0, options.height ?? 40),
      padding: options.padding,
      backgroundColor: options.color,
      foregroundColor: options.textStyle?.color,
      textStyle: options.textStyle,
      elevation: options.elevation,
      disabledBackgroundColor: options.disabledColor,
      disabledForegroundColor: options.disabledTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(options.borderRadius ?? 12),
        side: options.borderSide ?? BorderSide.none,
      ),
    );

    final child = icon == null
        ? Text(text)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              SizedBox(width: (options.iconPadding as EdgeInsets?)?.left ?? 8),
              Text(text),
            ],
          );

    return FilledButton(onPressed: onPressed, style: style, child: child);
  }
}
