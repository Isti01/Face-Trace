import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:flutter/material.dart';

class NamePage extends StatefulWidget {
  final Function(String name) onNameChanged;
  final VoidCallback onFinished;
  final initialName;

  const NamePage({
    Key key,
    this.onNameChanged,
    this.onFinished,
    this.initialName,
  }) : super(key: key);

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final controller = TextEditingController();

  @override
  void initState() {
    controller.addListener(() => widget.onNameChanged(controller.text));
    controller.text = widget.initialName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: "Add meg a neved!",
      child: TextField(
        onSubmitted: (text) {
          widget.onNameChanged(text);
          widget.onFinished();
        },
        decoration: InputDecoration(
          hintText: "A nevem...",
        ),
        controller: controller,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
