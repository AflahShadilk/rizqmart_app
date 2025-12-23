import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rizqmart/core/services/registeration/bloc_providers.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/services/stripe_services.dart';
import 'package:rizqmart/firebase_options.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        debugPrint('✅ Firebase initialized');
      } catch (e) {
        debugPrint('❌ Firebase error: $e');
      }

      try {
        await dotenv.load(fileName: ".env");
        debugPrint('✅ .env loaded');
      } catch (e) {
        debugPrint('❌ .env error: $e');
      }

      await StripeService.initialize();

      try {
        setupLocator();
        debugPrint('✅ Service locator setup');
      } catch (e) {
        debugPrint('❌ Locator error: $e');
      }

      runApp(const MyApp());
    },
    (error, stackTrace) {
      debugPrint('❌ Unhandled error: $error\n$stackTrace');
    },
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('❌ Flutter error: ${details.exception}');
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProviders();
  }
}