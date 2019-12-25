import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:face_app/bloc/app_bloc_states.dart';
import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/user.dart';
import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppColor color;

  AppBloc({this.color = AppColor.green}) {
    getUsers();
  }

  getUsers() async {
    bool finished = false;
    int i = 0;
    while (i++ < 3 && !finished) {
      await Observable(Connectivity().onConnectivityChanged)
          .where((event) => event != ConnectivityResult.none)
          .first
          .then((_) async {
        final userList = await getUserList();
        add(UserListUpdatedEvent(userList));

        finished = true;

        userList.getRange(0, math.min(5, userList.length)).forEach(loadUser);
      }).catchError((e, s) => print([e, s]));
    }
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
    add(UserLoadedEvent(user: User.fromMap(data.data), uid: uid));
    return false;
  }

  @override
  AppState get initialState => AppState.init(color: color);

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    AppState newState;

    if (event is UserListUpdatedEvent) {
      newState = state.update(userList: event.uidList);
    } else if (event is UserLoadedEvent) {
      final map = state.users;
      map[event.uid] = event.user;
      newState = state.update(users: map);
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
}
