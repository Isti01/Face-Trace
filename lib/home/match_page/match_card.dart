import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/match_page/draggable_card.dart';
import 'package:face_app/util/animated_transform.dart';
import 'package:flutter/material.dart';

const duration = const Duration(milliseconds: 125);

class MatchCard extends StatelessWidget {
  final String uid;
  final User user;
  final int place;
  final Function(bool right, String uid) onSwiped;

  const MatchCard({
    Key key,
    this.uid,
    this.onSwiped,
    this.user,
    this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTransform(
      origin: Alignment.bottomCenter,
      transform: Matrix4.translationValues(0, place * 10.0, 0)
        ..scale(1 - place * 0.05),
      duration: duration,
      child: AbsorbPointer(
        key: UniqueKey(),
        absorbing: place != 0,
        child: DraggableCard(
          user: user,
          uid: uid,
          onSwiped: onSwiped,
        ),
      ),
    );
  }
}
