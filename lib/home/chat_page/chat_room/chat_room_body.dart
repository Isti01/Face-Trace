import 'package:face_app/bloc/chat_room_bloc/chat_room_bloc.dart';
import 'package:face_app/bloc/chat_room_bloc/chat_room_states.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/home/chat_page/chat_room/message_list.dart';
import 'package:face_app/localizations/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomBody extends StatelessWidget {
  final User partner;
  final ChatRoomBloc bloc;
  final ScrollController controller;

  const ChatRoomBody({
    Key key,
    this.partner,
    this.bloc,
    this.controller,
  }) : super(key: key);

  _checkIfHasEnoughMessage() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.position.viewportDimension <
            controller.position.maxScrollExtent) return;

        bloc.nextMessages();
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomBloc, ChatRoomState>(
      builder: (context, state) {
        if (!state.hasMessages && state.loading)
          return Center(child: CircularProgressIndicator());
        final messages = state.messages;

        if (messages?.isEmpty ?? true) return _noMessages(context);

        _checkIfHasEnoughMessage();

        return MessageList(
          //make it sliver
          partner: partner,
          loading: state.loading,
          controller: controller,
          messages: messages,
        );
      },
    );
  }

  Widget _noMessages(context) => Center(
        child: Text(
          AppLocalizations.of(context).sendTheFirstMessage,
          style: Theme.of(context).textTheme.title.apply(color: Colors.white),
        ),
      );
}
