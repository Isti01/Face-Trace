import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:face_app/bloc/register_bloc/register_bloc_states.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/login/register_form/pages/form_page.dart';
import 'package:face_app/util/app_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateFormat dateFormat(AppLocalizations loc) => DateFormat(loc.dateFormat);

final faceDetector = FirebaseVision.instance.faceDetector(
  FaceDetectorOptions(mode: FaceDetectorMode.accurate),
);

class SummaryPage extends StatefulWidget {
  final FirebaseUser user;
  final RegisterState state;
  final Function(List<Face> faces) onRegistrationFinished;
  final Function(List<Face> faces) onFacesDetected;

  const SummaryPage({
    Key key,
    this.state,
    this.user,
    @required this.onRegistrationFinished,
    this.onFacesDetected,
  }) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool loading = false;

  String _name(AppLocalizations loc) =>
      widget.state.name != null && widget.state.name.isNotEmpty
          ? "${widget.state.name} ${loc.mName}👋\n\n"
          : "";

  String _birthDate(AppLocalizations loc) => widget.state.birthDate != null
      ? "${dateFormat(loc).format(widget.state.birthDate)} ${loc.mDate}👶\n\n"
      : "";

  String _attractedTo(AppLocalizations loc) =>
      writeList(widget.state.attractedTo, loc.mAttractedTo);

  String _interests(AppLocalizations loc) =>
      writeList(widget.state.interests.toList(), loc.mInterests);

  String _description(AppLocalizations loc) =>
      widget.state.description != null && widget.state.description.isNotEmpty
          ? '${loc.mDescription} ${widget.state.description}'
          : "";

  String writeList(List list, String title) {
    if (list == null || list.isEmpty) return '';
    final buffer = StringBuffer(title);
    list.forEach(
      (val) {
        var text = '';
        if (val is Gender)
          text = val.text(context);
        else if (val is Interest) text = val.text(context);
        buffer..write('  ')..write(text);
      },
    );
    buffer.write('\n\n');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final color = widget.state.color.color[800];
    final buttonTextStyle =
        Theme.of(context).textTheme.button.copyWith(color: color);

    final indicatorColor = AlwaysStoppedAnimation(color);
    return FormPage(
      title: localizations.summaryText,
      description: localizations.summaryHint,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          "${_name(localizations)}"
          "${_attractedTo(localizations)}"
          "${_birthDate(localizations)}"
          "${_interests(localizations)}"
          "${_description(localizations)}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: RaisedButton(
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      valueColor: indicatorColor,
                    ),
                  ),
                ),
              Text(
                localizations.summeryFinish,
                style: buttonTextStyle,
              ),
            ],
          ),
          onPressed: loading ? () {} : onPressed,
        ),
      ),
    );
  }

  onPressed(AppLocalizations localizations) async {
    print(widget.state);
    this.setState(() => loading = true);
    try {
      if (!widget.state.validate()) {
        showToast(context, title: localizations.invalidForm);
        this.setState(() => loading = false);
        return;
      }

      final faces = await faceDetector.processImage(
        FirebaseVisionImage.fromFilePath(widget.state.facePhoto),
      );

      if (faces.isEmpty) {
        showToast(
          context,
          title: localizations.noFace,
          message: localizations.imageHint,
        );
        this.setState(() => loading = false);
        return;
      }

      widget.onFacesDetected(faces);
      widget.onRegistrationFinished(faces);
    } catch (e, s) {
      print([e, s]);
      this.setState(() => loading = false);
    }
  }
}
