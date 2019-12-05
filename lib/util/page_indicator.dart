import 'package:flutter/material.dart';

class PageIndicator extends StatefulWidget {
  final PageController controller;
  final numPages;
  final Function(int page) jumpToPage;

  const PageIndicator({
    Key key,
    @required this.controller,
    @required this.numPages,
    this.jumpToPage,
  })  : assert(numPages != null),
        super(key: key);

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  Function() listener;

  @override
  void initState() {
    super.initState();
    listener = () {
      if (mounted) setState(() {});
    };
    widget.controller.addListener(listener);
  }

  double get page => widget.controller.hasClients ? widget.controller.page : 0;

  double getDist(int index) {
    final dist = ((page ?? 0) - index).abs();

    if (dist < 1)
      return 1 - dist;
    else
      return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            widget.numPages,
            (index) {
              final dist = getDist(index);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: dist == 0.0 ? () => widget.jumpToPage(index) : null,
                  child: Material(
                    shape: CircleBorder(side: BorderSide(color: Colors.white)),
                    color: Colors.white.withAlpha((255 * dist).toInt()),
                    child: SizedBox(
                      width: 10 + 5 * dist,
                      height: 10 + 5 * dist,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }
}
