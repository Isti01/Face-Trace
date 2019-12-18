import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final DateTime createdAt;
  final String message;
  final String createdBy;
  final bool gotFromOther;

  ChatMessage({
    this.id,
    this.createdAt,
    this.message,
    this.createdBy,
    this.gotFromOther,
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
    );
  }

  @override
  String toString() {
    return 'ChatMessage{id: $id, createdAt: $createdAt, message: $message, createdBy: $createdBy, gotFromOther: $gotFromOther}';
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
