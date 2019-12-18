import 'package:face_app/bloc/data_classes/chat.dart';
import 'package:face_app/bloc/data_classes/chat_message.dart';
import 'package:face_app/bloc/data_classes/user.dart';

abstract class ChatEvent {}

class ChatsUpdatedEvent extends ChatEvent {
  final List<Chat> chats;

  ChatsUpdatedEvent(this.chats);
}

class ChatMessagesUpdatedEvent extends ChatEvent {
  final String chatId;
  final List<ChatMessage> messages;

  ChatMessagesUpdatedEvent({this.chatId, this.messages});

  @override
  String toString() {
    return 'ChatMessagesUpdatedEvent{chatId: $chatId, messages: $messages}';
  }
}

class ChatState {
  final bool loadingChats;
  final List<Chat> chats;

  ChatState({
    this.loadingChats,
    this.chats,
  });

  factory ChatState.init({Map<String, User> partners}) => ChatState(
        loadingChats: true,
        chats: [],
      );

  @override
  String toString() {
    return 'ChatState{loadingChats: $loadingChats, chats: $chats}';
  }

  ChatState update({List<Chat> chats}) => ChatState(
        chats: chats ?? this.chats,
        loadingChats: chats == null && this.chats == null,
      );
}
