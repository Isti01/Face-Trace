import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final DateTime createdAt;
  final String message;
  final String createdBy;
  final bool gotFromOther;
  final MessageType type;

  ChatMessage({
    this.id,
    this.createdAt,
    this.message,
    this.createdBy,
    this.gotFromOther,
    this.type = MessageType.text,
  });

  factory ChatMessage.fromMap({
    Map<String, dynamic> map,
    String docId,
    String uid,
  }) {
    final date = map['createdAt'];
    DateTime createdAt;
    if (date is Timestamp) createdAt = date.toDate();

    final createdBy = map['createdBy'];

    return ChatMessage(
        id: docId,
        createdAt: createdAt,
        createdBy: createdBy,
        gotFromOther: uid != createdBy,
        message: map['message'] ?? '',
        type: MessageTypeExtension.parse(map['type']));
  }

  @override
  String toString() {
    return 'ChatMessage{id: $id, createdAt: $createdAt, message: $message, createdBy: $createdBy, gotFromOther: $gotFromOther, type: $type}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum MessageType { text, image }

extension MessageTypeExtension on MessageType {
  static MessageType parse(source) {
    switch (source) {
      case 'image':
        return MessageType.image;
      default:
        return MessageType.text;
    }
  }
}
