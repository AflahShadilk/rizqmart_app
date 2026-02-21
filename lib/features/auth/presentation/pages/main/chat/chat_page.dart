

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/chat/chat_send_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/chat/widgets/chat_bubble.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

class ChatPage extends StatefulWidget {
  final String orderId;
  final String orderDisplayId;
  final String deliveryPartnerName;
  final String? productId;
  final String? productName;
  final String? productImage;
  final String? sellerId;

  const ChatPage({
    super.key,
    required this.orderId,
    required this.orderDisplayId,
    required this.deliveryPartnerName,
    this.productId,
    this.productName,
    this.productImage,
    this.sellerId,
    this.orderStatus = 'active', 
  });

  final String orderStatus;


  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final String _currentUserId;
  late final String _chatId;
  late final ChatSendCubit _chatSendCubit;

  @override
  void initState() {
    super.initState();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    _chatId = widget.orderId;
    _chatSendCubit = ChatSendCubit(chatBloc: context.read<ChatBloc>());

    
    context.read<ChatBloc>().add(CreateChatRoomEvent(
      orderId: widget.orderId,
      userId: _currentUserId,
      adminId: widget.sellerId ?? 'admin',
      productId: widget.productId,
      productName: widget.productName,
      productImage: widget.productImage,
    ));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final sent = _chatSendCubit.sendMessage(
      text: _messageController.text,
      chatId: _chatId,
      senderId: _currentUserId,
      senderRole: 'user',
    );
    if (sent) _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.deliveryPartnerName, style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text('Order #${widget.orderDisplayId}', style: context.ts.bodySmall),
          ],
        ),
        backgroundColor: context.cs.surface,
        elevation: 1,
        shadowColor: context.cs.shadow.withValues(alpha: 0.1),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatMessagesLoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          if (state is ChatLoadingState || state is ChatInitialState) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ChatErrorState) {
            return Center(child: Text(state.message));
          }

          return Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                     if (state is ChatMessagesLoadedState) {
                       if (state.messages.isEmpty) {
                         return Center(child: Text('Start conversation with ${widget.deliveryPartnerName}', style: context.ts.bodyMedium?.copyWith(color: context.cs.onSurfaceVariant)));
                       }
                       return ListView.builder(
                         controller: _scrollController,
                         itemCount: state.messages.length,
                         padding: const EdgeInsets.symmetric(vertical: 16),
                         reverse: true, 
                         itemBuilder: (context, index) {
                           final message = state.messages[index];
                           return ChatBubble(
                             message: message,
                             isMe: message.senderId == _currentUserId,
                           );
                         },
                       );
                     }
                     return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              if (widget.orderStatus.toLowerCase() == 'cancelled')
                _buildCancelledMessage(context)
              else
                _buildInputArea(context),
            ],
          );

        },
      ),
    ));
  }

  Widget _buildCancelledMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.red.withValues(alpha: 0.1),
      child: Column(
        children: [
          Icon(Icons.block, color: Colors.red.withValues(alpha: 0.7)),
          8.h,
          Text(
            'This chat is closed because the order was cancelled.',
            style: context.ts.bodyMedium?.copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        boxShadow: [
          BoxShadow(
            color: context.cs.shadow.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          8.w,
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send_rounded, color: context.cs.primary),
            style: IconButton.styleFrom(
              backgroundColor: context.cs.primary.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
