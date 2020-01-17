import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/chat_bloc/chat_bloc_states.dart';
import 'package:face_app/bloc/chat_room_bloc/chat_room_bloc.dart';
import 'package:face_app/bloc/data_classes/chat.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/bloc/match_bloc/match_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseUser user;
  StreamSubscription chatStream;
  final MatchBloc matchBloc;
  final Map<String, ChatRoomBloc> chatRooms = {};

  StreamSubscription searchSubscription;
  final BehaviorSubject<String> searchSubject = BehaviorSubject();

  ChatBloc({this.user, @required this.matchBloc}) {
    chatStream = getChats(user).listen(
      _onChatsLoaded,
      onError: (e, s) => print([e, s]),
    );

    searchSubscription = searchSubject
        .debounceTime(Duration(milliseconds: 250))
        .distinct()
        .listen((filter) => add(FilterChangedEvent(filter)));
  }

  _onChatsLoaded(QuerySnapshot snapshot) async {
    final chatRooms =
        await Stream.fromIterable(snapshot.documents).asyncMap((doc) async {
      final map = Map<String, dynamic>.from(doc.data);
      final uids = Chat.uidsFromMap(map);
      final partner = uids.firstWhere((uid) => uid != user.uid);

      return Chat.fromMap(
        map,
        chatId: doc.documentID,
        user: await matchBloc.getUser(partner),
      );
    }).toList();
    _updateBlocs(snapshot.documentChanges, chatRooms);
    add(ChatsUpdatedEvent(chatRooms));
  }

  Future<ChatRoomBloc> getChatRoomBloc(String id) async {
    final room = chatRooms[id];
    if (room != null) return room;
    final roomData = await getChatRoom(id);
    final data = roomData.data;
    if (!roomData.exists || (data?.isEmpty ?? true)) return null;

    final uids = Chat.uidsFromMap(data);
    final partner = uids.firstWhere((uid) => uid != user.uid);

    final chat = Chat.fromMap(
      data,
      chatId: id,
      user: await matchBloc.getUser(partner),
    );

    chatRooms[id] = ChatRoomBloc(user: user, chatRoomId: id, partner: partner);

    add(ChatsUpdatedEvent(<Chat>{...(state.chats ?? []), chat}.toList()));

    return chatRooms[id];
  }

  _updateBlocs(List<DocumentChange> changes, List<Chat> chats) {
    for (int i = 0; i < changes.length; i++) {
      final change = changes[i];
      final docId = change.document.documentID;

      switch (change.type) {
        case DocumentChangeType.added:
          if (chatRooms[docId] != null) continue;
          chatRooms[docId] = ChatRoomBloc(
            user: user,
            chatRoomId: docId,
            partner: chats[i].user.uid,
          );
          break;
        case DocumentChangeType.modified:
          break;
        case DocumentChangeType.removed:
          chatRooms[docId]?.close()?.whenComplete(
                () => chatRooms[docId] = null,
              );
          break;
      }
    }
  }

  @override
  ChatState get initialState => ChatState.init();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    ChatState newState;
    if (event is ChatsUpdatedEvent) {
      newState = state.update(chats: event.chats);
    } else if (event is FilterChangedEvent) {
      newState = state.update(filter: event.filter);
    }

    if (newState == null)
      throw UnimplementedError('${event.runtimeType} was not mapped to state');

    yield newState;
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print([error, stacktrace]);
    super.onError(error, stacktrace);
  }

  @override
  Future<void> close() async {
    await searchSubscription?.cancel();
    await searchSubject?.close();

    for (var entry in chatRooms.entries) {
      try {
        await entry.value?.close();
      } catch (e, s) {
        print([e, s]);
      }
    }
    chatStream?.cancel();
    return super.close();
  }
}
