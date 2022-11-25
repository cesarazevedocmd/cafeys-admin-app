import 'package:flutter/material.dart';

void pop(BuildContext context) {
  Navigator.pop(context);
}

Future push(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) {
        return page;
      },
    ),
  );
}
