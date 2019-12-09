import 'dart:ui';

import 'package:flutter/material.dart';

class CardDescription extends StatelessWidget {
  final data;

  const CardDescription({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = data['name'];
    final birthDate = DateTime.now().year - data['birthDate'].toDate().year;

    final theme = Theme.of(context).textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        );
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black26,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 12, left: 8, top: 4, right: 8),
              child: Column(
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
                  if (data['description'] != null) ...[
                    Padding(padding: const EdgeInsets.all(4)),
                    Text(
                      data['description'],
                      style: theme.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
