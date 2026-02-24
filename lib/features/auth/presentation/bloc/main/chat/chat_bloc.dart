import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/services/notification_service.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/chat/get_messages_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/chat/initiate_chat_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/chat/send_message_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CreateChatRoomUseCase createChatRoomUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatBloc({
    required this.createChatRoomUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitialState()) {
    on<CreateChatRoomEvent>(_onCreateChatRoom);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onCreateChatRoom(
    CreateChatRoomEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());
    final token = await NotificationService().getDeviceToken();

    final result = await createChatRoomUseCase(
      orderId: event.orderId,
      userId: event.userId,
      adminId: event.adminId,
      productId: event.productId,
      productName: event.productName,
      productImage: event.productImage,
      userFcmToken: token,
    );

    result.fold(
      (failure) => emit(ChatErrorState(failure.message)),
      (chatId) {
        emit(ChatInitiatedState(chatId)); 
        add(LoadMessagesEvent(chatId));
      },
    );
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    await emit.forEach(
      getMessagesUseCase(event.chatId),
      onData: (result) {
        return result.fold(
          (failure) => ChatErrorState(failure.message),
          (messages) => ChatMessagesLoadedState(messages),
        );
      },
      onError: (error, stackTrace) => ChatErrorState(error.toString()),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final result = await sendMessageUseCase(
      chatId: event.chatId,
      senderId: event.senderId,
      text: event.text,
      senderRole: event.senderRole,
    );

    result.fold(
      (failure) => emit(ChatErrorState('Failed to send message: ${failure.message}')),
      (_) {
        // Message sent successfully, no state change needed as stream handles updates.
      },
    );
  }
}
