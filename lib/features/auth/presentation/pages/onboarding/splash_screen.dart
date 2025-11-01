import 'package:flutter/material.dart';
import 'package:rizqmart/core/constants.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/login_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/dashboard_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/onboarding/welcome1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  // ignore: unused_field
  late Animation<double> _perspectiveAnimation;

  @override
  void initState() {
    super.initState();
    userLogin();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Flip/Rotation animation - rotates 360 degrees
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Scale animation - grows from small to normal
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Perspective/bounce effect
    _perspectiveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    
  }

  Future<void> userLogin() async {

    final pref = await SharedPreferences.getInstance();
    final userLogin = pref.getBool(saveKey) ?? false;
    final haseen = pref.getBool('welcome') ?? false;
    
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    if (!haseen) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeFlow()));
    } else if (userLogin) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DashboardPage()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001) // Perspective
                      ..rotateY(
                          _rotationAnimation.value * 6.28) // Full 360 rotation 
                      ..scale(_scaleAnimation.value),
                    child: child,
                  );
                },
                child: Image.asset(
                  "assets/icons_and_images/appIcon.png",
                  width: 180,
                  height: 180,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome to RizqMart",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your smart shopping companion",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
