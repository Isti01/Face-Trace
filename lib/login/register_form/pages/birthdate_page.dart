import 'package:face_app/bloc/register_bloc/register_bloc_states.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final firstDate = DateTime.fromMillisecondsSinceEpoch(0);

class BirthDatePage extends StatefulWidget {
  final Function(DateTime date) onDateChanged;
  final DateTime startDate;

  const BirthDatePage({
    Key key,
    this.onDateChanged,
    this.startDate,
  }) : super(key: key);

  @override
  _BirthDatePageState createState() => _BirthDatePageState();
}

class _BirthDatePageState extends State<BirthDatePage> {
  final lastDate = legalDate;
  DateTime selectedDate;

  @override
  void initState() {
    selectedDate = widget.startDate ?? lastDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final cupertinoTheme = CupertinoTheme.of(context);
    final textTheme = cupertinoTheme.textTheme;
    return FormPage(
      title: "Mikor születtél?",
      child: SizedBox(
        height: size.height * 0.4,
        child: CupertinoTheme(
          data: cupertinoTheme.copyWith(
            textTheme: textTheme.copyWith(
              dateTimePickerTextStyle: textTheme.dateTimePickerTextStyle.apply(
                color: Colors.white,
              ),
            ),
          ),
          child: CupertinoDatePicker(
            initialDateTime: selectedDate,
            maximumYear: lastDate.year,
            maximumDate: lastDate,
            backgroundColor: Colors.transparent,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: widget.onDateChanged,
          ),
        ),
      ),
    );
  }
}
