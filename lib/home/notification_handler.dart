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
  var lastMessage;

  ChatBloc get chatBloc => BlocProvider.of<ChatBloc>(context);

  MatchBloc get matchBloc => BlocProvider.of<MatchBloc>(context);

  UserBloc get userBloc => BlocProvider.of<UserBloc>(context);

  openChat(String blocId, [bool replace = false]) async {
    // false lint
    final bloc = await chatBloc.getChatRoomBloc(blocId);
    if (bloc == null) {
      Navigator.pop(context);
      return;
    }
    // false lint
    final userBloc = this.userBloc;
    final partnerData = await matchBloc.getUser(bloc.partner);

    if (bloc == null || partnerData == null) return;

    final route = MaterialPageRoute(
      builder: (c) => CurrentUser.passOverUser(
        bloc: userBloc,
        child: ChatRoom(
          bloc: bloc,
          partner: partnerData,
        ),
      ),
    );

    if (replace)
      Navigator.pushReplacement(context, route);
    else
      Navigator.push(context, route);
  }

  showMatchScreen(String partner, String chatId) async {
    final partnerData = await matchBloc.getUser(partner);

    if (partnerData == null) return;

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
            openChat: chatId != null ? () => openChat(chatId, true) : null,
          ),
        ),
      ),
    );
  }

  onLaunch(Map<String, dynamic> data) async {
    if (lastMessage == data) return;
    lastMessage = data;
    final message = NotificationData.fromMap(data);
    if (!message.valid) return;
    switch (message.type) {
      case NotificationType.message:
        openChat(message.chatId);
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
      onLaunch: (data) => onLaunch(data),
      onResume: (data) => onLaunch(data),
      onMessage: (data) async {
        print(data);
        if (lastMessage == data) return;
        lastMessage = data;

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
