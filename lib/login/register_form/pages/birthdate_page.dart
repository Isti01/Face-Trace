import 'package:face_app/bloc/register_bloc_states.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
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
    return FormPage(
      title: "Mikor születtél?",
      child: MonthPicker(
        selectedDate: selectedDate,
        onChanged: (date) {
          selectedDate = date;
          widget.onDateChanged(date);
          this.setState(() {});
        },
        firstDate: firstDate,
        lastDate: lastDate,
      ),
    );
  }
}
