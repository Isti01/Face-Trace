import 'dart:math' as math;

import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/match_card/draggable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class MatchCards extends StatefulWidget {
  final List<String> uids;
  final Map<String, User> users;
  final Function(bool right, String uid, int index) onSwiped;
  final bool loading;
  final AppColor appColor;

  const MatchCards({
    Key key,
    this.onSwiped,
    this.uids = const [],
    this.users,
    this.loading = false,
    this.appColor,
  }) : super(key: key);

  @override
  _MatchCardsState createState() => _MatchCardsState();
}

class _MatchCardsState extends State<MatchCards> {
  Map<String, GlobalKey<DraggableCardState>> _cardKeys = {};
  int index = 0;

  int get start =>
      widget.loading ? index + 2 : math.min(index + 2, widget.uids.length - 1);

  _createKeys() => widget.uids?.forEach((uid) => _cardKeys[uid] ??=
      GlobalKey<DraggableCardState>(debugLabel: 'match card $uid'));

  @override
  void initState() {
    _createKeys();
    super.initState();
  }

  @override
  void didUpdateWidget(MatchCards oldWidget) {
    _createKeys();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final bool notLast = index < (widget.uids?.length ?? 0) || widget.loading;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          _body(notLast, size),
          if (notLast)
            Positioned(bottom: 24, right: 0, left: 0, child: _buttons)
        ],
      ),
    );
  }

  Widget _body(bool notLast, Size size) => SingleChildScrollView(
        child: notLast
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: size.height / 12),
                child: Container(
                  height: size.shortestSide * 0.9,
                  width: size.shortestSide * 0.9,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (int i = start; i >= index; i--) _matchCard(i)
                    ],
                  ),
                ),
              )
            : _ranOut,
      );

  Widget get _ranOut => Center(
        child: Text(
          "Elfogyott",
          style: Theme.of(context).textTheme.display1,
          textAlign: TextAlign.center,
        ),
      );

  Widget _matchCard(int i) {
    final place = index - i;

    final uid = widget.loading ? null : widget.uids[i];
    return AbsorbPointer(
      key: widget.loading ? null : ValueKey(uid),
      absorbing: i != index,
      child: AnimatedContainer(
        transform: Matrix4.translationValues(-place * 10.0, place * 10.0, 0)
          ..scale(1 + place * 0.05),
        child: DraggableCard(
          key: widget.loading ? ValueKey('loading card $i') : _cardKeys[uid],
          user: widget.loading ? null : widget.users[uid],
          uid: uid,
          onSwiped: (right, uid) =>
              setState(() => widget.onSwiped(right, uid, index++)),
        ),
        duration: const Duration(milliseconds: 125),
      ),
    );
  }

  Widget get _buttons => ButtonBar(
        mainAxisSize: MainAxisSize.max,
        alignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircularGradientButton(
            child: Icon(Icons.close),
            gradient: LinearGradient(colors: widget.appColor.next.colors),
            callback: onSwipeButtonPressed(right: false),
          ),
          CircularGradientButton(
            child: Icon(Icons.favorite),
            gradient: LinearGradient(colors: widget.appColor.colors),
            callback: onSwipeButtonPressed(right: true),
          ),
        ],
      );

  onSwipeButtonPressed({bool right}) => () {
        final uid = widget.uids[index];
        if (widget.users[uid] == null) return;
        final key = _cardKeys[uid];
        if (index < widget.uids.length && key.currentContext != null)
          key.currentState.swipe(right);
      };
}
