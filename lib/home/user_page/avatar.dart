import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_app/bloc/firebase/upload_image.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Avatar extends StatelessWidget {
  final profileImage;
  final Color color;
  final Function(String path) onImageChanged;

  const Avatar({
    Key key,
    this.profileImage,
    this.color,
    this.onImageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profileImage == null) return SizedBox();
    final imageSize = MediaQuery.of(context).size.shortestSide * 0.45;

    return Stack(
      children: <Widget>[
        Material(
          elevation: 4,
          shape: CircleBorder(),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => ImagePreview(imageUrl: profileImage),
              ),
            ),
            child: Hero(
              tag: profileImage,
              child: SizedBox(
                height: imageSize,
                width: imageSize,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: CachedNetworkImage(
                    imageUrl: profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        ImageAction(
          imageSize: imageSize,
          color: color,
          onImageChanged: onImageChanged,
        )
      ],
    );
  }
}

class ImageAction extends StatelessWidget {
  final double imageSize;
  final Color color;
  final Function(String path) onImageChanged;

  const ImageAction({
    Key key,
    this.imageSize,
    this.color,
    this.onImageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offset = (1 + math.sqrt1_2) * imageSize / 2 - 28;
    return Positioned(
      left: offset,
      top: offset,
      child: PopupMenuButton<int>(
        offset: Offset(20, 20),
        child: Material(
          elevation: 2,
          type: MaterialType.circle,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '📷',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        onSelected: (i) => uploadNewImage(i, context),
        itemBuilder: (_) => [
          PopupMenuItem<int>(
            value: 0,
            child: Text('📷  Új kép készítése'),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text('🖼️  Meglévő kép kiválasztása'),
          ),
        ],
      ),
    );
  }

  void uploadNewImage(int i, context) async {
    final source = i == 0 ? ImageSource.camera : ImageSource.gallery;
    final image = await ImagePicker.pickImage(source: source);

    if (image == null || !await image.exists()) return;
    final user = CurrentUser.of(context).user.user;
    final url = await uploadPhoto(user, image.path, 'images/${user.uid}');

    onImageChanged(url);
  }
}
