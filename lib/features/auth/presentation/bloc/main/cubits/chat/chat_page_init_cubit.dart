import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_event.dart';

/// State holding properties indicating if the chat initialization failed and the active user.
class ChatPageInitState {
  final String currentUserId;
  final bool isError;
  const ChatPageInitState({required this.currentUserId, this.isError = false});
}

/// Cubit responsible for initializing a chat room immediately when the chat page opens.
class ChatPageInitCubit extends Cubit<ChatPageInitState> {
  final ChatBloc chatBloc;

  ChatPageInitCubit({required this.chatBloc}) : super(const ChatPageInitState(currentUserId: ''));

  void initChat({
    required String orderId,
    required String? sellerId,
    required String? productId,
    required String? productName,
    required String? productImage,
  }) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(const ChatPageInitState(currentUserId: '', isError: true));
      return;
    }

    final userId = user.uid;
    emit(ChatPageInitState(currentUserId: userId, isError: false));

    chatBloc.add(CreateChatRoomEvent(
      orderId: orderId,
      userId: userId,
      adminId: sellerId ?? 'admin',
      productId: productId,
      productName: productName,
      productImage: productImage,
    ));
  }
}
