import 'dart:math' as math;

import 'package:face_app/home/match_card/draggable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class MatchCard extends StatefulWidget {
  final List<String> users;
  final Function(bool right, String uid) onSwiped;

  const MatchCard({Key key, this.onSwiped, this.users}) : super(key: key);

  @override
  _MatchCardState createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  List<GlobalKey<DraggableCardState>> _cardStates;
  int index = 0;

  @override
  void initState() {
    _cardStates = widget.users
        .map(
          (uid) => GlobalKey<DraggableCardState>(debugLabel: 'match card $uid'),
        )
        .toList();
    super.initState();
  }

  int get start => math.min(index + 2, widget.users.length - 1);

  @override
  Widget build(BuildContext context) {
    print(start);
    return SafeArea(
      child: Column(
        children: [
          Spacer(),
          Flexible(
              flex: 5,
              child: Stack(
                children: <Widget>[
                  for (int i = start; i >= index; i--)
                    AbsorbPointer(
                      key: ValueKey(widget.users[i]),
                      absorbing: i != index,
                      child: AnimatedContainer(
                        transform:
                            Matrix4.translationValues(0, (index - i) * 10.0, 0)
                              ..scale(1 + (index - i) * 0.05),
                        child: DraggableCard(
                          key: _cardStates[i],
                          uid: widget.users[i],
                          onSwiped: (right, uid) => setState(() {
                            index++;
                            widget.onSwiped(right, uid);
                          }),
                        ),
                        duration: const Duration(milliseconds: 125),
                      ),
                    ),
                ],
              )),
          Spacer(),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularGradientButton(
                child: Icon(Icons.close),
                gradient: LinearGradient(colors: [
                  Colors.purple,
                  Colors.deepPurple,
                ]),
                callback: () {
                  if (_cardStates[index].currentContext != null)
                    _cardStates[index].currentState.swipe(false);
                },
              ),
              CircularGradientButton(
                child: Icon(Icons.favorite),
                callback: () {
                  if (_cardStates[index].currentContext != null)
                    _cardStates[index].currentState.swipe(true);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
