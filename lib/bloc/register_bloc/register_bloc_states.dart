import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

DateTime get legalDate {
  final now = DateTime.now();

  return DateTime(now.year - 18, now.month, now.day);
}

abstract class RegisterEvent {}

class RegisterState {
  final String name;
  final DateTime birthDate;
  final Set<Interest> interests;
  final List<Face> detectedFaces;
  final Face userFace;
  final String description;
  final AppColor color;
  final Gender gender;
  final List<Gender> attractedTo;
  final String facePhoto;

  RegisterState({
    this.name,
    this.birthDate,
    this.interests,
    this.description,
    this.color = AppColor.green,
    this.gender,
    this.facePhoto,
    this.detectedFaces,
    this.userFace,
    this.attractedTo,
  });

  factory RegisterState.init({String name}) =>
      RegisterState(birthDate: legalDate, name: name, interests: {});

  RegisterState update({
    String name,
    DateTime birthDate,
    Set<Interest> interests,
    String description,
    AppColor color,
    Gender gender,
    String facePhoto,
    List<Face> detectedFaces,
    Face userFace,
    bool removeSelectedFace = false,
    List<Gender> attractedTo,
  }) =>
      RegisterState(
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        interests: interests ?? this.interests,
        description: description ?? this.description,
        color: color ?? this.color,
        gender: gender ?? this.gender,
        facePhoto: facePhoto ?? this.facePhoto,
        detectedFaces: detectedFaces ?? this.detectedFaces,
        userFace: removeSelectedFace ? null : userFace ?? this.userFace,
        attractedTo: attractedTo ?? this.attractedTo,
      );

  bool validate() {
    if (name == null ||
        birthDate == null ||
        interests == null ||
        description == null ||
        color == null ||
        gender == null ||
        facePhoto == null ||
        attractedTo == null) return false;

    if (name.isEmpty ||
        description.isEmpty ||
        !birthDate.isBefore(legalDate.add(Duration(hours: 23))) ||
        attractedTo.isEmpty) return false;

    return true;
  }

  @override
  String toString() {
    return 'RegisterState{name: $name, birthDate: $birthDate, interests: $interests, detectedFaces: $detectedFaces, userFace: $userFace, description: $description, color: $color, gender: $gender, facePhoto: $facePhoto}';
  }
}

class DescriptionChangedEvent extends RegisterEvent {
  final String description;

  DescriptionChangedEvent(this.description);
}

class InterestAddedEvent extends RegisterEvent {
  final Interest interest;

  InterestAddedEvent(this.interest);
}

class InterestRemovedEvent extends RegisterEvent {
  final Interest interest;

  InterestRemovedEvent(this.interest);
}

class NameChangedEvent extends RegisterEvent {
  final String name;

  NameChangedEvent(this.name);
}

class DateChangedEvent extends RegisterEvent {
  final DateTime date;

  DateChangedEvent(this.date);
}

class ColorChangedEvent extends RegisterEvent {
  final AppColor newColor;

  ColorChangedEvent(this.newColor);
}

class GenderChangedEvent extends RegisterEvent {
  final Gender gender;

  GenderChangedEvent(this.gender);
}

class PhotoChangedEvent extends RegisterEvent {
  final String photo;

  PhotoChangedEvent(this.photo);
}

class FacesDetectedEvent extends RegisterEvent {
  final List<Face> faces;

  FacesDetectedEvent(this.faces);
}

class FaceChosenEvent extends RegisterEvent {
  final Face face;

  FaceChosenEvent(this.face);
}

class AttractedToChangedEvent extends RegisterEvent {
  final List<Gender> attractedTo;

  AttractedToChangedEvent(this.attractedTo);
}
