import 'dart:io';

import 'package:face_app/bloc/app_bloc_states.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/download_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePage extends StatefulWidget {
  final String initialPhoto;
  final Function(String photoPath) onPhotoChanged;
  final String photoFilePath;
  final AppColor color;

  const ProfileImagePage({
    Key key,
    this.initialPhoto,
    this.onPhotoChanged,
    this.photoFilePath,
    this.color,
  }) : super(key: key);

  @override
  _ProfileImagePageState createState() => _ProfileImagePageState();
}

class _ProfileImagePageState extends State<ProfileImagePage> {
  Future<String> pathFuture;
  Key imageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    pathFuture = widget.photoFilePath != null
        ? Future.value(widget.photoFilePath)
        : downloadImage(widget.initialPhoto, widget.onPhotoChanged);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.4;

    return FormPage(
      title: "Hogy nézel ki?",
      description: "Válassz ki egy képet, amin rajta vagy!",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Center(
              child: ProfileImage(
                key: imageKey,
                pathFuture: pathFuture,
              ),
            ),
          ),
          SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              RaisedButton.icon(
                icon: Icon(Icons.image),
                label: Text("Válassz egy képet!"),
                textColor: appColorToColor(widget.color)[800],
                color: Colors.white,
                onPressed: () => pickImage(ImageSource.gallery),
              ),
              RaisedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text("Készíts egy képet!"),
                textColor: appColorToColor(widget.color)[800],
                color: Colors.white,
                onPressed: () => pickImage(ImageSource.camera),
              ),
            ],
          )
        ],
      ),
    );
  }

  pickImage(ImageSource source) async {
    final image = await ImagePicker.pickImage(source: source);
    setState(() {
      pathFuture = Future.value(image.path);
      imageKey = UniqueKey();
    });

    if (image != null && await image.exists())
      widget.onPhotoChanged(image.path);
  }
}

class ProfileImage extends StatelessWidget {
  final pathFuture;

  const ProfileImage({Key key, this.pathFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pathFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return CircularProgressIndicator();

        if (snapshot.hasData) {
          return Image.file(
            File(snapshot.data),
            fit: BoxFit.contain,
          );
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppBorderRadius,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Adj meg egy képet magadról",
                style: Theme.of(context).textTheme.subtitle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
