import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/chat_room_bloc/chat_room_states.dart';
import 'package:face_app/bloc/data_classes/chat_message.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart' as db;
import 'package:face_app/bloc/firebase/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final FirebaseUser user;
  final String chatRoomId;
  final String partner;
  StreamSubscription newMessagesStream;
  final now = DateTime.now();

  ChatRoomBloc({this.user, this.chatRoomId, this.partner}) {
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

  sendMessage(String message) =>
      db.sendMessage(chatRoomId, message, partner, user);

  sendImage(ImageSource source) async {
    final image = await ImagePicker.pickImage(source: source);
    if (image == null || !await image.exists()) return;

    final url = await uploadPhoto(user, image.path, 'chats/${user.uid}');
    db.sendMessage(chatRoomId, url, partner, user, 'image');
  }

  nextMessages() async {
    if (state.loadedAll || (state.loading ?? false)) return;

    add(LoadingMessagesEvent());

    final snapshot = await db.getMessages(chatRoomId, state.lastDoc, now);

    final last = snapshot.documents.isNotEmpty ? snapshot.documents.last : null;

    if (last == null) {
      add(AllMessagesLoaded());
      return;
    }
    final messages = parseDocs(snapshot);

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
        loading: false,
        messages: messages.toList(),
      );
      if (event.lastDoc != null)
        newState = newState.update(lastDoc: event.lastDoc);
    } else if (event is LoadingMessagesEvent) {
      newState = state.update(loading: true);
    } else if (event is AllMessagesLoaded) {
      newState = state.update(loadedAll: true, loading: false);
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
