import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String imageUrl;
  final String tag;
  const ImagePreview({Key key, this.imageUrl, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Stack(children: [
            Positioned.fill(
              child: AbsorbPointer(
                absorbing: true,
                child: Center(
                  child: Hero(
                    tag: tag ?? imageUrl,
                    child: SizedBox(
                      child: ClipRRect(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Material(
                type: MaterialType.transparency,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
