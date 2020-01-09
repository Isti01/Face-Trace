import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/bloc/user_bloc/user_bloc.dart';
import 'package:face_app/home/face_app_home.dart';
import 'package:face_app/home/user_page/color_picker.dart';
import 'package:face_app/home/user_page/user_page_parts.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/util/constants.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/gallery.dart';
import 'package:face_app/util/page_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key key}) : super(key: key);

  static UserBloc getBloc(context) => BlocProvider.of<UserBloc>(context);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final user = CurrentUser.of(context).user;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    final difference = size.shortestSide * 0.45 / 1.65;

    final topPadding = size.height / 8 + difference;
    final avatarTop = topPadding - difference;

    return SingleChildScrollView(
      child: Padding(
        padding: PagePadding,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: topPadding),
              child: Material(
                color: Colors.white,
                elevation: 4,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height:
                            size.shortestSide * 0.45 - (topPadding - avatarTop),
                      ),
                      name(user, context, textTheme),
                      PageDivider(
                        style: textTheme.title,
                        text: localizations.gallery,
                      ),
                      Gallery(
                        images: user.images,
                        startOffset: 44,
                        canAddNew: true,
                        addToGallery: getBloc(context).addToGallery,
                      ),
                      PageDivider(
                        style: textTheme.title,
                        text: localizations.description,
                      ),
                      description(user, context, textTheme),
                      PageDivider(
                        style: textTheme.title,
                        text: localizations.interests,
                      ),
                      interests(context, user),
                      PageDivider(),
                      ColorPicker(
                        color: user.appColor,
                        onColorChanged: (color) =>
                            getBloc(context).fieldChanged(color, 'appColor'),
                      ),
                      SizedBox(height: 20),
                      OutlineButton(
                        child: Text(localizations.logOut + " 👋"),
                        onPressed: () => auth.signOut(),
                        shape: AppBorder,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            avatar(context, user, avatarTop),
          ],
        ),
      ),
    );
  }
}
