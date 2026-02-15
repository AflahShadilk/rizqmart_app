import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/services/notification_service.dart';
import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/chat/get_messages_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/chat/initiate_chat_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/chat/send_message_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CreateChatRoomUseCase createChatRoomUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  ChatBloc({
    required this.createChatRoomUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitialState()) {
    on<CreateChatRoomEvent>(_onCreateChatRoom);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<_UpdateMessagesEvent>(_onUpdateMessages);
  }

  void _onUpdateMessages(_UpdateMessagesEvent event, Emitter<ChatState> emit) {
    emit(ChatMessagesLoadedState(event.messages));
  }

  Future<void> _onCreateChatRoom(
    CreateChatRoomEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());
    try {
      final token = await NotificationService().getDeviceToken();

      final chatId = await createChatRoomUseCase(
        orderId: event.orderId,
        userId: event.userId,
        adminId: event.adminId,
        productId: event.productId,
        productName: event.productName,
        productImage: event.productImage,
        userFcmToken: token,
      );
      emit(ChatInitiatedState(chatId)); // chatId == orderId
      add(LoadMessagesEvent(chatId));
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
        text: event.text,
        senderRole: event.senderRole,
      );
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
