import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/util/gradient_raised_button.dart';
import 'package:flutter/material.dart';

class CardButtons extends StatelessWidget {
  final Function(bool right) swipe;
  final AppColor color;
  final String uid;
  const CardButtons({Key key, this.swipe, this.color, this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: uid + 'matchButtons',
      child: ButtonBar(
        mainAxisSize: MainAxisSize.max,
        alignment: MainAxisAlignment.spaceEvenly,
        children: [
          GradientRaisedButton.circle(
            child: Text('💩', style: TextStyle(fontSize: 24)),
            gradient: LinearGradient(colors: color.next.next.colors),
            onTap: () => swipe(false),
          ),
          GradientRaisedButton.circle(
            child: Text('😍', style: TextStyle(fontSize: 24)),
            gradient: LinearGradient(colors: color.next.colors),
            onTap: () => swipe(true),
          ),
        ],
      ),
    );
  }
}
