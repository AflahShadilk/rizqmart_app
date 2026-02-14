import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rizqmart/core/services/registeration/bloc_providers.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/services/notification_service.dart';
import 'package:rizqmart/core/services/stripe_services.dart';
import 'package:rizqmart/firebase_options.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        print('✅ Firebase initialized successfully');
      } catch (e) {
        print('❌ Firebase initialization error: $e');
        // Don't continue if Firebase fails - it's critical
        rethrow;
      }

      try {
        await dotenv.load(fileName: ".env");
        print('✅ .env file loaded');
      } catch (e) {
        print('⚠️ .env file load error (this is ok if not using .env): $e');
        // This can fail safely if you don't have a .env file
      }

      try {
        await StripeService.initialize();
        print('✅ Stripe initialized');
      } catch (e) {
        print('❌ Stripe initialization error: $e');
      }

      try {
        await NotificationService().initialize(navigatorKey);
        print('✅ Notification service initialized');
      } catch (e) {
        print('❌ Notification service error: $e');
      }

      try {
        setupLocator();
        print('✅ Locator setup complete');
      } catch (e) {
        print('❌ Locator setup error: $e');
      }

      runApp(MyApp(navigatorKey: navigatorKey));
    },
    (error, stackTrace) {

    },
  );

  FlutterError.onError = (FlutterErrorDetails details) {

  };
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return BlocProviders(navigatorKey: navigatorKey);
  }
}