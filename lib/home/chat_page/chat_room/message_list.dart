import 'package:face_app/bloc/chat_room_bloc/chat_room_bloc.dart';
import 'package:face_app/bloc/data_classes/chat_message.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/chat_page/chat_room/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController controller;
  final User partner;
  final bool loading;

  const MessageList({
    Key key,
    this.messages,
    this.controller,
    this.loading,
    this.partner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final length = messages.length;

    return NotificationListener(
      child: CustomScrollView(
        shrinkWrap: true,
        cacheExtent: 200,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.only(bottom: kTextTabBarHeight + 4),
            sliver: SliverSafeArea(
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (c, i) {
                    final message = messages[i];
                    return ChatBubble(
                      partner: partner,
                      key: ValueKey(message.id),
                      message: message,
                      includeName: i == length - 1 ||
                          messages[i + 1].createdBy != message.createdBy,
                    );
                  },
                  childCount: length,
                ),
              ),
            ),
          ),
          if (loading)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 36,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 12),
          ),
        ],
        controller: controller,
        physics: BouncingScrollPhysics(),
        reverse: true,
      ),
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          BlocProvider.of<ChatRoomBloc>(context).nextMessages();
          return true;
        }

        return false;
      },
    );
  }
}
