

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rizqmart/core/services/registeration/bloc_providers.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/services/notification_service.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:rizqmart/core/services/stripe_services.dart';
import 'package:rizqmart/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        debugPrint('Error loading .env file: $e');
      }

      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        
        FirebaseMessaging.onBackgroundMessage(
            firebaseMessagingBackgroundHandler);
      } catch (e) {
        debugPrint('Firebase initialization error: $e');
      }

      try {
        await StripeService.initialize();
      } catch (e) {
        debugPrint('Stripe initialization error: $e');
      }

      try {
        await NotificationService().initialize(navigatorKey);
      } catch (e) {
        debugPrint('Notification Service error: $e');
      }

      try {
        setupLocator();
      } catch (e) {
        debugPrint('Locator setup error: $e');
      }

      runApp(MyApp(navigatorKey: navigatorKey));
    },
    (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
    },
  );

  FlutterError.onError = FlutterError.presentError;
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return BlocProviders(navigatorKey: navigatorKey);
  }
}
