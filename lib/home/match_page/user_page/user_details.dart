import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/match_page/user_page/user_image.dart';
import 'package:face_app/home/user_page/interests.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/util/gallery.dart';
import 'package:face_app/util/page_divider.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  final User user;
  final String heroTag;

  const UserDetails({Key key, this.user, this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final textTheme = Theme.of(context).textTheme.apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        );

    return Padding(
      padding: const EdgeInsets.all(16).add(EdgeInsets.only(bottom: 104)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(child: SizedBox(height: kToolbarHeight)),
          UserImage(user: user, heroTag: heroTag),
          SizedBox(height: 24),
          if ((user?.images?.length ?? 0) > 0) ...[
            PageDivider(
              text: localizations.gallery,
              addPadding: false,
              style: textTheme.title,
              color: Colors.white54,
            ),
            Gallery(images: user.images, imageSize: 160),
          ],
          if (user?.description?.trim()?.isNotEmpty ?? false) ...[
            PageDivider(
              text: localizations.description,
              addPadding: false,
              style: textTheme.title,
              color: Colors.white54,
            ),
            Text(user.description, style: textTheme.subtitle),
          ],
          if ((user?.interests?.length ?? 0) > 0) ...[
            PageDivider(
              text: localizations.interests,
              addPadding: false,
              style: textTheme.title,
              color: Colors.white54,
            ),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.spaceEvenly,
              runAlignment: WrapAlignment.spaceEvenly,
              children: user.interests
                  .map(((Interest interest) => FaceAppChip(
                        appColor: user.appColor,
                        color: Colors.white24,
                        interest: interest.text(context),
                        textTheme: textTheme,
                      )))
                  .toList(),
            ),
          ],
          if ((user?.attractedTo?.length ?? 0) > 1) ...[
            PageDivider(
              text: localizations.attractedTo,
              addPadding: false,
              style: textTheme.title,
              color: Colors.white54,
            ),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.spaceEvenly,
              runAlignment: WrapAlignment.spaceBetween,
              children: user.attractedTo
                  .map(((Gender gender) => FaceAppChip(
                        appColor: user.appColor,
                        color: Colors.white24,
                        interest: gender.text(context),
                        textTheme: textTheme,
                      )))
                  .toList(),
            ),
          ]
        ],
      ),
    );
  }
}
