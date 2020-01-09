import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:face_app/bloc/match_bloc/match_bloc_states.dart';

const NumDisplayedUsers = 3;

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc() {
    getUsers();
  }

  getUsers() async {
    bool successful = false;

    await Connectivity()
        .onConnectivityChanged
        .where((event) => event != ConnectivityResult.none)
        .first
        .then((_) async {
      final userList = await getUserList();
      add(UserListUpdatedEvent(userList));
      userList.getRange(0, math.min(5, userList.length)).forEach(loadUser);

      successful = true;
    }).catchError((e, s) => print([e, s]));

    if (!successful) add(LoadingUsersFailedEvent());
  }

  Future<User> getUser(String uid) async {
    if (await loadUser(uid)) return this.state.users[uid];
    return this
        .where((state) => state.users[uid] != null)
        .map((state) => state.users[uid])
        .first;
  }

  Future<bool> loadUser(String uid) async {
    if (state.users[uid] != null) return true;

    final data = await getUserDocument(uid).get();
    add(UserLoadedEvent(
      user: User.fromMap(data.data, data.documentID),
      uid: uid,
    ));
    return false;
  }

  @override
  MatchState get initialState => MatchState.init();

  @override
  Stream<MatchState> mapEventToState(MatchEvent event) async* {
    MatchState newState;

    if (event is UserListUpdatedEvent) {
      newState = state.update(uidList: event.uidList);
    } else if (event is UserLoadedEvent) {
      final map = state.users;
      map[event.uid] = event.user;
      newState = state.update(users: map);
    } else if (event is UserSwipedEvent) {
      newState = state.update(uidList: state.uidList..remove(event.uid));
    } else if (event is LoadingUsersFailedEvent) {
      newState = MatchState.failedLoading();
    }

    if (newState == null)
      throw UnimplementedError('${event.runtimeType} was not mapped to state');
    yield newState;
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    super.onError(error, stacktrace);
    print([error, stacktrace]);
  }

  onSwiped(bool right, String uid) {
    final uids = state.uidList;
    final index = uids.indexOf(uid);
    if (index == -1) return;
    add(UserSwipedEvent(uid));

    final newIndex = index + 1;

    if (newIndex >= uids.length) return;
    uids
        .getRange(newIndex, math.min(newIndex + NumDisplayedUsers, uids.length))
        .forEach(loadUser);

    swipeUser(uid: uid, right: right);
  }
}
