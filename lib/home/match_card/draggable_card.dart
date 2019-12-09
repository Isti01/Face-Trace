import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/home/match_card/card_description.dart';
import 'package:face_app/util/animated_transform.dart';
import 'package:face_app/util/firestore_queries.dart';
import 'package:flutter/material.dart';

class DraggableCard extends StatefulWidget {
  final uid;
  final Function(bool right, String uid) onSwiped;

  const DraggableCard({
    Key key,
    this.uid,
    this.onSwiped,
  }) : super(key: key);

  @override
  DraggableCardState createState() => DraggableCardState();
}

class DraggableCardState extends State<DraggableCard> {
  double offset = 0;
  double lastDelta = 0;
  bool swinging = false;
  Future<DocumentSnapshot> future;

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
  void initState() {
    future = firestore.collection('users').document(widget.uid).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final data = (snapshot.data as DocumentSnapshot).data;
          final borderRadius = BorderRadius.circular(25);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: GestureDetector(
              onPanEnd: _onEnd,
              onPanStart: _onStart,
              onPanUpdate: _onUpdate,
              child: AnimatedTransform(
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
                          child: Image.network(
                            data['profileImage'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        CardDescription(data: data),
                      ],
                    ),
                  ),
                ),
                duration: _duration,
              ),
            ),
          );
        });
  }
}
