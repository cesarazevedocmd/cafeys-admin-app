import 'package:cafeysadmin/util/app_colors.dart';
import 'package:flutter/material.dart';

class AppLinkLabelView extends StatefulWidget {
  String label;
  Alignment itemPosition;
  double size;
  bool underline;
  FontWeight fontWeight;
  Function onClick;
  Color color;
  TextAlign textAlignment;

  AppLinkLabelView(
    this.label,
    this.onClick, {
    this.size = 16,
    this.itemPosition = Alignment.center,
    this.underline = true,
    this.fontWeight = FontWeight.normal,
    this.color = AppColors.black,
    this.textAlignment = TextAlign.center,
    Key? key,
  }) : super(key: key);

  @override
  _AppLinkLabelViewState createState() => _AppLinkLabelViewState();
}

class _AppLinkLabelViewState extends State<AppLinkLabelView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.itemPosition,
      child: GestureDetector(
        child: Text(widget.label, semanticsLabel: widget.label, style: getStyle()),
        onTap: () => widget.onClick(),
      ),
    );
  }

  TextStyle getStyle() {
    return widget.underline
        ? TextStyle(
            color: widget.color,
            decoration: TextDecoration.underline,
            fontSize: widget.size,
            fontWeight: widget.fontWeight,
          )
        : TextStyle(
            color: widget.color,
            fontSize: widget.size,
            fontWeight: widget.fontWeight,
          );
  }
}
