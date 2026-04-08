import 'package:equatable/equatable.dart';

/// Entity defining a single message within a customer support chat thread.
class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final String senderRole; 
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
