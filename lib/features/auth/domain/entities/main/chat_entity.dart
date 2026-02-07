import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String userId;
  final String sellerId;
  final String orderId;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<String> participants;

  const ChatEntity({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.orderId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.participants,
  });

  @override
  List<Object?> get props => [id, userId, sellerId, orderId, lastMessage, lastMessageTime, participants];
}
