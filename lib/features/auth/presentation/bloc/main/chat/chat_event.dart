import 'package:equatable/equatable.dart';
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class CreateChatRoomEvent extends ChatEvent {
  final String orderId;
  final String userId;
  final String adminId;
  final String? productId;
  final String? productName;
  final String? productImage;

  const CreateChatRoomEvent({
    required this.orderId,
    required this.userId,
    this.adminId = 'admin',
    this.productId,
    this.productName,
    this.productImage,
  });

  @override
  List<Object?> get props => [orderId, userId, adminId, productId, productName, productImage];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String senderId;
  final String text;
  final String senderRole;

  const SendMessageEvent({
    required this.chatId,
    required this.senderId,
    required this.text,
    this.senderRole = 'user',
  });

  @override
  List<Object?> get props => [chatId, senderId, text, senderRole];
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadMessagesEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
