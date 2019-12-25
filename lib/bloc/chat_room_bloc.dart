import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/chat_room_states.dart';
import 'package:face_app/bloc/data_classes/chat_message.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart' as db;
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final FirebaseUser user;
  final String chatRoomId;
  bool loading = false;
  StreamSubscription newMessagesStream;
  final now = DateTime.now();

  ChatRoomBloc({this.user, this.chatRoomId}) {
    newMessagesStream = db
        .getNewMessages(chatRoomId, now)
        .listen(_onNewMessage, onError: print);
  }

  @override
  ChatRoomState get initialState => ChatRoomState.init();

  _onNewMessage(QuerySnapshot snapshot) {
    final last = snapshot.documents.isNotEmpty ? snapshot.documents.last : null;

    add(MessagesLoadedEvent(parseDocs(snapshot), last, true));
  }

  sendMessage(String message) => db.sendMessage(chatRoomId, message, user);

  nextMessages() async {
    if (loading) return;
    loading = true;
    final snapshot = await db.getMessages(chatRoomId, state.lastDoc, now);

    final last = snapshot.documents.isNotEmpty ? snapshot.documents.last : null;
    final messages = parseDocs(snapshot);
    loading = false;
    add(MessagesLoadedEvent(messages, last));
  }

  List<ChatMessage> parseDocs(QuerySnapshot snapshot) =>
      snapshot.documentChanges
          .where((change) => change.type == DocumentChangeType.added)
          .map((doc) => ChatMessage.fromMap(
                map: doc.document.data,
                uid: user.uid,
                docId: doc.document.documentID,
              ))
          .toList()
            ..sort((m1, m2) => m2.createdAt.compareTo(m1.createdAt));

  @override
  Stream<ChatRoomState> mapEventToState(ChatRoomEvent event) async* {
    ChatRoomState newState;

    if (event is MessagesLoadedEvent) {
      final messages = <ChatMessage>{};

      if (event.newMessages) messages.addAll(event.messages);
      if (state.messages != null) messages.addAll(state.messages);
      if (!event.newMessages) messages.addAll(event.messages);

      newState = state.update(
        messages: messages.toList(),
      );
      if (event.lastDoc != null)
        newState = newState.update(lastDoc: event.lastDoc);
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
    try {
      newMessagesStream?.cancel();
    } catch (e, s) {
      print([e, s]);
    }
    return super.close();
  }
}
