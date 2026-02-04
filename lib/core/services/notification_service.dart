
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Local state for tracking changes to avoid redundant notifications
  final Map<String, String> _lastOrderStatuses = {};
  final Map<String, String> _lastChatMessages = {};

  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> initialize() async {
    try {
      // Android initialization
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
          // Handle notification tap
        },
      );

      // Request permissions for Android 13+
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
          
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  // Show a simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'high_importance_channel', // channel Id
      'High Importance Notifications', // channel Name
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Save notification to Firestore
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
      print('Error saving notification to Firestore: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // LISTENERS
  // ---------------------------------------------------------------------------

  StreamSubscription? _orderSubscription;
  StreamSubscription? _chatSubscription;

  void listenToUserUpdates(String userId) {
    print("🔔 NotificationService: listenToUserUpdates called for User: $userId");
    // Cancel existing subscriptions if any
    dispose();

    listenToOrderUpdates(userId);
    listenToChatUpdates(userId);
  }

  void listenToOrderUpdates(String userId) {
    print("🔔 NotificationService: Subscribing to ORDERS for $userId");
    _orderSubscription = _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      print("🔔 NotificationService: Order snapshot received. Changes: ${snapshot.docChanges.length}");
      for (var change in snapshot.docChanges) {
        print("🔔 Order Change: Type=${change.type}, ID=${change.doc.id}, Data=${change.doc.data()}");
        
        if (change.type == DocumentChangeType.modified || change.type == DocumentChangeType.added) {
          final data = change.doc.data() as Map<String, dynamic>;
          final orderId = change.doc.id;
          final currentStatus = data['status'] as String?;
          
          if (currentStatus == null) {
              print("🔔 Order Status is null for $orderId");
              continue;
          }

          // Check against local cache
          final lastStatus = _lastOrderStatuses[orderId];
          print("🔔 Order Logic: Last=$lastStatus, Current=$currentStatus");

          // Notify only if status has changed from what we last saw
          if (lastStatus != null && lastStatus != currentStatus) {
             print("🔔 Triggering Order Notification: $currentStatus");
             final title = 'Order Updated';
             final body = 'Your order #${orderId.substring(0, 5)} is now $currentStatus';
             
             showNotification(
               id: orderId.hashCode,
               title: title,
               body: body,
             );
             
             _saveNotificationToFirestore(
                 title: title, 
                 body: body, 
                 type: 'order', 
                 referenceId: orderId
             );
          } else {
             print("🔔 No status change detected (or first load).");
          }
          
          // Update Cache
          _lastOrderStatuses[orderId] = currentStatus;
        }
      }
    }, onError: (e) {
        print("❌ Error listening to order updates: $e");
    });
  }

  void listenToChatUpdates(String userId) {
    print("🔔 NotificationService: Subscribing to CHATS for $userId");
    _chatSubscription = _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .listen((snapshot) {
      print("🔔 NotificationService: Chat snapshot received. Changes: ${snapshot.docChanges.length}");
      for (var change in snapshot.docChanges) {
        print("🔔 Chat Change: Type=${change.type}, ID=${change.doc.id}");
        // We only care about Modified (new message in existing chat) or Added (new chat started by someone else?)
        if (change.type == DocumentChangeType.modified) {
          final data = change.doc.data() as Map<String, dynamic>;
          final chatId = change.doc.id;
          final lastSenderId = data['lastSenderId'] as String?;
          final lastMessage = data['lastMessage'] as String?;
          
          print("🔔 Chat Data: Msg='$lastMessage', Sender='$lastSenderId'");

          // Basic validation
          if (lastSenderId == null || lastMessage == null || lastMessage.isEmpty) {
              print("🔔 Chat validation failed (null fields)");
              continue;
          }

          // If I sent it, ignore
          if (lastSenderId == userId) {
             print("🔔 Ignoring message sent by SELF");
             _lastChatMessages[chatId] = lastMessage; 
             continue;
          }

          // Check if we already notified for this exact message content on this chat
          final lastCached = _lastChatMessages[chatId];
          print("🔔 Chat Logic: Cached='$lastCached', New='$lastMessage'");
          
          if (lastCached != lastMessage) {
             print("🔔 Triggering Chat Notification");
             final title = 'New Message';
             
             showNotification(
               id: chatId.hashCode, 
               title: title,
               body: lastMessage,
             );
             
             _saveNotificationToFirestore(
                 title: title, 
                 body: lastMessage, 
                 type: 'chat', 
                 referenceId: chatId,
             );
             
             // Update Cache
             _lastChatMessages[chatId] = lastMessage; 
          } else {
              print("🔔 Message already processed/cached.");
          }
        } else {
            print("🔔 Ignoring Chat Change Type: ${change.type}");
        }
      }
    }, onError: (e) {
        print("❌ Error listening to chat updates: $e");
    });
  }

  void dispose() {
    print("🔔 NotificationService: Disposing listeners");
    _orderSubscription?.cancel();
    _chatSubscription?.cancel();
    _lastOrderStatuses.clear();
    _lastChatMessages.clear();
  }
}
