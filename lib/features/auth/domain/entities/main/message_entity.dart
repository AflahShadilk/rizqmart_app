import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final String senderRole; // 'user' or 'admin'
  final bool isRead;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.senderRole = 'user',
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, senderId, text, timestamp, senderRole, isRead];
}
