import 'dart:math';

import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/match_page/card_description.dart';
import 'package:face_app/home/match_page/loading_card.dart';
import 'package:face_app/home/match_page/user_page/user_page.dart';
import 'package:face_app/util/animated_transform.dart';
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
    final loading = widget.user == null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (c) => UserPage()),
        ),
        onHorizontalDragEnd: loading ? null : _onEnd,
        onHorizontalDragStart: loading ? null : _onStart,
        onHorizontalDragUpdate: loading ? null : _onUpdate,
        child: loading ? LoadingCard() : _body(),
      ),
    );
  }

  Widget _body() {
    final borderRadius = BorderRadius.circular(25);

    return AnimatedTransform(
      transform: Matrix4.translationValues(-offset, 0, 0)
        ..rotateZ(offset / (250 * pi)),
      origin: Alignment.topCenter,
      child: Material(
        borderRadius: borderRadius,
        elevation: 4,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImageWithRetry(widget.user.profileImage),
                ),
              ),
              CardDescription(user: widget.user),
            ],
          ),
        ),
      ),
      duration: _duration,
    );
  }
}
