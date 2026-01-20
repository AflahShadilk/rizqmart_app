import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/chat/message_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatInitiatedState extends ChatState {
  final String chatId;

  const ChatInitiatedState(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ChatMessagesLoadedState extends ChatState {
  final List<MessageEntity> messages;

  const ChatMessagesLoadedState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatErrorState extends ChatState {
  final String message;

  const ChatErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
