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
  final String partner;
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
    this.partner,
  });

  factory ChatRoomState.init() =>
      ChatRoomState(hasMessages: false, loadedAll: false, loading: true);

  ChatRoomState update({
    bool loadedAll,
    bool loading,
    List<ChatMessage> messages,
    DocumentSnapshot lastDoc,
    String partner,
  }) =>
      ChatRoomState(
        messages: messages ?? this.messages,
        lastDoc: lastDoc ?? this.lastDoc,
        loading: loading ?? this.loading,
        partner: partner ?? this.partner,
        hasMessages: (messages ?? this.messages)?.isNotEmpty ?? false,
        loadedAll: loadedAll ?? this.loadedAll,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoomState &&
          runtimeType == other.runtimeType &&
          partner == other.partner &&
          hasMessages == other.hasMessages &&
          messages == other.messages &&
          lastDoc == other.lastDoc &&
          loading == other.loading &&
          loadedAll == other.loadedAll;

  @override
  int get hashCode =>
      partner.hashCode ^
      hasMessages.hashCode ^
      messages.hashCode ^
      lastDoc.hashCode ^
      loading.hashCode ^
      loadedAll.hashCode;

  @override
  String toString() {
    return 'ChatRoomState{hasMessages: $hasMessages, messages: $messages, lastDoc: $lastDoc, loading: $loading, loadedAll: $loadedAll}';
  }
}
