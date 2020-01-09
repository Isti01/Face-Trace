import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/util/color_circle.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/gradient_raised_button.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Function(String color) onColorChanged;
  final AppColor color;

  const ColorPicker({
    Key key,
    this.onColorChanged,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: GradientRaisedButton(
        gradient: LinearGradient(
          colors: color.colors,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            "Alkalmazás színének változtatása",
            style: Theme.of(context).textTheme.button.apply(
                  color: Colors.white,
                ),
          ),
        ),
        onTap: () => showDialog(
          context: context,
          builder: (c) => ColorPickerDialog(onColorPicked: onColorChanged),
        ),
      ),
    );
  }
}

class ColorPickerDialog extends StatelessWidget {
  final Function(String color) onColorPicked;

  const ColorPickerDialog({Key key, this.onColorPicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: AppBorder,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Text('Válassz színt!', style: Theme.of(context).textTheme.title),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Wrap(
                runAlignment: WrapAlignment.spaceEvenly,
                alignment: WrapAlignment.spaceEvenly,
                spacing: 12,
                children: AppColor.values
                    .map((color) => GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onColorPicked(color.firestoreText);
                        },
                        child: SimpleColorCircle(color: color, size: 50)))
                    .toList(),
              ),
            ),
            ButtonBar(
              children: [
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Mégsem'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
