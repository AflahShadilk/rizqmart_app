import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitiateChatEvent extends ChatEvent {
  final String userId;
  final String sellerId;
  final String orderId;

  const InitiateChatEvent({
    required this.userId,
    required this.sellerId,
    required this.orderId,
  });

  @override
  List<Object?> get props => [userId, sellerId, orderId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String content;

  const SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object?> get props => [chatId, senderId, content];
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadMessagesEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
