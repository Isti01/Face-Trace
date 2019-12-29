import 'package:face_app/bloc/chat_bloc.dart';
import 'package:face_app/bloc/chat_bloc_states.dart';
import 'package:face_app/home/chat/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image/network.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key key}) : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  ChatBloc get bloc => BlocProvider.of<ChatBloc>(context);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.loadingChats) return CircularProgressIndicator();

        return ListView.builder(
          itemCount: state.chats.length,
          itemBuilder: (c, i) {
            final chat = state.chats[i];
            final user = chat.user;
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImageWithRetry(user.profileImage),
              ),
              title: Text(user.name),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (c) => ChatRoom(
                      bloc: bloc.chatRooms[chat.chatId],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
