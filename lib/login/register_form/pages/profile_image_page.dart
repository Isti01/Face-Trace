import 'dart:io';

import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePage extends StatefulWidget {
  final Function(String photoPath) onPhotoChanged;
  final String photoFilePath;
  final AppColor color;

  const ProfileImagePage({
    Key key,
    this.onPhotoChanged,
    this.photoFilePath,
    this.color,
  }) : super(key: key);

  @override
  _ProfileImagePageState createState() => _ProfileImagePageState();
}

class _ProfileImagePageState extends State<ProfileImagePage> {
  String path;
  Key imageKey = UniqueKey();

  @override
  void initState() {
    path = widget.photoFilePath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final size = MediaQuery.of(context).size.shortestSide * 0.4;

    return FormPage(
      title: localizations.imageQuestion,
      description: localizations.imageHint,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: Center(
              child: ProfileImage(
                key: imageKey,
                path: path,
                pickImage: () => pickImage(ImageSource.gallery),
              ),
            ),
          ),
          SizedBox(height: 32),
          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            children: [
              RaisedButton.icon(
                icon: Icon(Icons.image),
                label: Text(localizations.existingImage),
                textColor: widget.color.color[800],
                color: Colors.white,
                onPressed: () => pickImage(ImageSource.gallery),
              ),
              RaisedButton.icon(
                icon: Icon(Icons.camera_alt),
                label: Text(localizations.newImage),
                textColor: widget.color.color[800],
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
    if (image == null) return;

    setState(() {
      path = image.path;
      imageKey = UniqueKey();
    });

    if (await image.exists()) widget.onPhotoChanged(image.path);
  }
}

class ProfileImage extends StatelessWidget {
  final path;
  final VoidCallback pickImage;
  const ProfileImage({Key key, this.path, this.pickImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    if (path != null)
      return Image.file(
        File(path),
        fit: BoxFit.contain,
      );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Material(
        child: InkWell(
          borderRadius: AppBorderRadius,
          onTap: pickImage,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                localizations.imageHint,
                style: Theme.of(context).textTheme.subtitle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
