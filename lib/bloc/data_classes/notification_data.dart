class NotificationData {
  final String title;
  final String body;
  final String from;
  final String lastSwipe;
  final String chatId;
  final NotificationType type;

  NotificationData({
    this.title,
    this.body,
    this.from,
    this.type,
    this.lastSwipe,
    this.chatId,
  });

  bool get valid =>
      from != null &&
      type != null &&
      ((type == NotificationType.message && chatId != null) ||
          (type == NotificationType.match && lastSwipe != null));

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    try {
      final notification = map['notification'];
      final data = map['data'];

      return NotificationData(
        title: notification['title'],
        body: notification['body'],
        from: data['messageFrom'],
        lastSwipe: data['lastSwipe'],
        type: parseType(data['notificationType']),
        chatId: data['chatId'],
      );
    } catch (e, s) {
      print([e, s]);
      return NotificationData();
    }
  }

  static NotificationType parseType(String source) {
    if (source == 'chat_message') return NotificationType.message;
    if (source == 'match') return NotificationType.match;

    return null;
  }

  @override
  String toString() {
    return 'NotificationData{title: $title, body: $body, from: $from, lastSwipe: $lastSwipe, chatId: $chatId, type: $type}';
  }
}

enum NotificationType { message, match }
