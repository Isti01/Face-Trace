import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:flutter/material.dart';

class InterestsPage extends StatefulWidget {
  final pageNum;
  final numPages;
  final List<Interest> choices;
  final Set<Interest> initialSelected;
  final Function(Interest interest) onInterestAdded;
  final Function(Interest interest) onInterestRemoved;

  const InterestsPage({
    Key key,
    this.pageNum,
    this.numPages,
    this.choices,
    this.initialSelected,
    this.onInterestAdded,
    this.onInterestRemoved,
  }) : super(key: key);

  @override
  _InterestsPageState createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  Set<Interest> selected;

  @override
  void initState() {
    selected = widget.initialSelected ?? {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return FormPage(
      title:
          "${localizations.interestsQuestion} ${widget.pageNum}/${widget.numPages}",
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          runAlignment: WrapAlignment.spaceEvenly,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            for (Interest interest in widget.choices)
              ChoiceWidget(
                text: interest.text(context),
                selected: selected.contains(interest),
                onSelected: (val) {
                  if (val) {
                    selected.add(interest);
                    widget.onInterestAdded(interest);
                  } else {
                    selected.remove(interest);
                    widget.onInterestRemoved(interest);
                  }
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ChoiceWidget extends StatelessWidget {
  final String text;
  final Function(bool val) onSelected;
  final bool selected;
  final padding;
  final style;

  const ChoiceWidget({
    Key key,
    this.text,
    this.onSelected,
    this.selected,
    this.padding = const EdgeInsets.all(12),
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FilterChip(
        avatar: SizedBox(),
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        padding: padding,
        label: Text(
          text,
          style: style ?? Theme.of(context).textTheme.subhead,
        ),
        backgroundColor: Colors.white12,
        selectedColor: Colors.white38,
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}
