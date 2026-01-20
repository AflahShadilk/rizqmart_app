import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/data/model/chat/message_model.dart';
import 'package:rizqmart/features/auth/domain/entities/chat/message_entity.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSource(this.firestore);

  Future<String> initiateChat({
    required String userId,
    required String sellerId,
    required String orderId,
  }) async {
    // Check if chat already exists for this order
    final querySnapshot = await firestore
        .collection('chats')
        .where('orderId', isEqualTo: orderId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }

    // Create new chat
    final docRef = await firestore.collection('chats').add({
      'userId': userId,
      'sellerId': sellerId,
      'orderId': orderId,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'participants': [userId, sellerId],
    });

    return docRef.id;
  }

  Stream<List<MessageEntity>> getMessages(String chatId) {
    return firestore
        .collection('chats')
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
    required String content,
    String type = 'text',
  }) async {
    final batch = firestore.batch();

    final chatRef = firestore.collection('chats').doc(chatId);
    final messageRef = chatRef.collection('messages').doc();

    final messageData = {
      'senderId': senderId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'type': type,
      'isRead': false,
    };

    batch.set(messageRef, messageData);

    batch.update(chatRef, {
      'lastMessage': content,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}
