import 'package:face_app/util/constants.dart';
import 'package:flutter/material.dart';

const double initialTranslation = -250;

const double bounce = 8;

showToast(
  BuildContext context, {
  String title,
  String message,
  Duration duration = const Duration(seconds: 3),
}) {
  bool removed = false;

  OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => ToastWidget(
        title: title,
        message: message,
        duration: duration,
        onDismissed: () {
          if (!removed) entry.remove();
          removed = true;
        }),
  );

  Overlay.of(context).insert(entry);

  Future.delayed(duration, () {
    if (!removed) entry.remove();
    removed = true;
  });
}

class ToastWidget extends StatefulWidget {
  final String title;
  final String message;
  final Duration duration;
  final onDismissed;

  const ToastWidget({
    Key key,
    this.title,
    this.message,
    this.duration,
    this.onDismissed,
  }) : super(key: key);

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  final key = UniqueKey();
  AnimationController controller;

  Animation<double> translateAnimation;
  Animation<double> bounceAnimation;
  Animation<double> reverseBounce;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );

    controller.addListener(() {
      if (mounted) this.setState(() {});
    });

    setTranslateAnimation();
    setBounceAnimations();

    controller.forward().whenComplete(controller.reverse);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Align(
      alignment: Alignment.topCenter,
      child: Transform.translate(
        child: Padding(
          padding: const EdgeInsets.all(8).add(
            EdgeInsets.only(top: topPadding),
          ),
          child: Dismissible(
            child: Material(
              color: Colors.white38,
//              elevation: 12,
              borderRadius: AppBorderRadius,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.title != null)
                      Text(widget.title,
                          style: Theme.of(context).textTheme.title),
                    if (widget.message != null)
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(widget.message),
                      ),
                  ],
                ),
              ),
            ),
            onDismissed: (direction) {
              widget.onDismissed();
            },
            key: key,
          ),
        ),
        offset: Offset(
          0,
          translateAnimation.value +
              bounceAnimation.value -
              reverseBounce.value,
        ),
      ),
    );
  }

  setTranslateAnimation() => translateAnimation = Tween<double>(
        begin: initialTranslation,
        end: 0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(0, 0.15, curve: Curves.easeOut),
        ),
      );

  setBounceAnimations() {
    final bounceTween = Tween<double>(begin: 0, end: bounce);
    bounceAnimation = bounceTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.15, 0.2, curve: Curves.ease),
      ),
    );
    reverseBounce = bounceTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.2, 0.25, curve: Curves.ease),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
