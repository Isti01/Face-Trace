import 'package:face_app/bloc/app_bloc_states.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:face_app/login/register_form/pages/interests_page.dart';
import 'package:flutter/material.dart';

class GenderPage extends StatefulWidget {
  final Gender initialGender;
  final Function(Gender gender) onGenderChanged;

  const GenderPage({
    Key key,
    this.initialGender,
    this.onGenderChanged,
  }) : super(key: key);

  @override
  _GenderPageState createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  Gender gender;

  @override
  void initState() {
    gender = widget.initialGender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: "Milyen nemű vagy?",
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runAlignment: WrapAlignment.spaceEvenly,
        children: [
          for (final gender in Gender.values)
            ChoiceWidget(
              text: genderToString(gender),
              selected: this.gender == gender,
              onSelected: (_) {
                setState(() => this.gender = gender);

                widget.onGenderChanged(gender);
              },
              padding: EdgeInsets.all(14),
              style: Theme.of(context).textTheme.title,
            ),
        ],
      ),
    );
  }
}
