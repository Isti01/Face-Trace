import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final FocusNode node;
  final onFieldSubmitted, icon, labelText;
  final TextInputAction textInputAction;

  final String Function(String text) validator;
  final TextEditingController controller;
  final String errorText;
  final obscureText;
  final bool autoFocus;
  final lines;

  const InputField({
    Key key,
    this.node,
    this.onFieldSubmitted,
    this.icon,
    this.labelText,
    this.textInputAction,
    this.validator,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.autoFocus = false,
    this.lines = 1,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context)
        .textTheme
        .caption
        .copyWith(fontSize: 18, fontWeight: FontWeight.w500);

    return TextFormField(
      autofocus: widget.autoFocus,
      controller: widget.controller,
      focusNode: widget.node,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLines: widget.lines,
      minLines: widget.lines,
      textInputAction: widget.textInputAction,
      style: Theme.of(context).textTheme.title,
      decoration: InputDecoration(
        errorText: widget.errorText,
        icon:
            widget.icon != null ? Icon(widget.icon, color: Colors.black) : null,
        labelText: widget.labelText,
        errorMaxLines: 4,
        labelStyle: labelStyle,
        border: InputBorder.none,
      ),
      obscureText: widget.obscureText,
    );
  }
}
