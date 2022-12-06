import 'package:cafeysadmin/custom_views/app_title_view.dart';
import 'package:cafeysadmin/util/app_strings.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AppDropDownView<T> extends StatefulWidget {
  List<T> items = [];
  T? initialValue;
  String hint;
  ValueChanged<T> onSelectedItem;
  FormFieldValidator<T>? validator;

  AppDropDownView({
    required this.initialValue,
    required this.items,
    required this.hint,
    required this.onSelectedItem,
    this.validator,
  });

  @override
  _AppDropDownViewState createState() => _AppDropDownViewState<T>();
}

class _AppDropDownViewState<T> extends State<AppDropDownView<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: widget.items,
      selectedItem: widget.initialValue,
      itemAsString: (item) => item.toString(),
      onChanged: (T? itemClicked) {
        setState(() => widget.initialValue = itemClicked);
        if (itemClicked != null) widget.onSelectedItem(itemClicked);
      },
      dropdownDecoratorProps: buildInputDecoration(),
      validator: widget.validator,
      popupProps: PopupProps.modalBottomSheet(
        emptyBuilder: (context, entry) {
          return const AppTitleView(
            text: AppStrings.itemsNotFound,
            bold: false,
          );
        },
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 4),
      ),
    );
  }

  DropDownDecoratorProps buildInputDecoration() {
    return DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        hintText: widget.hint,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(width: .8),
        ),
      ),
    );
  }
}
