import 'package:face_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:face_app/bloc/chat_bloc/chat_bloc_states.dart';
import 'package:face_app/home/chat_page/chat_room/chat_room.dart';
import 'package:face_app/util/current_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image/network.dart';

class ChatList extends StatelessWidget {
  final ChatState state;

  const ChatList({Key key, this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final chats = state.filteredChats;
    final textTheme = Theme.of(context).textTheme;
    if (chats?.isEmpty ?? true)
      return SliverToBoxAdapter(
        child: Material(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text("Nincs chat partner", style: textTheme.title),
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
              leading: CircleAvatar(
                backgroundImage: NetworkImageWithRetry(user.profileImage),
              ),
              title: Text(user.name),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => CurrentUser.passOverUser(
                      context: context,
                      child: ChatRoom(
                        partner: user,
                        bloc: BlocProvider.of<ChatBloc>(context)
                            .chatRooms[chat.chatId],
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
