import 'package:cafeysadmin/custom_views/app_link_label_view.dart';
import 'package:cafeysadmin/util/app_colors.dart';
import 'package:cafeysadmin/util/app_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppDatePickerView extends StatefulWidget {
  final String hintSelectDate;
  final String removeButtonText;
  DateTime? initialValue;
  final ValueChanged<DateTime?> onSelectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? dateWhenOpenDialog;

  AppDatePickerView({
    required this.hintSelectDate,
    required this.removeButtonText,
    required this.onSelectedDate,
    required this.firstDate,
    required this.lastDate,
    this.initialValue,
    this.dateWhenOpenDialog,
    Key? key,
  }) : super(key: key);

  @override
  State<AppDatePickerView> createState() => _AppDatePickerViewState();
}

class _AppDatePickerViewState extends State<AppDatePickerView> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    selectedDate = widget.initialValue;
    return Row(
      children: [
        Expanded(child: selectedDateText()),
        selectedDateButton(),
      ],
    );
  }

  Widget selectedDateText() {
    return AppLinkLabelView(
      selectedDateFormatted(),
      onClickSelectDate,
      size: 16,
      fontWeight: FontWeight.normal,
      color: (selectedDate != null) ? AppColors.black : AppColors.black.withOpacity(0.6),
      itemPosition: Alignment.centerLeft,
      underline: false,
    );
  }

  Widget selectedDateButton() {
    List<Widget> options = [];
    if (selectedDate != null) {
      options.add(
        IconButton(
          onPressed: onClickRemoveSelectedDate,
          tooltip: widget.removeButtonText,
          icon: const Icon(
            Icons.highlight_remove_sharp,
            color: AppColors.secondary,
          ),
        ),
      );
    }
    options.add(
      IconButton(
        onPressed: onClickSelectDate,
        tooltip: widget.hintSelectDate,
        icon: const Icon(
          CupertinoIcons.calendar,
          color: AppColors.primary,
        ),
      ),
    );
    return Row(children: options);
  }

  String selectedDateFormatted() {
    if (selectedDate == null) return widget.hintSelectDate;
    return AppFunctions.formatDate(selectedDate!);
  }

  void onClickSelectDate() async {
    DateTime? initialDate = selectedDate;
    if (initialDate != null) {
      var maxLastDate = widget.lastDate.add(const Duration(days: 1));
      var outOfTheRange = (initialDate.isBefore(widget.firstDate) || initialDate.isAfter(maxLastDate));
      if (outOfTheRange) initialDate = widget.lastDate;
    } else {
      initialDate ??= widget.dateWhenOpenDialog ?? widget.lastDate;
    }
    DateTime? result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (result != null) {
      widget.initialValue = result;
      widget.onSelectedDate(result);
      setState(() => selectedDate = result);
    }
  }

  void onClickRemoveSelectedDate() {
    widget.initialValue = null;
    widget.onSelectedDate(null);
    setState(() => selectedDate = null);
  }
}
