import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/user_bloc.dart';
import 'package:face_app/home/user_page/avatar.dart';
import 'package:face_app/home/user_page/editable_field.dart';
import 'package:face_app/home/user_page/interests.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key key}) : super(key: key);

  UserBloc getBloc(context) => BlocProvider.of<UserBloc>(context);

  @override
  Widget build(BuildContext context) {
    final user = CurrentUser.of(context).user;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 4),
          Avatar(
            profileImage: user.profileImage,
            color: user.appColor.color[800],
          ),
          _name(user, context, textTheme),
          ..._divider(textTheme.title, 'Leírás'),
          _description(user, context, textTheme),
          ..._divider(textTheme.title, 'Érdeklődési kör'),
          Interests(interests: user.interests, color: user.appColor),
          ..._divider(),
          OutlineButton(
            child: Text("Kijelentkezés 👋"),
            onPressed: () => auth.signOut(),
            shape: AppBorder,
          ),
        ],
      ),
    );
  }

  List<Widget> _divider([TextStyle style, String text]) => [
        SizedBox(height: 4),
        Divider(),
        if (text != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: style,
              ),
            ),
          ),
        SizedBox(height: 16),
      ];

  Widget _name(User user, context, TextTheme textTheme) => EditableField(
        cursorColor: user.appColor.color,
        text: user.name,
        replacementText: "Név",
        style: textTheme.display1,
        onTextChanged: (name) {
          if ((name?.isEmpty ?? false) || name == user.name) return false;
          return getBloc(context).fieldChanged(name, 'name');
        },
      );

  Widget _description(User user, context, TextTheme textTheme) => SizedBox(
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
            return getBloc(context).fieldChanged(desc, 'description');
          },
        ),
      );
}
