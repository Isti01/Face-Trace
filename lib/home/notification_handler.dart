import 'package:face_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:face_app/bloc/data_classes/notification_data.dart';
import 'package:face_app/bloc/match_bloc/match_bloc.dart';
import 'package:face_app/bloc/user_bloc/user_bloc.dart';
import 'package:face_app/home/chat_page/chat_room/chat_room.dart';
import 'package:face_app/home/match_screen/match_screen.dart';
import 'package:face_app/home/nav_bar/nav_bar.dart';
import 'package:face_app/util/current_user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationHandler extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavBarState> navBarKey;

  const NotificationHandler({
    Key key,
    this.child,
    this.navBarKey,
  }) : super(key: key);

  @override
  _NotificationHandlerState createState() => _NotificationHandlerState();
}

class _NotificationHandlerState extends State<NotificationHandler> {
  ChatBloc get chatBloc => BlocProvider.of<ChatBloc>(context);

  MatchBloc get matchBloc => BlocProvider.of<MatchBloc>(context);

  UserBloc get userBloc => BlocProvider.of<UserBloc>(context);

  openChat(String partnerId, String blocId) async {
    // false lint
    final bloc = await chatBloc.getChatRoomBloc(blocId, partnerId);

    // false lint
    final userBloc = this.userBloc;
    final partnerData = await matchBloc.getUser(partnerId);

    if (bloc == null || partnerData == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => CurrentUser.passOverUser(
          bloc: userBloc,
          child: ChatRoom(
            bloc: bloc,
            partner: partnerData,
          ),
        ),
      ),
    );
  }

  showMatchScreen(String partner, chatId) async {
    final partnerData = await matchBloc.getUser(partner);

    // false lint
    final userBloc = this.userBloc;

    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (c) => CurrentUser.passOverUser(
          bloc: userBloc,
          child: MatchScreen(
            partnerData: partnerData,
            openChat: chatId != null ? () => openChat(partner, chatId) : null,
          ),
        ),
      ),
    );
  }

  onLaunch(Map<String, dynamic> data) async {
    final message = NotificationData.fromMap(data);
    if (!message.valid) return;
    switch (message.type) {
      case NotificationType.message:
        openChat(message.from, message.chatId);
        return;
      case NotificationType.match:
        showMatchScreen(message.from, message.chatId);
        break;
    }
  }

  @override
  void initState() {
    super.initState();

    FirebaseMessaging().configure(
      onResume: (data) => onLaunch(data),
      onLaunch: (data) => onLaunch(data),
      onMessage: (data) async {
        final message = NotificationData.fromMap(data);
        if (!message.valid) return;

        final userId = CurrentUser.of(context).user.uid;

        switch (message.type) {
          case NotificationType.message:
            if (message.from != userId)
              widget.navBarKey.currentState.incrementNotificationCount();
            return;
          case NotificationType.match:
            if (message.lastSwipe == userId) {
              showMatchScreen(message.from, message.chatId);
              return;
            }
            widget.navBarKey.currentState.incrementNotificationCount();
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
