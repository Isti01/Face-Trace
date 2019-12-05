import 'dart:async';
import 'dart:math' as math;

import 'package:face_app/bloc/register_bloc.dart';
import 'package:face_app/bloc/register_bloc_states.dart';
import 'package:face_app/login/register_form/pages/birthdate_page.dart';
import 'package:face_app/login/register_form/pages/color_page.dart';
import 'package:face_app/login/register_form/pages/description_page.dart';
import 'package:face_app/login/register_form/pages/gender_page.dart';
import 'package:face_app/login/register_form/pages/interests_page.dart';
import 'package:face_app/login/register_form/pages/name_page.dart';
import 'package:face_app/login/register_form/pages/profile_image_page.dart';
import 'package:face_app/login/register_form/pages/summary_page.dart';
import 'package:face_app/util/dynamic_gradient.dart';
import 'package:face_app/util/page_indicator.dart';
import 'package:face_app/util/page_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterForm extends StatefulWidget {
  final RegisterBloc bloc;
  final FirebaseUser user;
  final GlobalKey<DynamicGradientBackgroundState> backgroundKey;
  final Function(List<Face> face) onRegistrationFinished;

  const RegisterForm({
    Key key,
    this.user,
    this.backgroundKey,
    this.bloc,
    @required this.onRegistrationFinished,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final PageController controller = PageController();
  bool hasName = false;
  StreamSubscription subscription;

  jumpToPage(int index) {
    FocusScope.of(context).unfocus();

    Future.delayed(Duration(milliseconds: 250), () async {
      await controller.animateToPage(
        index,
        duration: Duration(milliseconds: 1500),
        curve: Curves.easeInOutCubic,
      );
      this.setState(() {});
    });
  }

  @override
  void initState() {
    final name = widget?.user?.displayName;
    this.hasName = name != null && name.isNotEmpty;
    subscription = widget.bloc.listen((_) => setState(() {}));
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  nextPage() => controller.nextPage(
        duration: Duration(milliseconds: 1500),
        curve: Curves.easeInOutCubic,
      );

  prevPage() => controller.previousPage(
        duration: Duration(milliseconds: 1500),
        curve: Curves.easeInOutCubic,
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
        bloc: widget.bloc,
        builder: (context, state) {
          final children = getPages(context, state);
          final pageCount = children.length;

          return Stack(
            children: [
              PageView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: controller,
                children: children,
              ),
              PageSwitcher(
                pageIndex: controller.hasClients ? controller.page : 0,
                numPages: pageCount,
                onUp: () {
                  Focus.of(context).unfocus();
                  prevPage();
                },
                onDown: () {
                  Focus.of(context).unfocus();
                  nextPage();
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: PageIndicator(
                  controller: controller,
                  numPages: pageCount,
                  jumpToPage: jumpToPage,
                ),
              )
            ],
          );
        });
  }

  List<Widget> getPages(BuildContext context, RegisterState state) {
    final interests = Interest.values;
    final length = interests.length;
    final numPages = (length / 6).ceil();

    return [
      NamePage(
        onNameChanged: widget.bloc.nameChanged,
        onFinished: nextPage,
        initialName: state.name,
      ),
      ProfileImagePage(
        initialPhoto: widget.user.photoUrl,
        onPhotoChanged: widget.bloc.onPhotoChanged,
        photoFilePath: state.facePhoto,
        color: state.color,
      ),
      BirthDatePage(
        onDateChanged: widget.bloc.onDateChanged,
        startDate: state.birthDate,
      ),
      GenderPage(
        initialGender: state.gender,
        onGenderChanged: widget.bloc.onGenderChanged,
      ),
      ColorPage(
        initialColor: state.color,
        onColorChanged: (color, offset) {
          widget.backgroundKey.currentState
              .changeGradient(gradient: color, startOffset: offset);
          widget.bloc.onColorChanged(color);
        },
      ),
      for (int i = 0; i < numPages; i++)
        InterestsPage(
          choices: interests.sublist(i * 6, math.min((i * 6) + 6, length)),
          numPages: numPages,
          pageNum: i + 1,
          onInterestAdded: widget.bloc.onInterestAdded,
          onInterestRemoved: widget.bloc.onInterestRemoved,
          initialSelected: state.interests,
        ),
      DescriptionPage(
        initialDescription: state.description,
        onDescriptionChanged: widget.bloc.onDescriptionChanged,
        onSubmitted: (desc) {
          widget.bloc.onDescriptionChanged(desc);
          nextPage();
        },
      ),
      SummaryPage(
        state: state,
        user: widget.user,
        onFacesDetected: widget.bloc.onFacesDetected,
        onRegistrationFinished: (faces) => widget.onRegistrationFinished(faces),
      ),
    ];
  }

  @override
  void dispose() {
    subscription?.cancel();
    controller?.dispose();
    super.dispose();
  }
}
