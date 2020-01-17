import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:face_app/bloc/data_classes/language.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class User {
  final AppColor appColor;
  final DateTime birthDate;
  final DateTime createdAt;
  final String description;
  final Gender gender;
  final List<Gender> attractedTo;
  final List<Interest> interests;
  final List<String> images;
  final String name;
  final String profileImage;
  final FirebaseUser user;
  final bool fetchedData;
  final bool initial;
  final String uid;
  final Coordinates location;
  final Language language;

  const User({
    this.appColor,
    this.birthDate,
    this.createdAt,
    this.description,
    this.gender,
    this.interests,
    this.name,
    this.profileImage,
    this.user,
    this.fetchedData = false,
    this.initial = false,
    this.attractedTo,
    this.uid,
    this.images,
    this.location,
    this.language = Language.en,
  });

  factory User.fromMap(
    Map<String, dynamic> map, [
    String docId,
    FirebaseUser user,
  ]) {
    if (map == null) return User(user: user, fetchedData: true);

    List<String> images;
    final rawImages = map['images'];
    try {
      if (rawImages != null && rawImages is Iterable) {
        images = List<String>.from(rawImages);
      } else {
        images = [];
      }
    } catch (e, s) {
      images = [];
      print([e, s]);
    }

    Coordinates location;

    try {
      final data = map['location'];
      if (data != null && data is Map)
        location = parseGeopoint(data['geopoint']);
    } catch (e, s) {
      print([e, s]);
    }

    return User(
      uid: docId,
      appColor: AppColorExtension.parse(map['appColor']),
      birthDate: parseTimestamp(map['birthDate']),
      createdAt: parseTimestamp(map['createdAt']),
      description: map['description'],
      attractedTo: GenderExtension.parseList(map['attractedTo']),
      gender: GenderExtension.parse(map['gender']),
      interests: InterestExtension.parseList(map['interests']),
      name: map['name'],
      profileImage: map['profileImage'],
      user: user,
      fetchedData: true,
      images: images,
      location: location,
      language: LanguageExtension.parse(map['language']),
    );
  }

  static DateTime parseTimestamp(source) =>
      source is Timestamp ? source.toDate() : null;

  static Coordinates parseGeopoint(source) => source is GeoPoint
      ? Coordinates(source.latitude, source.longitude)
      : null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          appColor == other.appColor &&
          birthDate == other.birthDate &&
          createdAt == other.createdAt &&
          description == other.description &&
          gender == other.gender &&
          attractedTo == other.attractedTo &&
          interests == other.interests &&
          images == other.images &&
          name == other.name &&
          profileImage == other.profileImage &&
          user == other.user &&
          fetchedData == other.fetchedData &&
          initial == other.initial &&
          uid == other.uid &&
          location == other.location &&
          language == other.language;

  @override
  int get hashCode =>
      appColor.hashCode ^
      birthDate.hashCode ^
      createdAt.hashCode ^
      description.hashCode ^
      gender.hashCode ^
      attractedTo.hashCode ^
      interests.hashCode ^
      images.hashCode ^
      name.hashCode ^
      profileImage.hashCode ^
      user.hashCode ^
      fetchedData.hashCode ^
      initial.hashCode ^
      uid.hashCode ^
      location.hashCode ^
      language.hashCode;

  bool get hasData =>
      appColor != null ||
      birthDate != null ||
      createdAt != null ||
      description != null ||
      gender != null ||
      interests != null ||
      name != null ||
      profileImage != null ||
      attractedTo != null ||
      images != null ||
      location != null ||
      language != null;

  @override
  String toString() {
    return 'User{appColor: $appColor, birthDate: $birthDate, createdAt: $createdAt, description: $description, gender: $gender, attractedTo: $attractedTo, interests: $interests, images: $images, name: $name, profileImage: $profileImage, user: $user, fetchedData: $fetchedData, initial: $initial, uid: $uid}';
  }
}
