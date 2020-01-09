import 'package:face_app/bloc/data_classes/gender.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/match_page/card_description.dart';
import 'package:face_app/home/match_page/loading_card.dart';
import 'package:flutter/material.dart';

class CardImage extends StatelessWidget {
  final User user;

  const CardImage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.shortestSide * 0.8;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Hero(
          tag: (user.profileImage ?? user.uid) + 'matchUserImage',
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              height: imageSize,
              width: imageSize,
              child: Image.network(
                user.profileImage,
                loadingBuilder: _imageBuilder,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        CardDescription(user: user),
      ],
    );
  }

  Widget _imageBuilder(context, Widget child, ImageChunkEvent e) =>
      e == null ? child : LoadingCard.loadingEmoji(user.gender.emoji);
}
