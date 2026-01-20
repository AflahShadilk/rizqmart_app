import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/chat/message_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/chat/get_messages_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/chat/initiate_chat_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/chat/send_message_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/chat/chat_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final InitiateChatUseCase initiateChatUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  ChatBloc({
    required this.initiateChatUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitialState()) {
    on<InitiateChatEvent>(_onInitiateChat);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<_UpdateMessagesEvent>(_onUpdateMessages);
  }

  void _onUpdateMessages(_UpdateMessagesEvent event, Emitter<ChatState> emit) {
    emit(ChatMessagesLoadedState(event.messages));
  }

  Future<void> _onInitiateChat(
    InitiateChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());
    try {
      final chatId = await initiateChatUseCase(
        userId: event.userId,
        sellerId: event.sellerId,
        orderId: event.orderId,
      );
      emit(ChatInitiatedState(chatId));
      add(LoadMessagesEvent(chatId)); // Automatically start loading messages
    } catch (e) {
      emit(ChatErrorState(e.toString()));
    }
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _messagesSubscription?.cancel();
    _messagesSubscription = getMessagesUseCase(event.chatId).listen(
      (messages) {
        add(_UpdateMessagesEvent(messages));
      },
      onError: (error) {
         // handle stream error if needed, for now locally we could emit invalid state 
         // but since we are inside a listener helper, we need a special internal event
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await sendMessageUseCase(
        chatId: event.chatId,
        senderId: event.senderId,
        content: event.content,
      );
      // No need to emit state, the stream will update automatically
    } catch (e) {
      emit(ChatErrorState('Failed to send message: ${e.toString()}'));
    }
  }

    @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}

// Internal event to handle stream updates
class _UpdateMessagesEvent extends ChatEvent {
  final List<MessageEntity> messages;
  const _UpdateMessagesEvent(this.messages);
}


