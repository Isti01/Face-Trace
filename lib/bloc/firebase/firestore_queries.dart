import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:face_app/bloc/firebase/run_face_model.dart';
import 'package:face_app/bloc/firebase/upload_image.dart';
import 'package:face_app/bloc/register_bloc/register_bloc_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final Firestore firestore = Firestore.instance;
final CloudFunctions functions = CloudFunctions(region: 'europe-west1');
final FirebaseStorage storage = FirebaseStorage.instance;

FirebaseAuth auth = FirebaseAuth.instance;

CollectionReference get users => firestore.collection('users');

CollectionReference get chats => firestore.collection('chats');

CollectionReference get swipes => firestore.collection('swipes');

CollectionReference get faces => firestore.collection('faces');

DocumentReference getUserDocument(String uid) => users.document(uid);

Future<void> saveUserData(FirebaseUser user, RegisterState state) async {
  final faceData = await runFaceModel(
    state.facePhoto,
    state.userFace.boundingBox,
  ).catchError((e, s) {
    print([e, s]);
    return [];
  });

  final photoUrl = await uploadPhoto(
    user,
    state.facePhoto,
    'images/${user.uid}',
  );

  final updateInfo = UserUpdateInfo()
    ..photoUrl = photoUrl
    ..displayName = state.name;

  await Future.wait([
    user.updateProfile(updateInfo),
    getUserDocument(user.uid).setData({
      "name": state.name,
      "gender": clearEnum(state.gender.toString()),
      "appColor": clearEnum(state.color.toString()),
      "interests":
          state.interests.map((s) => s.toString()).map(clearEnum).toList(),
      "attractedTo":
          state.attractedTo.map((s) => s.toString()).map(clearEnum).toList(),
      "description": state.description,
      "birthDate": state.birthDate,
      "createdAt": FieldValue.serverTimestamp(),
      "profileImage": photoUrl,
    }),
    if (faceData?.isNotEmpty ?? false)
      faces.document(user.uid).setData({"faceData": faceData}),
  ]);
}

Future<List<String>> getUserList() async {
  try {
    final res = await functions
        .getHttpsCallable(
          functionName: 'getUserList',
        )
        .call();

    if (!res.data['successful']) return null;

    return List<String>.from(res.data['users']);
  } catch (e, s) {
    print([e, s]);
    return null;
  }
}

Future<DocumentSnapshot> getUserData(FirebaseUser user) =>
    getUserDocument(user.uid).get();

Stream<DocumentSnapshot> streamUserData(FirebaseUser user) =>
    getUserDocument(user.uid).snapshots();

clearEnum(String enumString) =>
    enumString.substring(enumString.indexOf(".") + 1);

Future<DocumentReference> swipeUser({String uid, bool right}) async {
  final currentUser = await auth.currentUser();

  return swipes.add({
    'swipedBy': currentUser.uid,
    'swipedUser': uid,
    'right': right,
  });
}

Future<DocumentReference> sendMessage(
  String chatId,
  String message,
  FirebaseUser user, [
  String type = 'text',
]) async {
  if (message?.trim()?.isEmpty ?? true) return null;
  return chats.document(chatId).collection('messages').add({
    'message': message,
    'createdAt': DateTime.now(),
    'createdBy': user.uid,
    'type': type
  });
}

Future<QuerySnapshot> getMessages(
  String chatRoomId,
  DocumentSnapshot lastDoc,
  DateTime now,
) {
  var query = chats
      .document(chatRoomId)
      .collection('messages')
      .where('createdAt', isLessThan: now)
      .orderBy('createdAt', descending: true);

  if (lastDoc != null) query = query.startAfterDocument(lastDoc);

  return query.limit(10).getDocuments();
}

Stream<QuerySnapshot> getNewMessages(String chatRoomId, DateTime now) => chats
    .document(chatRoomId)
    .collection('messages')
    .where('createdAt', isGreaterThan: now)
    .snapshots();

Stream<QuerySnapshot> getChats(FirebaseUser user) =>
    chats.where('users.${user.uid}', isEqualTo: true).snapshots();
