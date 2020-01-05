import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_app/bloc/chat_room_bloc/chat_room_bloc.dart';
import 'package:face_app/bloc/chat_room_bloc/chat_room_states.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/chat_page/chat_room/message_list.dart';
import 'package:face_app/home/chat_page/chat_room/text_input_bar.dart';
import 'package:face_app/util/current_user.dart';
import 'package:face_app/util/dynamic_gradient.dart';
import 'package:face_app/util/transparent_appbar.dart';
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

  _checkIfHasEnoughMessage() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.position.viewportDimension <
            _controller.position.maxScrollExtent) return;

        widget.bloc.nextMessages();
      });

  @override
  Widget build(BuildContext context) {
    final user = CurrentUser.of(context).user;
    final color = user.appColor;
    final textTheme = Theme.of(context).textTheme;

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
                  child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
                    builder: (context, state) {
                      if (!state.hasMessages) return progressIndicator;
                      final messages = state.messages;

                      if (messages?.isEmpty ?? true)
                        return Text('nincs uzenet'); //todo add something better

                      _checkIfHasEnoughMessage();

                      return MessageList(
                        //make it sliver
                        partner: widget.partner,
                        loading: state.loading,
                        controller: _controller,
                        messages: messages,
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: TextInputBar(
                    onSubmitted: widget.bloc.sendMessage,
                    scrollController: _controller,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: TransparentAppBar(
                    color: Colors.white10,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.partner?.profileImage != null) ...[
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              widget.partner.profileImage,
                            ),
                          ),
                          SizedBox(width: 12),
                        ],
                        if (widget.partner?.name != null)
                          Text(
                            widget.partner.name,
                            style: textTheme.title.apply(color: Colors.white),
                          )
                      ],
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static get progressIndicator => Center(child: CircularProgressIndicator());

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
