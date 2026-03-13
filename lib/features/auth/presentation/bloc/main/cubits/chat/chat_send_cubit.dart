import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_event.dart';
class ChatSendCubit extends Cubit<void> {
  final ChatBloc chatBloc;

  ChatSendCubit({required this.chatBloc}) : super(null);

  bool sendMessage({
    required String text,
    required String chatId,
    required String senderId,
    required String senderRole,
  }) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    chatBloc.add(SendMessageEvent(
      chatId: chatId,
      senderId: senderId,
      text: trimmed,
      senderRole: senderRole,
    ));
    return true;
  }
}
