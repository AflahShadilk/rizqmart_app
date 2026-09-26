import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/message_entity.dart';

/// Base abstract class representing the current chat context and message list state.
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
