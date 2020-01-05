import 'dart:ui';

import 'package:face_app/bloc/data_classes/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardDescription extends StatefulWidget {
  final User user;

  const CardDescription({Key key, this.user}) : super(key: key);

  @override
  _CardDescriptionState createState() => _CardDescriptionState();
}

class _CardDescriptionState extends State<CardDescription> {
  @override
  Widget build(BuildContext context) {
    final birthDate = DateTime.now().year - widget.user.birthDate.year;
    final name = widget.user.name;
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "$name, $birthDate",
            style: theme.title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(padding: const EdgeInsets.all(4)),
          Text(
            widget.user.description ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
