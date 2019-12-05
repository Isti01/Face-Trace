import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';

const OpacityDuration = Duration(milliseconds: 125);

class PageSwitcher extends StatelessWidget {
  final onUp;
  final onDown;
  final numPages;
  final pageIndex;

  const PageSwitcher({
    Key key,
    this.onUp,
    this.onDown,
    this.numPages,
    this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showLastSwitcher = pageIndex.round() != numPages - 1;
    bool showFirstSwitcher = pageIndex.round() != 0;

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: showFirstSwitcher ? 1 : 0,
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_up,
                  size: 40,
                  color: AppTextColor.withAlpha(75),
                ),
                onPressed: showFirstSwitcher ? onUp : null,
              ),
              duration: OpacityDuration,
            ),
            AnimatedOpacity(
              opacity: showLastSwitcher ? 1 : 0,
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 40,
                  color: AppTextColor.withAlpha(150),
                ),
                onPressed: showLastSwitcher ? onDown : null,
              ),
              duration: OpacityDuration,
            ),
          ],
        ),
      ),
    );
  }
}
