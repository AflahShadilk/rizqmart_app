import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.text,
    required super.timestamp,
    super.senderRole,
    super.isRead,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  return MessageModel(
    id: doc.id,
    senderId: data['senderId'] ?? '',
    text: data['text'] ?? '',
    timestamp: data['timestamp'] != null
        ? (data['timestamp'] as Timestamp).toDate()
        : DateTime.now(),
    senderRole: data['senderRole'] ?? 'user',
    isRead: data['isRead'] ?? false,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'senderRole': senderRole,
      'isRead': isRead,
    };
  }
}
