import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/user_bloc/user_bloc.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/home/match_page/card_button.dart';
import 'package:face_app/home/match_page/card_image.dart';
import 'package:face_app/home/match_page/loading_card.dart';
import 'package:face_app/home/match_page/user_page/user_page.dart';
import 'package:face_app/util/animated_transform.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DraggableCard extends StatefulWidget {
  final String uid;
  final User user;
  final Function(bool right, String uid) onSwiped;

  const DraggableCard({
    Key key,
    this.user,
    this.onSwiped,
    this.uid,
  }) : super(key: key);

  @override
  DraggableCardState createState() => DraggableCardState();
}

class DraggableCardState extends State<DraggableCard> {
  double offset = 0;
  double lastDelta = 0;
  bool swinging = false;

  get _duration => swinging
      ? Duration(milliseconds: 21)
      : offset == 0 ? Duration(milliseconds: 125) : Duration(milliseconds: 250);

  _onStart(det) => setState(() {
        lastDelta = 0;
        offset = 0;
        swinging = true;
      });

  _onUpdate(DragUpdateDetails det) => setState(() {
        lastDelta = -det.delta.dx;
        offset = offset + lastDelta;
      });

  _onEnd(_) => setState(() {
        final size = MediaQuery.of(context).size.width;
        final requiredOffset = size / 1.5;

        swinging = false;

        if (lastDelta.abs() > 3) {
          swipe(lastDelta.isNegative);
          return;
        }
        if (offset.abs() > requiredOffset) {
          swipe(offset.isNegative);
          return;
        }
        offset = 0;
      });

  swipe(bool right) => setState(() {
        final size = MediaQuery.of(context).size.width;
        offset = (right ? -1 : 1) * 1.5 * size;
        swinging = false;
        Future.delayed(_duration, () => widget.onSwiped(right, widget.uid));
      });

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUser.of(context).user;
    if (widget.user == null) return LoadingCard(currentUser: currentUser);

    final size = MediaQuery.of(context).size;

    return AnimatedTransform(
      transform: Matrix4.identity()
        ..translate(-offset)
        ..rotateZ(offset / 2500),
      origin: Alignment.topCenter,
      child: Padding(
        child: Material(
          borderRadius: AppBorderRadius,
          elevation: 4,
          child: ClipRRect(
            borderRadius: AppBorderRadius,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    final bloc = BlocProvider.of<UserBloc>(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        maintainState: true,
                        builder: (c) => CurrentUser.passOverUser(
                          bloc: bloc,
                          child: UserPage(
                            user: widget.user,
                            swipe: widget.onSwiped,
                          ),
                        ),
                      ),
                    );
                  },
                  onHorizontalDragStart: _onStart,
                  onHorizontalDragUpdate: _onUpdate,
                  onHorizontalDragEnd: _onEnd,
                  child: CardImage(user: widget.user),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  top: size.shortestSide * 0.8 - 44,
                  child: CardButtons(
                    uid: widget.user.uid,
                    swipe: swipe,
                    color: currentUser.appColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        padding: PagePadding,
      ),
      duration: _duration,
    );
  }
}
