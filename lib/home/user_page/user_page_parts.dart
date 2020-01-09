import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/user_page/avatar.dart';
import 'package:face_app/home/user_page/editable_field.dart';
import 'package:face_app/home/user_page/interests.dart';
import 'package:face_app/home/user_page/user_page.dart';
import 'package:flutter/material.dart';

Widget avatar(BuildContext context, User user, double avatarTop) => Positioned(
      child: Avatar(
        profileImage: user.profileImage,
        onImageChanged: (path) =>
            UserPage.getBloc(context).fieldChanged(path, 'profileImage'),
      ),
      top: avatarTop,
    );

Widget interests(BuildContext context, User user) => Interests(
      onInterestsUpdated: (interests) => UserPage.getBloc(context).fieldChanged(
        interests.map(InterestExtension.toFirestore).toList(),
        'interests',
      ),
      initialInterests: user.interests,
      color: user.appColor,
    );

Widget name(User user, context, TextTheme textTheme) => EditableField(
      cursorColor: user.appColor.color,
      text: user.name,
      replacementText: "Név",
      style: textTheme.display1,
      onTextChanged: (name) {
        if ((name?.isEmpty ?? false) || name == user.name) return false;
        return UserPage.getBloc(context).fieldChanged(name, 'name');
      },
    );

Widget description(User user, context, TextTheme textTheme) => SizedBox(
      width: double.infinity,
      child: EditableField(
        cursorColor: user.appColor.color,
        text: user.description,
        replacementText: "Leírás rólam",
        style: textTheme.subhead,
        textAlign: TextAlign.start,
        onTextChanged: (desc) {
          if ((desc?.isEmpty ?? false) || desc == user.description)
            return false;
          return UserPage.getBloc(context).fieldChanged(desc, 'description');
        },
      ),
    );
