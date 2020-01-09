import 'dart:ui';

import 'package:face_app/localizations/localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextInputBar extends StatefulWidget {
  final Function(String text) onSubmitted;
  final ScrollController scrollController;
  final Function(ImageSource source) sendImage;

  const TextInputBar({
    Key key,
    this.onSubmitted,
    this.scrollController,
    this.sendImage,
  }) : super(key: key);

  @override
  _TextInputBarState createState() => _TextInputBarState();
}

class _TextInputBarState extends State<TextInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _textNode = FocusNode();

  _jumpToStart() {
    try {
      widget.scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 125),
        curve: Curves.easeIn,
      );
    } catch (e, s) {
      print([e, s]);
    }
  }

  _submitText([_]) {
    widget.onSubmitted(_controller.text);
    _jumpToStart();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SizedBox(
          height: kTextTabBarHeight,
          width: double.infinity,
          child: Material(
            color: Colors.white10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.white70),
                    onPressed: () => widget.sendImage(ImageSource.gallery),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white70),
                    onPressed: () => widget.sendImage(ImageSource.camera),
                  ),
                  SizedBox(width: 4),
                  _textField(context, textTheme),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white70),
                    onPressed: _submitText,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Flexible _textField(BuildContext context, TextTheme textTheme) {
    final style = textTheme.subhead.apply(color: Colors.white);

    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          focusNode: _textNode,
          onTap: () {
            if (!_textNode.hasFocus) _jumpToStart();
          },
          controller: _controller,
          textInputAction: TextInputAction.send,
          onSubmitted: _submitText,
          style: style,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            filled: true,
            fillColor: Colors.white24,
            hintText: AppLocalizations.of(context).sendAMessage,
            hintStyle: style.apply(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(999),
              borderSide: BorderSide.none,
            ),
          ),
          // this is a workaround for a bug in flutter text input
          keyboardType: TextInputType.visiblePassword,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
