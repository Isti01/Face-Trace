import 'dart:math' as math;

import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/match_bloc_states.dart';
import 'package:face_app/home/match_page/draggable_card.dart';
import 'package:face_app/home/match_page/match_card.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/gradient_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MatchCardStack extends StatefulWidget {
  final MatchState state;
  final Function(bool right, String uid, int index) onSwiped;
  const MatchCardStack({Key key, this.onSwiped, this.state}) : super(key: key);

  @override
  _MatchCardStackState createState() => _MatchCardStackState();
}

class _MatchCardStackState extends State<MatchCardStack> {
  Map<String, GlobalKey<DraggableCardState>> _cardKeys = {};
  int index = 0;

  List<String> get uids => widget.state.uidList;
  bool get loading => widget.state.loadingUserList;
  int get start => loading
      ? index + 2
      : math.min(index + 2, widget.state.uidList.length - 1);

  String getUid(i) => loading ? null : uids[i];

  _createKeys() => widget.state.uidList?.forEach((uid) => _cardKeys[uid] ??=
      GlobalKey<DraggableCardState>(debugLabel: 'match card $uid'));

  @override
  void initState() {
    index = math.min(widget.state.lastIndex, widget.state.uidList?.length ?? 0);
    _createKeys();
    super.initState();
  }

  @override
  void didUpdateWidget(MatchCardStack oldWidget) {
    _createKeys();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final bool last = index >= (uids?.length ?? 0) && !loading;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          SingleChildScrollView(child: _body(last, size)),
          if (!last) Positioned(bottom: 24, right: 0, left: 0, child: _buttons)
        ],
      ),
    );
  }

  Widget _body(bool last, Size size) {
    if (last) return _ranOut;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height / 12),
      child: Container(
        height: size.shortestSide * 0.9,
        width: size.shortestSide * 0.9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = start; i >= index; i--)
              MatchCard(
                pageIndex: i,
                currentIndex: index,
                uid: getUid(i),
                cardKey: _cardKeys[getUid(i)],
                loading: loading,
                user: widget.state.users[getUid(i)],
                onSwiped: (right, uid) => setState(
                  () => widget.onSwiped(right, uid, index++),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget get _ranOut => Center(
        child: Text(
          "Elfogyott",
          style: Theme.of(context).textTheme.display1,
          textAlign: TextAlign.center,
        ),
      );

  Widget get _buttons {
    final color = CurrentUser.of(context).user.appColor;
    return ButtonBar(
      mainAxisSize: MainAxisSize.max,
      alignment: MainAxisAlignment.spaceEvenly,
      children: [
        GradientRaisedButton.circle(
          child: Text('💩', style: TextStyle(fontSize: 24)),
          gradient: LinearGradient(colors: color.next.colors),
          onTap: onSwipeButtonPressed(right: false),
        ),
        GradientRaisedButton.circle(
          child: Text('😍', style: TextStyle(fontSize: 24)),
          gradient: LinearGradient(colors: color.colors),
          onTap: onSwipeButtonPressed(right: true),
        ),
      ],
    );
  }

  onSwipeButtonPressed({bool right}) => () {
        final uid = uids[index];
        if (widget.state.users[uid] == null) return;
        final key = _cardKeys[uid];
        if (index < uids.length && key.currentContext != null)
          key.currentState.swipe(right);
      };
}
