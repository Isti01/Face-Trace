import 'package:face_app/bloc/data_classes/chat.dart';
import 'package:face_app/bloc/data_classes/user.dart';

abstract class ChatEvent {}

class ChatsUpdatedEvent extends ChatEvent {
  final List<Chat> chats;

  ChatsUpdatedEvent(this.chats);
}

class FilterChangedEvent extends ChatEvent {
  final String filter;

  FilterChangedEvent(this.filter);
}

class ChatState {
  final bool loadingChats;
  final List<Chat> chats;
  final String filter;
  final List<Chat> filteredChats;

  ChatState({
    this.loadingChats,
    this.chats,
    this.filter = '',
    this.filteredChats,
  });

  factory ChatState.init({Map<String, User> partners}) => ChatState(
        loadingChats: true,
        chats: [],
      );

  @override
  String toString() {
    return 'ChatState{loadingChats: $loadingChats, chats: $chats, filter: $filter, filteredChats: $filteredChats}';
  }

  bool _containsFilter(Chat chat, filter) =>
      chat?.user?.name?.toLowerCase()?.contains(filter.toLowerCase());

  ChatState update({List<Chat> chats, String filter}) {
    final newFilter = (filter ?? this.filter) ?? '';
    final newChats = chats ?? this.chats;

    List<Chat> filteredChats;

    if (filter != null || chats != null || this.filteredChats == null)
      filteredChats = newChats
          ?.where((chat) => _containsFilter(chat, newFilter) ?? false)
          ?.toList();

    return ChatState(
      chats: newChats,
      loadingChats: chats == null && this.chats == null,
      filter: newFilter,
      filteredChats: filteredChats ?? this.filteredChats,
    );
  }
}
