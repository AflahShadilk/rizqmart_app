import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/data/model/main/chat_model.dart';
import 'package:rizqmart/features/auth/data/model/main/message_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/message_entity.dart';

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
  }
}
