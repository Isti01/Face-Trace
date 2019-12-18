import 'package:face_app/bloc/chat_room_bloc.dart';
import 'package:face_app/bloc/chat_room_states.dart';
import 'package:face_app/home/chat/chat_bubble.dart';
import 'package:face_app/home/chat/text_input_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoom extends StatefulWidget {
  final ChatRoomBloc bloc;

  const ChatRoom({
    Key key,
    this.bloc,
  }) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    if (widget.bloc.state.messages?.isEmpty ?? true) widget.bloc.nextMessages();

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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatRoomBloc, ChatRoomState>(
              bloc: widget.bloc,
              builder: (context, state) {
                if (state.loading)
                  return Center(child: CircularProgressIndicator());
                final messages = state.messages;

                if (messages?.isEmpty ?? true)
                  return Text('nincs uzenet'); //todo add something better
                final length = messages.length;

                _checkIfHasEnoughMessage();

                return NotificationListener(
                  child: ListView.builder(
                    controller: _controller,
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: length,
                    itemBuilder: (c, i) => ChatBubble(
                      message: messages[i],
                      includeName: i == length - 1 ||
                          messages[i + 1].createdBy != messages[i].createdBy,
                    ),
                  ),
                  onNotification: (notification) {
                    if (notification is ScrollEndNotification) {
                      widget.bloc.nextMessages();
                      return true;
                    }

                    return false;
                  },
                );
              },
            ),
          ),
          TextInputBar(onSubmitted: widget.bloc.sendMessage)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
