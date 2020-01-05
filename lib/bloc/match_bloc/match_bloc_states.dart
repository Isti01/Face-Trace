import 'package:face_app/bloc/data_classes/user.dart';

class MatchState {
  final List<String> uidList;
  final bool loadingUserList;
  final Map<String, User> users;
  final bool failed;
  MatchState({
    this.uidList,
    this.loadingUserList = true,
    this.users,
    this.failed = false,
  });

  factory MatchState.init() => MatchState(users: {});

  MatchState update({List<String> uidList, Map<String, User> users}) =>
      MatchState(
        uidList: uidList ?? this.uidList,
        users: users ?? this.users,
        loadingUserList: loadingUserList && uidList == null,
      );

  factory MatchState.failedLoading() => MatchState(users: {}, failed: true);

  @override
  String toString() {
    return 'AppState{ userList: $uidList}';
  }
}

abstract class MatchEvent {}

class UserListUpdatedEvent extends MatchEvent {
  final List<String> uidList;

  UserListUpdatedEvent(this.uidList);
}

class UserLoadedEvent extends MatchEvent {
  final String uid;
  final User user;

  UserLoadedEvent({this.uid, this.user});
}

class UserSwipedEvent extends MatchEvent {
  final String uid;

  UserSwipedEvent(this.uid);
}

class LoadingUsersFailedEvent extends MatchEvent {}
