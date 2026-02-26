

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/chat/chat_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/chat/chat_send_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/chat/chat_page_init_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/chat/widgets/chat_bubble.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';
import 'package:rizqmart/features/auth/presentation/widgets/app_custom_colors.dart';

/// Main chat screen displaying messages between user and delivery partner/seller.
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

/// Manages chat dependencies, scroll controller, and message inputs.
class _ChatPageState extends State<ChatPage> {
  // Controller for multiline message input
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatSendCubit _chatSendCubit;
  late final ChatPageInitCubit _chatPageInitCubit;

  @override
  void initState() {
    super.initState();
    // Send message operations
    _chatSendCubit = ChatSendCubit(chatBloc: context.read<ChatBloc>());
    // Initialization: fetches UserId and handles chat room creation
    _chatPageInitCubit = ChatPageInitCubit(chatBloc: context.read<ChatBloc>());

    _chatPageInitCubit.initChat(
      orderId: widget.orderId,
      sellerId: widget.sellerId,
      productId: widget.productId,
      productName: widget.productName,
      productImage: widget.productImage,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatSendCubit.close();
    _chatPageInitCubit.close();
    super.dispose();
  }

  /// Animates the scroll view to the latest message at the bottom.
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Sends the current text using [ChatSendCubit].
  void _sendMessage(String currentUserId) {
    if (currentUserId.isEmpty) return;
    final sent = _chatSendCubit.sendMessage(
      text: _messageController.text,
      chatId: widget.orderId,
      senderId: currentUserId,
      senderRole: 'user',
    );
    if (sent) _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
      backgroundColor: context.cs.surface,
      // Top bar showing partner name and order ID
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
      // Main body reacting to different ChatBloc states
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          // Auto-scroll when new messages arrive
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

          return BlocProvider.value(
            value: _chatPageInitCubit,
            // Resolves currentUserId and ensures user is logged in
            child: BlocBuilder<ChatPageInitCubit, ChatPageInitState>(
              builder: (context, initState) {
                if (initState.isError || initState.currentUserId.isEmpty) {
                  return Center(
                    child: Text('Please log in to chat',
                        style: context.ts.bodyMedium?.copyWith(color: AppCustomColors.errorText)),
                  );
                }

                final currentUserId = initState.currentUserId;

                return Column(
                  children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                     if (state is ChatMessagesLoadedState) {
                       if (state.messages.isEmpty) {
                         return Center(child: Text('Start conversation with ${widget.deliveryPartnerName}', style: context.ts.bodyMedium?.copyWith(color: context.cs.onSurfaceVariant)));
                       }
                       // Renders message history efficiently using ListView.builder
                       return ListView.builder(
                         controller: _scrollController,
                         itemCount: state.messages.length,
                         padding: const EdgeInsets.symmetric(vertical: 16),
                         reverse: true, 
                         itemBuilder: (context, index) {
                           final message = state.messages[index];
                           final bool isMe = message.senderId == currentUserId;
                           
                           // Logic to display a date header when messages cross days
                           bool showDateHeader = false;
                           if (index == state.messages.length - 1) {
                             showDateHeader = true;
                           } else {
                             final prevMessage = state.messages[index + 1];
                             final messageDate = DateTime(message.timestamp.year, message.timestamp.month, message.timestamp.day);
                             final prevMessageDate = DateTime(prevMessage.timestamp.year, prevMessage.timestamp.month, prevMessage.timestamp.day);
                             if (messageDate != prevMessageDate) {
                               showDateHeader = true;
                             }
                           }

                           return Column(
                             children: [
                               // Injects date divider on new days
                               if (showDateHeader) _buildDateDivider(message.timestamp),
                               // Extracts and formats the message content
                               ChatBubble(
                                 message: message,
                                 isMe: isMe,
                               ),
                             ],
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
                  _buildInputArea(context, currentUserId),
              ],
            );
          }));

        },
      ),
    ));
  }

  /// Shows an overlay banner if the order is cancelled, preventing further chatting.
  Widget _buildCancelledMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppCustomColors.errorBackground,
      child: Column(
        children: [
          const Icon(Icons.block, color: AppCustomColors.errorIcon),
          8.h,
          Text(
            'This chat is closed because the order was cancelled.',
            style: context.ts.bodyMedium?.copyWith(color: AppCustomColors.errorText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Input section for composing a new message (contains TextField and Send Button).
  Widget _buildInputArea(BuildContext context, String currentUserId) {
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
              keyboardType: TextInputType.multiline,
              minLines: 1, // Multiline input support
              maxLines: 5,
              textInputAction: TextInputAction.newline,
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
            onPressed: () => _sendMessage(currentUserId),
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

  /// Simple line divider with a formatted date string centered.
  Widget _buildDateDivider(DateTime timestamp) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(child: Divider(color: context.cs.outlineVariant.withValues(alpha: 0.5))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(timestamp),
              style: context.ts.labelSmall?.copyWith(
                color: context.cs.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Divider(color: context.cs.outlineVariant.withValues(alpha: 0.5))),
        ],
      ),
    );
  }

  String _formatDate(DateTime timestamp) {
    return DateFormat('MMMM dd, yyyy • hh:mm a').format(timestamp);
  }
}
