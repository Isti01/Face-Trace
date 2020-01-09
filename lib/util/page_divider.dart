import 'package:flutter/material.dart';

class PageDivider extends StatelessWidget {
  final TextStyle style;
  final String text;
  final bool addPadding;
  final Color color;

  const PageDivider({
    Key key,
    this.style,
    this.text,
    this.addPadding = true,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 12),
      Divider(color: color),
      if (text != null) ...[
        Padding(
          padding: addPadding
              ? const EdgeInsets.symmetric(horizontal: 44)
              : EdgeInsets.zero,
          child: SizedBox(
            width: double.infinity,
            child: Text(text, textAlign: TextAlign.start, style: style),
          ),
        ),
        SizedBox(height: 4),
      ],
      SizedBox(height: 4),
    ]);
  }
}
