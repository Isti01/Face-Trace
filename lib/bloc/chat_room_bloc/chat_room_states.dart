import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/data_classes/chat_message.dart';

abstract class ChatRoomEvent {}

class MessagesLoadedEvent extends ChatRoomEvent {
  final List<ChatMessage> messages;
  final DocumentSnapshot lastDoc;
  final bool newMessages;

  MessagesLoadedEvent(this.messages, this.lastDoc, [this.newMessages = false]);
}

class LoadingMessagesEvent extends ChatRoomEvent {}

class AllMessagesLoaded extends ChatRoomEvent {}

class ChatRoomState {
  final bool hasMessages;
  final List<ChatMessage> messages;
  final DocumentSnapshot lastDoc;
  final bool loading;
  final bool loadedAll;

  ChatRoomState({
    this.hasMessages,
    this.messages,
    this.lastDoc,
    this.loadedAll,
    this.loading,
  });

  factory ChatRoomState.init() =>
      ChatRoomState(hasMessages: false, loadedAll: false, loading: true);

  ChatRoomState update({
    bool loadedAll,
    bool loading,
    List<ChatMessage> messages,
    DocumentSnapshot lastDoc,
  }) =>
      ChatRoomState(
        messages: messages ?? this.messages,
        lastDoc: lastDoc ?? this.lastDoc,
        loading: loading ?? this.loading,
        hasMessages: (messages ?? this.messages)?.isNotEmpty ?? false,
        loadedAll: loadedAll ?? this.loadedAll,
      );

  @override
  String toString() {
    return 'ChatRoomState{hasMessages: $hasMessages, messages: $messages, lastDoc: $lastDoc, loading: $loading, loadedAll: $loadedAll}';
  }
}
