import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/home/match_page/card_description.dart';
import 'package:face_app/home/match_page/loading_card.dart';
import 'package:face_app/home/match_page/user_page/user_page.dart';
import 'package:face_app/util/animated_transform.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/gradient_raised_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';

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
    if (widget.user == null)
      return LoadingCard(currentUser: CurrentUser.of(context).user);

    final size = MediaQuery.of(context).size;
    final transform = -offset / 2500;

    return AnimatedTransform(
      transform: Matrix4.skewX(transform)
        ..translate(-offset)
        ..rotateZ(transform),
      origin: Alignment.topCenter,
      child: Padding(
        child: Material(
          borderRadius: AppBorderRadius,
          elevation: 4,
          child: ClipRRect(
            borderRadius: AppBorderRadius,
            child: Stack(
              children: [
                AbsorbPointer(
                  absorbing: widget.user == null,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => UserPage()),
                    ),
                    onHorizontalDragStart: _onStart,
                    onHorizontalDragUpdate: _onUpdate,
                    onHorizontalDragEnd: _onEnd,
                    child: buildImage(size),
                  ),
                ),
                if (widget.user != null)
                  Positioned(
                    right: 0,
                    left: 0,
                    top: size.shortestSide * 0.9 - 44,
                    child: _buttons,
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

  Column buildImage(Size size) {
    // todo create separate widget for this
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: size.shortestSide * 0.9,
          width: size.shortestSide * 0.9,
          child: widget.user == null
              ? LoadingCard.loadingEmoji(widget.user.gender.emoji)
              : Image(
                  loadingBuilder: (context, child, e) => e == null
                      ? child
                      : LoadingCard.loadingEmoji(widget.user.gender.emoji),
                  fit: BoxFit.cover,
                  image: NetworkImageWithRetry(widget.user.profileImage),
                ),
        ),
        SizedBox(height: 20),
        CardDescription(user: widget.user),
      ],
    );
  }

  Widget get _buttons {
    final AppColor color = CurrentUser.of(context).user.appColor;
    return ButtonBar(
      mainAxisSize: MainAxisSize.max,
      alignment: MainAxisAlignment.spaceEvenly,
      children: [
        GradientRaisedButton.circle(
          child: Text('💩', style: TextStyle(fontSize: 24)),
          gradient: LinearGradient(colors: color.next.colors),
          onTap: () => swipe(false),
        ),
        GradientRaisedButton.circle(
          child: Text('😍', style: TextStyle(fontSize: 24)),
          gradient: LinearGradient(colors: color.colors),
          onTap: () => swipe(true),
        ),
      ],
    );
  }
}
