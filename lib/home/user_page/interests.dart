import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:flutter/material.dart';

class Interests extends StatefulWidget {
  final List<Interest> interests;
  final AppColor color;

  final Function(bool select) onSelected;
  const Interests({
    Key key,
    this.interests,
    this.color,
    this.onSelected,
  }) : super(key: key);
  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  bool editing = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = editing
        ? Interest.values
            .map((interest) => InterestChip(
                  interest: interest,
                  selectable: true,
                  selected: widget.interests.contains(interest),
                  appColor: widget.color,
                  onSelected: widget.onSelected,
                ))
            .toList()
        : widget.interests
            .map((interest) =>
                InterestChip(interest: interest, appColor: widget.color))
            .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(width: 36),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runAlignment: WrapAlignment.spaceEvenly,
            spacing: 12,
            children: children,
          ),
        ),
        IconButton(
          icon: Text(editing ? '👍' : '✏', style: TextStyle(fontSize: 16)),
          tooltip: editing ? 'Mentés' : 'Szerkesztés',
          onPressed: editing
              ? () => setState(() => editing = false)
              : () => setState(() => editing = true),
        ),
      ],
    );
  }
}

class InterestChip extends StatelessWidget {
  final Interest interest;
  final bool selectable;
  final bool selected;
  final AppColor appColor;
  final Function(bool selected) onSelected;

  const InterestChip({
    Key key,
    this.interest,
    this.selectable = false,
    this.selected,
    this.onSelected,
    this.appColor,
  }) : super(key: key);

  Widget _label(context) => Text(
        interest.text,
        style: Theme.of(context).textTheme.subhead,
      );

  @override
  Widget build(BuildContext context) {
    if (selectable)
      return ChoiceChip(
        label: _label(context),
        selected: selected,
        onSelected: onSelected,
      );

    return Chip(label: _label(context));
  }
}
