import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';

class Avatar extends StatelessWidget {
  final profileImage;
  final Color color;
  const Avatar({Key key, this.profileImage, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (profileImage == null) return SizedBox();
    final imageSize = MediaQuery.of(context).size.shortestSide * 0.45;

    return Stack(
      children: <Widget>[
        Material(
          elevation: 4,
          shape: CircleBorder(),
          child: Container(
            height: imageSize,
            width: imageSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImageWithRetry(profileImage),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        ImageBanner(imageSize: imageSize, color: color)
      ],
    );
  }
}

class ImageBanner extends StatelessWidget {
  final double imageSize;
  final Color color;
  const ImageBanner({Key key, this.imageSize, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offset = (1 + math.sqrt1_2) * imageSize / 2 - 28;
    return Positioned(
      left: offset,
      top: offset,
      child: Material(
        elevation: 2,
        type: MaterialType.circle,
        color: Colors.white,
        child: InkWell(
          highlightColor: Color.lerp(Colors.white, color, .2),
          splashColor: Color.lerp(Colors.white, color, .3),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(Icons.camera_alt, color: color),
          ),
          onTap: () {
            throw UnimplementedError();
          },
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
