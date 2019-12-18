import 'package:face_app/bloc/data_classes/user.dart';

class Chat {
  final List<String> uids;
  final User user;
  final String chatId;

  Chat({
    this.uids,
    this.user,
    this.chatId,
  });

  factory Chat.fromMap(
    Map<String, dynamic> map, {
    String chatId,
    User user,
    List<String> uids,
  }) =>
      Chat(
        user: user,
        chatId: chatId,
        uids: uids ?? uidsFromMap(map),
      );

  static List<String> uidsFromMap(Map<String, dynamic> map) {
    try {
      final usersMap = Map<String, dynamic>.from(map['users']);
      return usersMap.keys.where((key) {
        final val = usersMap[key];
        return val is bool && val;
      }).toList();
    } catch (e, s) {
      print([e, s]);
      return [];
    }
  }

  @override
  String toString() {
    return 'Chat{uids: $uids, users: $user, chatId: $chatId}';
  }
}
