import 'package:face_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:face_app/bloc/chat_bloc/chat_bloc_states.dart';
import 'package:face_app/bloc/user_bloc/user_bloc.dart';
import 'package:face_app/home/chat_page/chat_room/chat_room.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatList extends StatelessWidget {
  final ChatState state;

  const ChatList({Key key, this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final chats = state.filteredChats;
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context);
    if (chats?.isEmpty ?? true)
      return SliverToBoxAdapter(
        child: Material(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(localizations.noChatPartner, style: textTheme.title),
            ),
          ),
        ),
      );

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (c, i) {
          final chat = chats[i];
          final user = chat.user;

          return Material(
            key: ValueKey(chat.chatId),
            child: ListTile(
              leading: Hero(
                tag: user.uid + "chatAvatar",
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImage),
                ),
              ),
              title: Hero(
                tag: user.uid + "chatName",
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(user.name),
                ),
              ),
              onTap: () async {
                final userBloc = BlocProvider.of<UserBloc>(context);
                final chatBloc =
                    BlocProvider.of<ChatBloc>(context).chatRooms[chat.chatId];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => CurrentUser.passOverUser(
                      bloc: userBloc,
                      child: ChatRoom(
                        partner: user,
                        bloc: chatBloc,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        childCount: chats.length,
      ),
    );
  }
}
