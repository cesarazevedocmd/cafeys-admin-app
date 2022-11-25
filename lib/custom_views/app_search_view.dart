import 'dart:async';
import 'dart:math';

import 'package:cafeysadmin/custom_views/app_text_field_view.dart';
import 'package:cafeysadmin/util/app_line.dart';
import 'package:cafeysadmin/util/app_space.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:cafeysadmin/util/app_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSearchView extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final Function clearClick;
  final Function okClick;

  AppSearchView({
    required this.hint,
    required this.controller,
    required this.clearClick,
    required this.okClick,
  }) : super(key: Key("${Random().nextDouble()}"));

  final _AppSearchViewState _search = _AppSearchViewState();

  @override
  _AppSearchViewState createState() => _search;

  void swapVisibility() => _search.swapVisibility();
}

class _AppSearchViewState extends State<AppSearchView> {
  bool visibility = false;
  final StreamController _stream = StreamController<bool>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: false,
      stream: _stream.stream,
      builder: (_, snapshot) {
        if (snapshot.data == true) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: AppTextFieldView(
                        controller: widget.controller,
                        hintText: widget.hint,
                        prefixIcon: const Icon(CupertinoIcons.search),
                        suffixIcon: IconButton(
                          onPressed: () => widget.clearClick(),
                          icon: const Icon(CupertinoIcons.clear),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppSpace.vertical(1),
              AppLine.horizontal(),
            ],
          );
        }
        widget.controller.text = AppStrings.empty;
        return AppWidget.empty();
      },
    );
  }

  void swapVisibility() {
    visibility = !visibility;
    _stream.sink.add(visibility);
  }

  @override
  void dispose() {
    super.dispose();
    _stream.close();
  }
}
