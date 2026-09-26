import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/data/data_source/services/notification_service.dart';
import 'package:rizqmart/features/data/model/main/chat_model.dart';
import 'package:rizqmart/features/data/model/main/message_model.dart';
import 'package:rizqmart/features/domain/entities/main/message_entity.dart';

/// Remote data source for real-time chat functionality, managing chat rooms and messages in Firestore.
class ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSource(this.firestore);

  Future<String> createChatRoom({
    required String orderId,
    required String userId,
    String adminId = 'admin',
    String? productId,
    String? productName,
    String? productImage,
    String? userFcmToken,
  }) async {
    final chatRef = firestore.collection('chatRooms').doc(orderId);

    await chatRef.set({
      'orderId': orderId,
      'userId': userId,
      'adminId': adminId,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'userFcmToken': userFcmToken,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return orderId;
  }

  Stream<List<ChatModel>> getUserChats(String userId) {
    return firestore
        .collection('chatRooms')
        .where('userId', isEqualTo: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<ChatModel>> getAdminChats(String adminId) {
    return firestore
        .collection('chatRooms')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<MessageEntity>> getMessages(String chatId) {
    return firestore
        .collection('chatRooms')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    required String senderRole,
  }) async {
    final batch = firestore.batch();

    final chatRef = firestore.collection('chatRooms').doc(chatId);
    final messageRef = chatRef.collection('messages').doc();

    final messageData = {
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
      'senderRole': senderRole,
    };

    batch.set(messageRef, messageData);

    batch.update(chatRef, {
      'lastMessage': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    // Create notification for the other participant
    if (senderRole == 'admin') {
      try {
        final chatDoc = await chatRef.get();
        final chatData = chatDoc.data();
        if (chatData != null) {
          final userId = chatData['userId'] as String?;
          if (userId != null && userId.isNotEmpty) {
            final truncatedText = text.length > 100 ? '${text.substring(0, 100)}...' : text;
            await firestore
                .collection('users')
                .doc(userId)
                .collection('notifications')
                .add({
              'title': 'New Message',
              'body': truncatedText,
              'type': 'chat',
              'referenceId': chatId,
              'isRead': false,
              'timestamp': FieldValue.serverTimestamp(),
              'data': {
                'orderId': chatData['orderId'] ?? chatId,
                'productId': chatData['productId'],
                'productName': chatData['productName'],
                'productImage': chatData['productImage'],
              },
            });

            // Show local notification in the phone's notification bar
            await NotificationService().showNotification(
              title: 'New Message',
              body: truncatedText,
              data: {'chatId': chatId, 'orderId': chatData['orderId'] ?? chatId, 'type': 'chat'},
            );
          }
        }
      } catch (_) {
        // Don't fail the message send if notification creation fails
      }
    }
  }
}
