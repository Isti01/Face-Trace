import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:face_app/bloc/register_bloc_states.dart';
import 'package:face_app/util/run_face_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

final Firestore firestore = Firestore.instance;
final CloudFunctions functions = CloudFunctions(region: 'europe-west1');
final FirebaseStorage storage = FirebaseStorage.instance;

CollectionReference get users => firestore.collection('users');

DocumentReference getUserDocument(FirebaseUser user) =>
    users.document(user.uid);

Future<bool> saveUserData(FirebaseUser user, RegisterState state) async {
  try {
    final faceData =
        await runFaceModel(state.facePhoto, state.userFace.boundingBox);

    final imageFile = File(state.facePhoto);
    final imageReference = storage.ref().child(
          'images/${user.uid}/${path.basename(imageFile.path)}',
        );
    await imageReference.putFile(imageFile).onComplete;

    final photoUrl = await imageReference.getDownloadURL();

    final updateInfo = UserUpdateInfo()
      ..photoUrl = photoUrl
      ..displayName = state.name;

    await Future.wait([
      user.updateProfile(updateInfo),
      getUserDocument(user).setData({
        if (state.name != null && state.name.isNotEmpty) "name": state.name,
        "gender": clearEnum(state.gender.toString()),
        "appColor": clearEnum(state.color.toString()),
        "interests":
            state.interests.map((s) => s.toString()).map(clearEnum).toList(),
        if (state.description != null && state.description.isNotEmpty)
          "description": state.description,
        "birthDate": state.birthDate.millisecondsSinceEpoch,
        "createdAt": FieldValue.serverTimestamp(),
        "faceData": faceData,
        "profileImage": photoUrl,
      }),
    ]);
    return true;
  } catch (e, s) {
    print([e, s]);
    return false;
  }
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
    getUserDocument(user).get();

clearEnum(String enumString) =>
    enumString.substring(enumString.indexOf(".") + 1);
