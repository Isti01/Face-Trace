import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  final AppColor appColor;
  final DateTime birthDate;
  final DateTime createdAt;
  final String description;
  final Gender gender;
  final List<Gender> attractedTo;
  final List<Interest> interests;
  final String name;
  final String profileImage;
  final FirebaseUser user;
  final bool fetchedData;
  final bool initial;

  User({
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
  });

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
          name == other.name &&
          profileImage == other.profileImage &&
          user == other.user &&
          fetchedData == other.fetchedData &&
          initial == other.initial;

  @override
  int get hashCode =>
      appColor.hashCode ^
      birthDate.hashCode ^
      createdAt.hashCode ^
      description.hashCode ^
      gender.hashCode ^
      attractedTo.hashCode ^
      interests.hashCode ^
      name.hashCode ^
      profileImage.hashCode ^
      user.hashCode ^
      fetchedData.hashCode ^
      initial.hashCode;

  factory User.fromMap(Map<String, dynamic> map, [FirebaseUser user]) {
    if (map == null) return User(user: user, fetchedData: true);
    return User(
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
    );
  }

  bool get hasData =>
      appColor != null ||
      birthDate != null ||
      createdAt != null ||
      description != null ||
      gender != null ||
      interests != null ||
      name != null ||
      profileImage != null ||
      attractedTo != null;

  static DateTime parseTimestamp(source) =>
      source is Timestamp ? source.toDate() : null;

  User addFirebaseUser(FirebaseUser newUser) => User(
      appColor: appColor,
      birthDate: birthDate,
      createdAt: createdAt,
      description: description,
      gender: gender,
      interests: interests,
      name: name,
      profileImage: profileImage,
      fetchedData: fetchedData,
      user: newUser);

  @override
  String toString() {
    return 'User{appColor: $appColor, birthDate: $birthDate, createdAt: $createdAt, description: $description, gender: $gender, attractedTo: $attractedTo, interests: $interests, name: $name, profileImage: $profileImage, user: $user, fetchedData: $fetchedData, initial: $initial}';
  }
}
