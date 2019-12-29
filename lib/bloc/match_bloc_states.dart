import 'package:face_app/bloc/data_classes/user.dart';

class MatchState {
  final List<String> uidList;
  final bool loadingUserList;
  final Map<String, User> users;
  final int lastIndex;

  MatchState({
    this.uidList,
    this.loadingUserList = true,
    this.users,
    this.lastIndex = 0,
  });

  factory MatchState.init() => MatchState(users: {});

  MatchState update({
    List<String> userList,
    Map<String, User> users,
    int lastIndex,
  }) =>
      MatchState(
          uidList: userList ?? this.uidList,
          users: users ?? this.users,
          loadingUserList: loadingUserList && userList == null,
          lastIndex: lastIndex ?? this.lastIndex);

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

class NewIndexEvent extends MatchEvent {
  final int newIndex;

  NewIndexEvent(this.newIndex);
}
