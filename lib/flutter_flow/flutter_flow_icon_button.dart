import 'package:flutter/material.dart';

class FlutterFlowIconButton extends StatelessWidget {
  const FlutterFlowIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.buttonSize = 40,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.borderWidth,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final double buttonSize;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: borderWidth ?? 1),
      ),
      child: IconButton(onPressed: onPressed, icon: icon),
    );
  }
}
