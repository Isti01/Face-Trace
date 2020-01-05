import 'dart:ui';

import 'package:flutter/material.dart';

class TransparentAppBar extends StatelessWidget {
  final Widget title;
  final Widget leading;
  final Widget trailing;
  final Color color;

  const TransparentAppBar({
    Key key,
    this.title,
    this.leading,
    this.color = Colors.transparent,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Material(
          color: color,
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: kToolbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (leading != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: leading,
                    ),
                  if (title != null) Expanded(child: title),
                  if (trailing != null) trailing,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
