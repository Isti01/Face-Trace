import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/util/transparent_appbar.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  final User partner;

  const ChatAppBar({Key key, this.partner}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TransparentAppBar(
      color: Colors.white10,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (partner?.profileImage != null) ...[
            Hero(
              tag: partner.uid + 'chatAvatar',
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  partner.profileImage,
                ),
              ),
            ),
            SizedBox(width: 12),
          ],
          if (partner?.name != null)
            Hero(
              tag: partner.uid + 'chatName',
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  partner.name,
                  style: textTheme.title.apply(
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
