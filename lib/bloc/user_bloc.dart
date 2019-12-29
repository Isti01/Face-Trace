import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/bloc/user_event.dart';
import 'package:face_app/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

    if (user != null)
      dataSubscription = streamUserData(user).listen(
        (doc) => add(UserDataUpdated(doc)),
        cancelOnError: false,
      );
  }

  @override
  User get initialState => User(initial: true);

  @override
  Stream<User> mapEventToState(UserEvent event) async* {
    if (event is NewUserEvent &&
        (state.user != event.newUser || event.newUser == null)) {
      yield User(user: event.newUser);
    } else if (event is UserDataUpdated)
      yield User.fromMap(event.userData.data, state.user);
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

  bool fieldChanged(String text, String field) {
    final uid = state.user.uid;
    if (uid == null || text == null) return false;
    getUserDocument(uid).updateData({field: text});
    return true;
  }
}
