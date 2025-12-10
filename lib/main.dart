import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rizqmart/core/services/registeration/bloc_providers.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/firebase_options.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        setupLocator();

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