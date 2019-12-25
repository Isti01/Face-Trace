import 'dart:math' as math;

import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:face_app/bloc/register_bloc.dart';
import 'package:face_app/bloc/register_bloc_states.dart';
import 'package:face_app/login/register_form/pages/attracted_to_page.dart';
import 'package:face_app/login/register_form/pages/birthdate_page.dart';
import 'package:face_app/login/register_form/pages/color_page.dart';
import 'package:face_app/login/register_form/pages/description_page.dart';
import 'package:face_app/login/register_form/pages/gender_page.dart';
import 'package:face_app/login/register_form/pages/interests_page.dart';
import 'package:face_app/login/register_form/pages/name_page.dart';
import 'package:face_app/login/register_form/pages/profile_image_page.dart';
import 'package:face_app/login/register_form/pages/summary_page.dart';
import 'package:face_app/util/dynamic_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

List<Widget> getPages(
  BuildContext context,
  RegisterState state,
  FirebaseUser user,
  RegisterBloc bloc,
  VoidCallback nextPage,
  GlobalKey<DynamicGradientBackgroundState> backgroundKey,
  Function(List<Face> faces) onRegistrationFinished,
) {
  final interests = Interest.values;
  final length = interests.length;
  final numPages = (length / 6).ceil();

  return [
    NamePage(
      onNameChanged: bloc.nameChanged,
      onFinished: nextPage,
      initialName: state.name,
    ),
    ProfileImagePage(
      onPhotoChanged: bloc.onPhotoChanged,
      photoFilePath: state.facePhoto,
      color: state.color,
    ),
    BirthDatePage(
      onDateChanged: bloc.onDateChanged,
      startDate: state.birthDate,
    ),
    GenderPage(
      initialGender: state.gender,
      onGenderChanged: bloc.onGenderChanged,
    ),
    AttractedToPage(
      initialGenders: state.attractedTo,
      onGendersChanged: bloc.onAttractedToChanged,
    ),
    ColorPage(
      initialColor: state.color,
      onColorChanged: (color, offset) {
        backgroundKey.currentState
            .changeGradient(gradient: color, startOffset: offset);
        bloc.onColorChanged(color);
      },
    ),
    for (int i = 0; i < numPages; i++)
      InterestsPage(
        choices: interests.sublist(i * 6, math.min((i * 6) + 6, length)),
        numPages: numPages,
        pageNum: i + 1,
        onInterestAdded: bloc.onInterestAdded,
        onInterestRemoved: bloc.onInterestRemoved,
        initialSelected: state.interests,
      ),
    DescriptionPage(
      initialDescription: state.description,
      onDescriptionChanged: bloc.onDescriptionChanged,
      onSubmitted: (desc) {
        bloc.onDescriptionChanged(desc);
        nextPage();
      },
    ),
    SummaryPage(
      state: state,
      user: user,
      onFacesDetected: bloc.onFacesDetected,
      onRegistrationFinished: (faces) => onRegistrationFinished(faces),
    ),
  ];
}
