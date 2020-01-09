import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/image_preview.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  final User user;

  const UserImage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.shortestSide * 0.8 / 2;
    final imageUrl = user?.profileImage;
    final hasImage = imageUrl != null;
    final tag = (user.profileImage ?? user.uid) + 'matchUserImage';
    return Center(
      child: Hero(
        tag: tag,
        child: GestureDetector(
          onTap: hasImage
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => ImagePreview(imageUrl: imageUrl, tag: tag),
                  ))
              : null,
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: ClipRRect(
              borderRadius: AppBorderRadius,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    )
                  : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
