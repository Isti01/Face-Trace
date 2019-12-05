import 'dart:io';

import 'package:face_app/bloc/app_bloc_states.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class ChooseFace extends StatefulWidget {
  final Face initialFace;
  final List<Face> faces;
  final Function(Face face) onFaceChosen;
  final String faceImagePath;
  final Future<void> Function() onFinished;
  final AppColor color;

  const ChooseFace({
    Key key,
    this.initialFace,
    this.faces,
    this.onFaceChosen,
    this.faceImagePath,
    this.onFinished,
    this.color,
  }) : super(key: key);

  @override
  _ChooseFaceState createState() => _ChooseFaceState();
}

class _ChooseFaceState extends State<ChooseFace> {
  Face selectedFace;
  bool loading = false;

  @override
  void initState() {
    selectedFace = widget.initialFace;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final color = appColorToColor(widget.color)[800];
    final size = MediaQuery.of(context).size.shortestSide * .6;
    return FormPage(
      title: "Hol vagy a képen?",
      child: SizedBox(
        height: size,
        width: size,
        child: FittedBox(
          child: GestureDetector(
            onTapDown: onTapDown,
            child: CustomPaint(
              child: Image.file(File(widget.faceImagePath)),
              foregroundPainter: BoundingBoxPainter(
                faces: widget.faces,
                selectedFace: selectedFace,
              ),
            ),
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                ),
              Text('Kijelöltem magam!'),
            ],
          ),
          onPressed: selectedFace != null ? onSubmit : null,
          color: Colors.white,
          textColor: color,
        ),
      ),
    );
  }

  onSubmit() {
    try {
      setState(() => loading = true);
      widget.onFinished();
    } catch (e, s) {
      print([e, s]);
      setState(() => loading = false);
    }
  }

  onTapDown(TapDownDetails det) {
    for (Face face in widget.faces)
      if (face.boundingBox.contains(det.localPosition)) {
        setState(() => selectedFace = face);
        widget.onFaceChosen(face);
        break;
      }
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<Face> faces;
  final Face selectedFace;

  final background = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  final unselected = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8;

  final selected = Paint()
    ..color = Colors.green
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8;

  BoundingBoxPainter({this.faces, this.selectedFace});

  @override
  void paint(Canvas canvas, Size size) {
    for (Face face in faces) {
      canvas.drawRect(face.boundingBox, background);
      canvas.drawRect(face.boundingBox, unselected);
    }
    if (selectedFace != null) {
      canvas.drawRect(selectedFace.boundingBox, background);
      canvas.drawRect(selectedFace.boundingBox, selected);
    }
  }

  @override
  bool shouldRepaint(old) => !(old is BoundingBoxPainter &&
      old.selectedFace == selectedFace &&
      old.faces == faces);
}
