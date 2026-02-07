import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final String type; // 'text', 'image', etc.
  final bool isRead;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.type = 'text',
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, senderId, content, timestamp, type, isRead];
}
