import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String label;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final int lineHeight;
  final int? maxLines;

  const AppText({required this.label, this.textColor = Colors.black, this.fontSize = 14, this.fontWeight = FontWeight.w400, this.lineHeight = 22, this.maxLines = 1, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: fontWeight, height: lineHeight / fontSize),
      textScaler: TextScaler.noScaling,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}
