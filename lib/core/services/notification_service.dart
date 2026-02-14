import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/chat/chat_page.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    // 1. Request Permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Setup Local Notifications
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          _handleNotificationClick(response.payload!, navigatorKey);
        }
      },
    );

    // 3. Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showLocalNotification(message);
        _saveNotificationToFirestore(
           title: message.notification!.title ?? 'New Notification',
           body: message.notification!.body ?? '',
           type: message.data['type'] ?? 'general',
           referenceId: message.data['chatId'] ?? message.data['orderId'],
        );
      }
    });

    // 4. Background/Terminated Messages (User taps notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message, navigatorKey);
    });

    // Handle Terminated State (Initial Launch)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
        _handleMessage(initialMessage, navigatorKey);
    }
  }

  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  void _showLocalNotification(RemoteMessage message) {
    // Create channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', 
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    _localNotifications.show(
      message.notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleMessage(RemoteMessage message, GlobalKey<NavigatorState> navigatorKey) {
     _handleNotificationClick(jsonEncode(message.data), navigatorKey);
  }

  void _handleNotificationClick(String payload, GlobalKey<NavigatorState> navigatorKey) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      // Expecting data: { chatId, orderId, productId ... }
      if (data.containsKey('chatId') || data.containsKey('orderId')) {
         // Determine data for ChatPage
         final orderId = data['orderId'] ?? 'unknown_order'; // Fallback logic
         final productId = data['productId']; // Can be null
         
         navigatorKey.currentState?.push(
           MaterialPageRoute(
             builder: (_) => ChatPage(
               orderId: orderId,
               orderDisplayId: data['orderDisplayId'] ?? orderId.substring(0, 5), 
               deliveryPartnerName: data['sellerName'] ?? 'Seller', // Should be in payload
               productId: productId,
               productName: data['productName'],
               productImage: data['productImage'],
             ),
           ),
         );
      }
    } catch (e) {
      debugPrint("Error parsing notification payload: $e");
    }
  }

  // Save notification to Firestore (Preserved feature)
  Future<void> _saveNotificationToFirestore({
    required String title,
    required String body,
    required String type,
    String? referenceId,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .add({
          'title': title,
          'body': body,
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
          'type': type,
          'referenceId': referenceId,
        });
      }
    } catch (e) {
      debugPrint('Error saving notification to Firestore: $e');
    }
  }
}
