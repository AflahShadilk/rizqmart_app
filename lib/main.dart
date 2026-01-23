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

      // ignore: empty_catches
      } catch (e) {

      }

      try {
        await dotenv.load(fileName: ".env");

      // ignore: empty_catches
      } catch (e) {

      }

      await StripeService.initialize();

      try {
        setupLocator();

      // ignore: empty_catches
      } catch (e) {

      }

      runApp(const MyApp());
    },
    (error, stackTrace) {

    },
  );

  FlutterError.onError = (FlutterErrorDetails details) {

  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProviders();
  }
}