
import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model defining a user notification, tailored for Firestore serialization.
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String type; 
  final String? referenceId; 
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    required this.type,
    this.referenceId,
    this.data,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final docData = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: docData['title'] ?? '',
      body: docData['body'] ?? '',
      timestamp: (docData['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: docData['isRead'] ?? false,
      type: docData['type'] ?? 'general',
      referenceId: docData['referenceId'],
      data: docData['data'] != null 
          ? Map<String, dynamic>.from(docData['data'] as Map) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': isRead,
      'type': type,
      'referenceId': referenceId,
      if (data != null) 'data': data,
    };
  }
}
