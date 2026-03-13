// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/core/constants.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/services/notification_service.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
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
      body: Center(
        child: Lottie.asset(
          'assets/lottie/Shopping Cart.json',
          controller: _lottieController,
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          onLoaded: (composition) {
            _lottieController
              ..duration = composition.duration
              ..forward().whenComplete(_navigateAfterAnimation);
          },
        ),
      ),
    );
  }
}
