import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/image_preview.dart';
import 'package:flutter/material.dart';

class UserImage extends StatefulWidget {
  final User user;
  final String heroTag;

  const UserImage({Key key, this.user, this.heroTag}) : super(key: key);

  @override
  _UserImageState createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  String get defaultTag =>
      (widget.user.profileImage ?? widget.user.uid) + 'matchUserImage';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.shortestSide * 0.8 / 2;
    final imageUrl = widget.user?.profileImage;
    final hasImage = imageUrl != null;
    final tag = widget.heroTag ?? defaultTag;

    return Center(
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: hasImage
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: true,
                    builder: (c) => ImagePreview(imageUrl: imageUrl, tag: tag),
                  ))
              : null,
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: ClipRRect(
              borderRadius: AppBorderRadius,
              child: imageUrl != null
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
