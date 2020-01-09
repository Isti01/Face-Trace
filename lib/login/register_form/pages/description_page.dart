import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:flutter/material.dart';

class DescriptionPage extends StatefulWidget {
  final String initialDescription;
  final Function(String description) onDescriptionChanged;
  final Function(String description) onSubmitted;

  const DescriptionPage({
    Key key,
    this.initialDescription,
    this.onDescriptionChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.initialDescription;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return FormPage(
      title: localizations.descriptionQuestion,
      child: TextField(
        controller: controller,
        minLines: 5,
        maxLines: null,
        decoration: InputDecoration(hintText: localizations.descriptionHint),
        onChanged: widget.onDescriptionChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
