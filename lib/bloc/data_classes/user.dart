import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/interest.dart';

class User {
  final AppColor appColor;
  final DateTime birthDate;
  final DateTime createdAt;
  final String description;
  final Gender gender;
  final List<Interest> interests;
  final String name;
  final String profileImage;

  User({
    this.appColor,
    this.birthDate,
    this.createdAt,
    this.description,
    this.gender,
    this.interests,
    this.name,
    this.profileImage,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
        appColor: AppColorExtension.parse(map['appColor']),
        birthDate: parseTimestamp(map['birthDate']),
        createdAt: parseTimestamp(map['createdAt']),
        description: map['description'],
        gender: GenderExtension.parse(map['gender']),
        interests: InterestExtension.parseList(map['interests']),
        name: map['name'],
        profileImage: map['profileImage'],
      );

  static DateTime parseTimestamp(source) =>
      source is Timestamp ? source.toDate() : null;

  @override
  String toString() {
    return 'User{appColor: $appColor, birthDate: $birthDate, createdAt: $createdAt, description: $description, gender: $gender, interests: $interests, name: $name, profileImage: $profileImage}';
  }
}
