import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/main/chat/chat_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/chat/chat_state.dart';
import 'package:rizqmart/features/presentation/cubits/chat/chat_send_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/chat/chat_page_init_cubit.dart';
import 'package:rizqmart/features/presentation/pages/main/chat/widgets/chat_bubble.dart';
import 'package:rizqmart/features/presentation/pages/main/chat/widgets/chat_cancelled_banner.dart';
import 'package:rizqmart/features/presentation/pages/main/chat/widgets/chat_date_divider.dart';
import 'package:rizqmart/features/presentation/pages/main/chat/widgets/chat_input_section.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

/// Main chat screen displaying messages between user and delivery partner/seller.
class ChatPage extends StatefulWidget {

  // ---------------- Variables ----------------

  final String orderId;
  final String orderDisplayId;
  final String deliveryPartnerName;
  final String? productId;
  final String? productName;
  final String? productImage;
  final String? sellerId;
  final String orderStatus;

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

  @override
  State<ChatPage> createState() => _ChatPageState();
}

/// Manages chat dependencies, scroll controller, and message inputs.
class _ChatPageState extends State<ChatPage> {

  // ---------------- Controllers ----------------

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatSendCubit _chatSendCubit;
  late final ChatPageInitCubit _chatPageInitCubit;

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    _chatSendCubit = ChatSendCubit(chatBloc: context.read<ChatBloc>());
    _chatPageInitCubit = ChatPageInitCubit(chatBloc: context.read<ChatBloc>());

    _chatPageInitCubit.initChat(
      orderId: widget.orderId,
      sellerId: widget.sellerId,
      productId: widget.productId,
      productName: widget.productName,
      productImage: widget.productImage,
    );
  }

  // ---------------- Dispose ----------------

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatSendCubit.close();
    _chatPageInitCubit.close();
    super.dispose();
  }

  // ---------------- Helper Methods ----------------

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

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
      backgroundColor: context.cs.surface,
      // ---------------- App Bar ----------------
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
      // ---------------- Chat Body ----------------
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatMessagesLoadedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
          }
        },
        builder: (context, state) {
          // ---------------- Loading State ----------------
          if (state is ChatLoadingState || state is ChatInitialState) {
            return const Center(child: CircularProgressIndicator());
          }

          // ---------------- Error State ----------------
          if (state is ChatErrorState) {
            return Center(child: Text(state.message));
          }

          return BlocProvider.value(
            value: _chatPageInitCubit,
            child: BlocBuilder<ChatPageInitCubit, ChatPageInitState>(
              builder: (context, initState) {
                if (initState.isError || initState.currentUserId.isEmpty) {
                  return Center(
                    child: Text('Please log in to chat',
                        style: context.ts.bodyMedium?.copyWith(color: AppColors.chatErrorText)),
                  );
                }

                final currentUserId = initState.currentUserId;

                return Column(
                  children: [
                    // ---------------- Messages List ----------------
                    Expanded(
                      child: BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {
                          if (state is ChatMessagesLoadedState) {
                            if (state.messages.isEmpty) {
                              return Center(
                                child: Text(
                                  'Start conversation with ${widget.deliveryPartnerName}',
                                  style: context.ts.bodyMedium?.copyWith(color: context.cs.onSurfaceVariant),
                                ),
                              );
                            }
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: state.messages.length,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              reverse: true,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                final bool isMe = message.senderId == currentUserId;

                                // Date header logic
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
                                    if (showDateHeader) ChatDateDivider(timestamp: message.timestamp),
                                    ChatBubble(message: message, isMe: isMe),
                                  ],
                                );
                              },
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    // ---------------- Input / Cancelled Section ----------------
                    if (widget.orderStatus.toLowerCase() == 'cancelled')
                      const ChatCancelledBanner()
                    else
                      ChatInputSection(
                        messageController: _messageController,
                        onSend: () => _sendMessage(currentUserId),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    ));
  }
}
