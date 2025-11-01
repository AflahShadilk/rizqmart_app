// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/pages/auth/login_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/onboarding/widget/welcome_page_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeFlow extends StatefulWidget {
  const WelcomeFlow({super.key});

  @override
  State<WelcomeFlow> createState() => _WelcomeFlowState();
}

class _WelcomeFlowState extends State<WelcomeFlow> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  Future<void> completeOnboarding() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('welcome', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  // ignore: unused_element
  void _nextPage() {
    if (_currentPage < 2) {
      _animationController.forward(from: 0.0);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void _skipToEnd() {
    _animationController.forward(from: 0.0);
    _pageController.jumpToPage(2);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              _animationController.forward(from: 0.0);
            },
            children: [
              buildPage(
                title: 'Fresh & Organic',
                subtitle: 'Get your groceries straight from farms to your doorstep.',
                imagePath: 'assets/icons_and_images/leeficon.png',
                bgColor: const Color(0xFF81C784),
                onpress: () {
                  completeOnboarding();
                },
              ),
              buildPage(
                title: 'Lightning Fast Delivery',
                subtitle: 'Delivered in as fast as one hour, right when you need it.',
                imagePath: 'assets/icons_and_images/deliveryIcon.png',
                bgColor: const Color(0xFF4DB6AC),
                onpress: () {
                  completeOnboarding();
                },
              ),
              buildPage(
                title: 'Easy, Secure & Refundable',
                subtitle: 'Shop with confidence. Easy returns and secure payments.',
                imagePath: 'assets/icons_and_images/secureicon.png',
                bgColor: const Color(0xFF7986CB),
                showButton: true,
                onpress: () {
                  completeOnboarding();
                },
              ),
            ],
          ),
          // Skip Button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _skipToEnd,
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Next and Page 
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Page Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => ScaleTransition(
                      scale: Tween<double>(begin: 1.0, end: 1.3).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.elasticOut,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: _currentPage == index ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Next Button
                // ScaleTransition(
                //   scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                //     CurvedAnimation(
                //       parent: _animationController,
                //       curve: Curves.elasticOut,
                //     ),
                //   ),
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: ElevatedButton(
                //       onPressed: _nextPage,
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.white,
                //         padding: const EdgeInsets.symmetric(vertical: 14),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         elevation: 5,
                //       ),
                //       child: Text(
                //         _currentPage == 2 ? 'Get Started' : 'Next',
                //         style: const TextStyle(
                //           color: Colors.black87,
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //           letterSpacing: 0.5,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}