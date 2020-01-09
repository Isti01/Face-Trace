import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:flutter/material.dart';

class Interests extends StatefulWidget {
  final void Function(List<Interest> interests) onInterestsUpdated;
  final List<Interest> initialInterests;
  final AppColor color;

  const Interests({
    Key key,
    this.initialInterests,
    this.color,
    this.onInterestsUpdated,
  }) : super(key: key);
  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  bool editing = false;

  List<Interest> interests;

  @override
  void initState() {
    interests = widget.initialInterests;
    super.initState();
  }

  @override
  void didUpdateWidget(Interests oldWidget) {
    if (!editing) interests = widget.initialInterests;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = editing
        ? Interest.values
            .map((interest) => FaceAppChip(
                  interest: interest.text,
                  selectable: true,
                  selected: interests.contains(interest),
                  appColor: widget.color,
                  onSelected: (select) => setState(() => select
                      ? interests.add(interest)
                      : interests.remove(interest)),
                ))
            .toList()
        : interests
            .map((interest) =>
                FaceAppChip(interest: interest.text, appColor: widget.color))
            .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(width: 36),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runAlignment: WrapAlignment.spaceEvenly,
            spacing: 4,
            children: children,
          ),
        ),
        IconButton(
          icon: Text(editing ? '👍' : '✏', style: TextStyle(fontSize: 16)),
          tooltip: editing ? 'Mentés' : 'Szerkesztés',
          onPressed: editing
              ? () {
                  setState(() => editing = false);
                  widget.onInterestsUpdated(interests);
                }
              : () => setState(() => editing = true),
        ),
      ],
    );
  }
}

class FaceAppChip extends StatelessWidget {
  final String interest;
  final bool selectable;
  final bool selected;
  final AppColor appColor;
  final Function(bool selected) onSelected;
  final Color color;
  final TextTheme textTheme;

  static final int alpha = 44;

  FaceAppChip({
    Key key,
    this.interest,
    this.selectable = false,
    this.selected,
    this.onSelected,
    this.appColor,
    this.color,
    this.textTheme,
  }) : super(key: key);

  Widget _label(context) => Text(
        interest,
        style: (textTheme ?? Theme.of(context).textTheme)
            .subhead
            .apply(fontSizeFactor: 1.1),
      );

  final backgroundColor = Colors.grey.withAlpha(alpha);

  @override
  Widget build(BuildContext context) {
    final child = selectable
        ? ChoiceChip(
            label: _label(context),
            selected: selected,
            onSelected: onSelected,
            backgroundColor: color ?? backgroundColor,
            selectedColor: appColor.color.withAlpha(alpha),
          )
        : Chip(
            label: _label(context),
            backgroundColor: color ?? backgroundColor,
          );

    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: child,
    );
  }
}
