import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/user_bloc/user_bloc.dart';
import 'package:face_app/home/match_page/user_page/user_page.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/transparent_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppBar extends StatelessWidget {
  final User partner;

  const ChatAppBar({Key key, this.partner}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TransparentAppBar(
      color: Colors.white10,
      title: GestureDetector(
        onTap: () {
          final userBloc = BlocProvider.of<UserBloc>(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => CurrentUser.passOverUser(
                bloc: userBloc,
                child: UserPage(
                  heroTag: partner.uid + 'chatAvatar',
                  user: partner,
                ),
              ),
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (partner?.profileImage != null) ...[
              Hero(
                tag: partner.uid + 'chatAvatar',
                child: CircleAvatar(
                  backgroundImage: NetworkImage(partner.profileImage),
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
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
