// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rizqmart/core/constant/constants.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/features/data/data_source/services/notification_service.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizqmart/features/presentation/widgets/common/icon_and_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _navigateAfterAnimation);
  }

  Future<void> _navigateAfterAnimation() async {
    final pref = await SharedPreferences.getInstance();
    final userLogin = pref.getBool(saveKey) ?? false;
    final haseen = pref.getBool('welcome') ?? false;

    if (!mounted) return;

    await NotificationService().checkInitialMessage(navigatorKey);

    if (!haseen) {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    } else if (userLogin) {
      Navigator.pushReplacementNamed(context, AppRoutes.navigationBar);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconRizq(),
              const SizedBox(height: 16),
              const RizqMartName(),
              const SizedBox(height: 48),
              CircularProgressIndicator(
                color: context.cs.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
