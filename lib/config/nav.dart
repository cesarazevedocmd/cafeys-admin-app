import 'package:flutter/material.dart';

void pop(BuildContext context, {dynamic result}) {
  if (result != null) {
    Navigator.pop(context, result = result);
  } else {
    Navigator.pop(context);
  }
}

Future push(BuildContext context, Widget page, {bool replace = false}) {
  if (replace) {
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
  return Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}
