import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/image_preview.dart';
import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  final List<String> images;
  final double imageSize;
  final double widthRatio;
  final bool canAddNew;
  final double startOffset;
  final VoidCallback addToGallery;

  const Gallery({
    Key key,
    this.images,
    this.imageSize = 120,
    this.widthRatio = 2,
    this.canAddNew = false,
    this.startOffset,
    this.addToGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = Size(imageSize * widthRatio, imageSize);
    final length = images.length;
    return SizedBox(
      height: size.height + 12,
      child: Center(
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverToBoxAdapter(child: SizedBox(width: startOffset)),
            if (canAddNew)
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                child: GalleryImage(
                  size: Size(imageSize, imageSize),
                  clickableIcon: true,
                  icon: Icons.add,
                  onTap: addToGallery,
                ),
              )),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: GalleryImage(size: size, url: images[length - i - 1]),
                ),
                childCount: length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GalleryImage extends StatelessWidget {
  final String url;
  final Size size;
  final bool clickableIcon;
  final IconData icon;
  final VoidCallback onTap;

  const GalleryImage({
    Key key,
    this.url,
    this.size,
    this.clickableIcon = false,
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tag = url + 'gallery';
    return Material(
      elevation: 2,
      borderRadius: AppBorderRadius,
      child: InkWell(
        borderRadius: AppBorderRadius,
        onTap: clickableIcon
            ? onTap
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => ImagePreview(imageUrl: url, tag: tag),
                )),
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(size),
          child: Hero(
            tag: tag,
            child: SizedBox(
              child: ClipRRect(
                borderRadius: AppBorderRadius,
                child: clickableIcon
                    ? Center(child: Icon(icon, size: 32))
                    : CachedNetworkImage(imageUrl: url, fit: BoxFit.contain),
                // make image clickable
              ),
            ),
          ),
        ),
      ),
    );
  }
}
