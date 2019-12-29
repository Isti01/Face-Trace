import 'package:flutter/material.dart';

class EditableField extends StatefulWidget {
  final String text;
  final String replacementText;
  final TextStyle style;
  final Color cursorColor;
  final bool Function(String newText) onTextChanged;
  final TextAlign textAlign;
  const EditableField({
    Key key,
    this.text,
    this.replacementText,
    this.style,
    this.onTextChanged,
    this.cursorColor,
    this.textAlign = TextAlign.center,
  }) : super(key: key);
  @override
  _EditableFieldState createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  TextEditingController _controller;
  final FocusNode _textNode = FocusNode();

  bool editing = false;

  String get originalText => widget.text ?? widget.replacementText;

  cancelledEdit() => setState(() {
        _controller.text = originalText;
        editing = false;
      });

  editCompleted([_]) {
    if (!widget.onTextChanged(_controller.text))
      _controller.text = originalText;
    setState(() => editing = false);
  }

  @override
  void initState() {
    _controller = TextEditingController(text: originalText);
    super.initState();
  }

  @override
  void didUpdateWidget(EditableField oldWidget) {
    if (!editing) _controller.text = originalText;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!editing) return simpleText;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: EditableText(
              autocorrect: false,
              textAlign: widget.textAlign,
              controller: _controller,
              focusNode: _textNode,
              style: widget.style,
              cursorColor: widget.cursorColor,
              keyboardType: TextInputType.visiblePassword,
              onSubmitted: editCompleted,
              backgroundCursorColor: Colors.transparent,
              maxLines: null,
            ),
          ),
        ),
        SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Text('👍', style: TextStyle(fontSize: 24)),
              tooltip: "Mentés",
              onPressed: editCompleted,
            ),
            SizedBox(width: 24),
            IconButton(
              icon: Text('🔙', style: TextStyle(fontSize: 24)),
              tooltip: "Mégsem",
              onPressed: cancelledEdit,
            ),
          ],
        ),
      ],
    );
  }

  Widget get simpleText => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 44),
          Expanded(
            child: Text(
              _controller.text,
              style: widget.style,
              textAlign: widget.textAlign,
            ),
          ),
          IconButton(
            icon: Text('✏', style: TextStyle(fontSize: 16)),
            onPressed: () => setState(() {
              _controller.text = _controller.text;
              WidgetsBinding.instance
                  .addPostFrameCallback((d) => _textNode.requestFocus());

              editing = true;
            }),
          ),
        ],
      );

  @override
  void dispose() {
    _controller?.dispose();
    _textNode.dispose();
    super.dispose();
  }
}
