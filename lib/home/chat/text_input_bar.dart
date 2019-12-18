import 'package:flutter/material.dart';

class TextInputBar extends StatefulWidget {
  final onSubmitted;

  const TextInputBar({Key key, this.onSubmitted}) : super(key: key);

  @override
  _TextInputBarState createState() => _TextInputBarState();
}

class _TextInputBarState extends State<TextInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode textNode = FocusNode();

  @override
  void initState() {
    _controller.addListener(() => print('asd'));
    textNode.addListener(() => print('sdf'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('willpop');
        return false;
      },
      child: Row(
        children: [
          Flexible(
            child: TextField(
              focusNode: textNode,
              controller: _controller,
              onTap: () {
                print('started');
              },
              onEditingComplete: () {
                print('complete');
              },
              textInputAction: TextInputAction.send,
              onSubmitted: widget.onSubmitted,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textNode.dispose();
    _controller.dispose();
    super.dispose();
  }
}
