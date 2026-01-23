// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/bloc/chat/chat_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/chat/chat_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/chat/chat_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/chat/widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String orderId;
  final String orderDisplayId;
  final String deliveryPartnerName;

  const ChatPage({
    super.key,
    required this.orderId,
    required this.orderDisplayId,
    required this.deliveryPartnerName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentChatId;
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Initiate chat on load
    context.read<ChatBloc>().add(InitiateChatEvent(
      userId: _currentUserId,
      sellerId: 'admin', // Hardcoded for now
      orderId: widget.orderId,
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
    if (_messageController.text.trim().isEmpty || _currentChatId == null) return;

    context.read<ChatBloc>().add(SendMessageEvent(
      chatId: _currentChatId!,
      senderId: _currentUserId,
      content: _messageController.text.trim(),
    ));

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        shadowColor: context.cs.shadow.withOpacity(0.1),
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatInitiatedState) {
            _currentChatId = state.chatId;
          }
          if (state is ChatMessagesLoadedState) {
            // Scroll to bottom when new messages arrive
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
                         // Messages come descending (newest first), so we should reverse or handle accordingly.
                         // But ChatDataSource sends desc. Let's create bubble list.
                         // For chat UI it's better to reverse the list view or sort messages as asc.
                         // Let's check DataSource query: `orderBy('timestamp', descending: true)`.
                         // So index 0 is NEWEST.
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
              _buildInputArea(context),
            ],
          );
        },
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
            color: context.cs.shadow.withOpacity(0.1),
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
                fillColor: context.cs.surfaceContainerHighest.withOpacity(0.5),
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
              backgroundColor: context.cs.primary.withOpacity(0.1),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
