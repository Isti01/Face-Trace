import 'package:face_app/bloc/chat_room_bloc/chat_room_bloc.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/chat_page/chat_room/chat_app_bar.dart';
import 'package:face_app/home/chat_page/chat_room/chat_room_body.dart';
import 'package:face_app/home/chat_page/chat_room/text_input_bar.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/dynamic_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoom extends StatefulWidget {
  final ChatRoomBloc bloc;
  final User partner;

  const ChatRoom({Key key, this.bloc, this.partner}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    if ((widget.bloc.state.messages?.isEmpty ?? true))
      widget.bloc.nextMessages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = CurrentUser.of(context).user;
    final color = user.appColor;

    return AnimatedTheme(
      data: ThemeData(primarySwatch: color.color),
      child: BlocProvider.value(
        value: widget.bloc,
        child: Scaffold(
          body: DynamicGradientBackground(
            color: user.appColor,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ChatRoomBody(
                    partner: widget.partner,
                    bloc: widget.bloc,
                    controller: _controller,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: TextInputBar(
                    sendImage: widget.bloc.sendImage,
                    onSubmitted: widget.bloc.sendMessage,
                    scrollController: _controller,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: ChatAppBar(partner: widget.partner),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
