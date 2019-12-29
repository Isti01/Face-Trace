import 'dart:ui';

import 'package:face_app/bloc/data_classes/user.dart';
import 'package:flutter/material.dart';

class CardDescription extends StatelessWidget {
  final User user;

  const CardDescription({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black26,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 12,
                left: 8,
                top: 4,
                right: 8,
              ),
              child: _DescriptionBody(user: user),
            ),
          ),
        ),
      ),
    );
  }
}

class _DescriptionBody extends StatelessWidget {
  final User user;

  const _DescriptionBody({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final birthDate = DateTime.now().year - user.birthDate.year;
    final name = user.name;
    final theme = Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "$name, $birthDate",
          style: theme.title,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (user.description != null) ...[
          Padding(padding: const EdgeInsets.all(4)),
          Text(
            user.description,
            style: theme.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
