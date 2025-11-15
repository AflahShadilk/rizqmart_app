import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/core/constants.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/login_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/navigation_bar.dart';
import 'package:rizqmart/features/auth/presentation/pages/onboarding/welcome1.dart';
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

  Future<void> _navigateAfterAnimation() async {
    final pref = await SharedPreferences.getInstance();
    final userLogin = pref.getBool(saveKey) ?? false;
    final haseen = pref.getBool('welcome') ?? false;

    if (!mounted) return;

    if (!haseen) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeFlow()),
      );
    } else if (userLogin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => NavigationBarPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
