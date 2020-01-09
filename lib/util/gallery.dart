import 'package:face_app/util/constants.dart';
import 'package:face_app/util/image_preview.dart';
import 'package:flutter/material.dart';

class Gallery extends StatefulWidget {
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
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    final Size size =
        Size(widget.imageSize * widget.widthRatio, widget.imageSize);
    final length = widget.images.length;
    return SizedBox(
      height: size.height + 12,
      child: Center(
        child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          slivers: [
            SliverToBoxAdapter(child: SizedBox(width: widget.startOffset)),
            if (widget.canAddNew)
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
                child: GalleryImage(
                  url: 'user profile add image',
                  size: Size(widget.imageSize, widget.imageSize),
                  clickableIcon: true,
                  icon: Icons.add,
                  onTap: widget.addToGallery,
                ),
              )),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: GalleryImage(
                      size: size, url: widget.images[length - i - 1]),
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
      key: ValueKey(tag),
      elevation: 2,
      borderRadius: AppBorderRadius,
      child: InkWell(
        borderRadius: AppBorderRadius,
        onTap: clickableIcon
            ? onTap
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                  maintainState: true,
                  builder: (c) => ImagePreview(imageUrl: url, tag: tag),
                )),
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(size),
          child: SizedBox(
            child: ClipRRect(
              borderRadius: AppBorderRadius,
              child: clickableIcon
                  ? Center(child: Icon(icon, size: 32))
                  : Image.network(url, fit: BoxFit.contain),
              // make image clickable
            ),
          ),
        ),
      ),
    );
  }
}
