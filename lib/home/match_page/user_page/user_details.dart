import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/interest.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/match_page/user_page/user_image.dart';
import 'package:face_app/home/user_page/interests.dart';
import 'package:face_app/util/gallery.dart';
import 'package:face_app/util/page_divider.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
          UserImage(user: user),
          SizedBox(height: 24),
          Text(
            '${user?.name ?? ''} ${user?.gender?.emoji ?? ''}',
            style: textTheme.display1,
            textAlign: TextAlign.center,
          ),
          if ((user?.images?.length ?? 0) > 0) ...[
            PageDivider(
              text: "Galéria",
              addPadding: false,
              style: textTheme.title,
              color: Colors.white54,
            ),
            Gallery(images: user.images, imageSize: 160),
          ],
          if (user?.description?.trim()?.isNotEmpty ?? false) ...[
            PageDivider(
              text: "Leírás",
              addPadding: false,
              style: textTheme.title,
              color: Colors.white54,
            ),
            Text(user.description, style: textTheme.subtitle),
          ],
          if ((user?.interests?.length ?? 0) > 0) ...[
            PageDivider(
              text: "Érdeklődési kör",
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
                        interest: interest.text,
                        textTheme: textTheme,
                      )))
                  .toList(),
            ),
          ],
          if ((user?.attractedTo?.length ?? 0) > 1) ...[
            PageDivider(
              text: "Vonzódik utána",
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
                        interest: gender.text,
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
