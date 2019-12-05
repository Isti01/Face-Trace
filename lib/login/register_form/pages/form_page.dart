import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormPage extends StatelessWidget {
  final String title;
  final Widget child;
  final String description;
  final Widget footer;
  final bool removeChildPadding;

  const FormPage({
    Key key,
    this.title,
    this.child,
    this.description,
    this.footer,
    this.removeChildPadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const padding = EdgeInsets.symmetric(horizontal: 32);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Spacer(flex: 3),
          if (title != null)
            Padding(
              padding: padding,
              child: Text(
                title,
                style: textTheme.display1,
                textAlign: TextAlign.center,
              ),
            ),
          if (description != null)
            Padding(
              padding: padding,
              child: Text(description, style: textTheme.subtitle),
            ),
          Spacer(),
          Padding(
            padding: removeChildPadding ? EdgeInsets.zero : padding,
            child: child,
          ),
          Spacer(flex: 5),
          if (footer != null) footer
        ],
      ),
    );
  }
}
