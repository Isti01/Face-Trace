import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/match_page/draggable_card.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String uid;
  final bool loading;
  final int pageIndex;
  final int currentIndex;
  final Key cardKey;
  final User user;
  final Function(bool right, String uid) onSwiped;

  const MatchCard({
    Key key,
    this.uid,
    this.loading,
    this.pageIndex,
    this.currentIndex,
    this.cardKey,
    this.onSwiped,
    this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final place = currentIndex - pageIndex;
    return AbsorbPointer(
      key: loading ? null : ValueKey(uid),
      absorbing: place != 0,
      child: AnimatedContainer(
        transform: Matrix4.translationValues(-place * 10.0, place * 10.0, 0)
          ..scale(1 + place * 0.05),
        child: DraggableCard(
          key: loading ? ValueKey('loading card $pageIndex') : cardKey,
          user: loading ? null : user,
          uid: uid,
          onSwiped: onSwiped,
        ),
        duration: const Duration(milliseconds: 125),
      ),
    );
  }
}
