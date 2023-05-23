import 'package:flutter/material.dart';

class Text2 extends StatelessWidget {
  final String text;
  final double fontSize;
  final int maxLines;
  final bool isBold;
  const Text2({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.maxLines = 2,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Theme.of(context).primaryTextTheme.bodyText2?.color,
        fontWeight: isBold ? FontWeight.bold : null,
      ),
      maxLines: maxLines,
    );
  }
}
