import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:face_app/login/register_form/pages/interests_page.dart';
import 'package:flutter/material.dart';

class AttractedToPage extends StatefulWidget {
  final List<Gender> initialGenders;
  final Function(List<Gender> genders) onGendersChanged;

  const AttractedToPage({
    Key key,
    this.initialGenders,
    this.onGendersChanged,
  }) : super(key: key);

  @override
  _AttractedToPageState createState() => _AttractedToPageState();
}

class _AttractedToPageState extends State<AttractedToPage> {
  List<Gender> genders;

  @override
  void initState() {
    genders = widget.initialGenders ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return FormPage(
      title: localizations.attractedToQuestion,
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runAlignment: WrapAlignment.spaceEvenly,
        children: [
          for (final gender in Gender.values)
            ChoiceWidget(
              text: gender.text(context),
              selected: this.genders.contains(gender),
              onSelected: (selected) {
                setState(
                  () => selected ? genders.add(gender) : genders.remove(gender),
                );
                widget.onGendersChanged(genders);
              },
              padding: EdgeInsets.all(14),
              style: Theme.of(context).textTheme.title,
            ),
        ],
      ),
    );
  }
}
