import 'package:flutter/material.dart';

class TextInputBar extends StatefulWidget {
  final onSubmitted;

  const TextInputBar({Key key, this.onSubmitted}) : super(key: key);

  @override
  _TextInputBarState createState() => _TextInputBarState();
}

class _TextInputBarState extends State<TextInputBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            textInputAction: TextInputAction.send,
            onSubmitted: widget.onSubmitted,
          ),
        ),
      ],
    );
  }
}
