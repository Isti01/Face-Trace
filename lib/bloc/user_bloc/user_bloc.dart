import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/bloc/firebase/upload_image.dart';
import 'package:face_app/bloc/user_bloc/user_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class UserBloc extends Bloc<UserEvent, User> {
  StreamSubscription authSubscription;
  StreamSubscription dataSubscription;

  UserBloc() {
    authSubscription = auth.onAuthStateChanged.listen(
      _newUser,
      cancelOnError: false,
    );
  }

  _newUser(FirebaseUser user) async {
    add(NewUserEvent(user));

    await dataSubscription?.cancel();
    dataSubscription = null;

    if (user == null) return;

    dataSubscription = streamUserData(user).listen(
      (doc) => add(UserDataUpdated(doc)),
      cancelOnError: false,
    );
    await uploadToken(user);

    await uploadLocation(user);
  }

  @override
  User get initialState => User(initial: true);

  @override
  Stream<User> mapEventToState(UserEvent event) async* {
    if (event is NewUserEvent &&
        (state.user != event.newUser || event.newUser == null)) {
      yield User(user: event.newUser);
    } else if (event is UserDataUpdated) {
      yield User.fromMap(
        event.userData.data,
        event.userData.documentID,
        state.user,
      );
    }
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print([error, stacktrace]);
    super.onError(error, stacktrace);
  }

  @override
  Future<void> close() async {
    await authSubscription?.cancel();
    await dataSubscription?.cancel();
    return super.close();
  }

  bool fieldChanged(dynamic data, String field) {
    final uid = state.user.uid;
    if (uid == null || data == null) return false;
    getUserDocument(uid).updateData({field: data});
    return true;
  }

  void addToGallery() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image == null || !await image.exists()) return;
    final user = state.user;
    if (user?.uid == null) return;
    final url = await uploadPhoto(user, image.path, 'galleries/${user.uid}');

    getUserDocument(user.uid).updateData({
      'images': FieldValue.arrayUnion([url]),
    });
  }
}
