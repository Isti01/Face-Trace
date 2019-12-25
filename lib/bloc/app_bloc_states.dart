import 'package:face_app/bloc/data_classes/app_color.dart';
import 'package:face_app/bloc/data_classes/user.dart';

class AppState {
  final AppColor color;
  final List<String> uidList;
  final bool loadingUserList;
  final Map<String, User> users;

  AppState({
    this.color,
    this.uidList,
    this.loadingUserList = true,
    this.users,
  });

  factory AppState.init({AppColor color}) => AppState(users: {}, color: color);

  AppState update({
    AppColor color,
    List<String> userList,
    Map<String, User> users,
  }) =>
      AppState(
        color: color ?? this.color,
        uidList: userList ?? this.uidList,
        users: users ?? this.users,
        loadingUserList: loadingUserList && userList == null,
      );

  @override
  String toString() {
    return 'AppState{color: $color, userList: $uidList}';
  }
}

abstract class AppEvent {}

class UserListUpdatedEvent extends AppEvent {
  final List<String> uidList;

  UserListUpdatedEvent(this.uidList);
}

class UserLoadedEvent extends AppEvent {
  final String uid;
  final User user;

  UserLoadedEvent({this.uid, this.user});
}
