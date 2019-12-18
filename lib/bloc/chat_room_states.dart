import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/data_classes/chat_message.dart';

abstract class ChatRoomEvent {}

class MessagesLoadedEvent extends ChatRoomEvent {
  final List<ChatMessage> messages;
  final DocumentSnapshot lastDoc;
  final bool newMessages;

  MessagesLoadedEvent(this.messages, this.lastDoc, [this.newMessages = false]);
}

class ChatRoomState {
  final bool loading;
  final List<ChatMessage> messages;
  final DocumentSnapshot lastDoc;

  ChatRoomState({this.loading, this.messages, this.lastDoc});

  factory ChatRoomState.init() => ChatRoomState(loading: true);

  ChatRoomState update({
    List<ChatMessage> messages,
    DocumentSnapshot lastDoc,
  }) =>
      ChatRoomState(
        messages: messages ?? this.messages,
        lastDoc: lastDoc ?? this.lastDoc,
        loading: this.messages == null && messages == null,
      );
}
