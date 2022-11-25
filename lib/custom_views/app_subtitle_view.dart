import 'package:flutter/material.dart';

class AppSubtitleView extends StatelessWidget {
  final String text;
  final bool bold;
  final bool italic;
  final Color? color;
  final int? maxLines;
  final TextAlign align;

  const AppSubtitleView({
    required this.text,
    this.color,
    this.bold = false,
    this.italic = false,
    this.maxLines,
    this.align = TextAlign.start,
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
        fontSize: 14,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
