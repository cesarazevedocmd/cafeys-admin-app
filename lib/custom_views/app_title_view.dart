import 'package:flutter/material.dart';

class AppTitleView extends StatelessWidget {
  final String text;
  final bool bold;
  final bool italic;
  final Color? color;
  final int? maxLines;
  final double textSize;
  final TextAlign align;

  const AppTitleView({
    required this.text,
    this.color,
    this.bold = true,
    this.italic = false,
    this.align = TextAlign.start,
    this.maxLines,
    this.textSize = 18,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: align,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
