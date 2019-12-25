import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/app_bloc.dart';
import 'package:face_app/bloc/chat_bloc_states.dart';
import 'package:face_app/bloc/chat_room_bloc.dart';
import 'package:face_app/bloc/data_classes/chat.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseUser user;
  StreamSubscription chatStream;
  final AppBloc appBloc;
  final Map<String, ChatRoomBloc> chatRooms = {};

  ChatBloc({this.user, @required this.appBloc}) {
    chatStream = getChats(user).listen(
      _onChatsLoaded,
      onError: (e, s) => print([e, s]),
    );
  }

  _onChatsLoaded(QuerySnapshot snapshot) async {
    final chatRooms =
        await Observable.fromIterable(snapshot.documents).asyncMap((doc) async {
      final map = Map<String, dynamic>.from(doc.data);
      final uids = Chat.uidsFromMap(map);
      final partner = uids.firstWhere((uid) => uid != user.uid);

      return Chat.fromMap(
        map,
        chatId: doc.documentID,
        user: await appBloc.getUser(partner),
      );
    }).toList();
    _updateBlocs(snapshot.documentChanges);
    add(ChatsUpdatedEvent(chatRooms));
  }

  _updateBlocs(List<DocumentChange> changes) {
    for (var change in changes) {
      final docId = change.document.documentID;

      switch (change.type) {
        case DocumentChangeType.added:
          chatRooms[docId] = ChatRoomBloc(user: user, chatRoomId: docId);
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
