import 'dart:ui';

import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class CardDescription extends StatefulWidget {
  final User user;

  const CardDescription({Key key, this.user}) : super(key: key);

  @override
  _CardDescriptionState createState() => _CardDescriptionState();
}

class _CardDescriptionState extends State<CardDescription> {
  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUser.of(context).user;

    int birthDate;
    final date = widget.user?.birthDate;
    if (date != null) {
      final difference = DateTime.now().difference(date);

      birthDate = (difference.inDays / 365).round();
    }

    int distance;

    final from = currentUser?.location;
    final to = widget.user?.location;

    if (to != null && from != null) {
      distance = GeoFirePoint.distanceBetween(to: to, from: from).round();
    }

    final name = widget.user?.name;
    final theme = Theme.of(context).textTheme;

    final hasDistance = distance != null;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text.rich(
            TextSpan(text: name ?? "", children: [
              if (birthDate != null) TextSpan(text: ", $birthDate 🎂"),
            ]),
            style: theme.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(padding: EdgeInsets.all(2)),
          if (hasDistance) _distanceText(distance, theme, hasDistance),
          Padding(padding: EdgeInsets.all(4)),
          Text(
            widget.user.description ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (!hasDistance) _distanceText(distance, theme, hasDistance),
        ],
      ),
    );
  }

  _distanceText(int distance, TextTheme theme, bool hasDistance) => Text(
        hasDistance ? " ${distance}km 🛣️" : '',
        style: theme.subtitle,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
}
