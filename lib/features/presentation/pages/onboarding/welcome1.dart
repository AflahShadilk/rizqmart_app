import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/features/presentation/pages/onboarding/widget/welcome_page_widget.dart';
import 'package:rizqmart/features/presentation/pages/onboarding/widget/onboarding_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/cubits/auth/welcome_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/auth/welcome_state.dart';

// ---------------- Welcome Flow ----------------

/// A flow widget that manages the onboarding welcome pages and animations
/// for new users before they log in.
class WelcomeFlow extends StatelessWidget {
  const WelcomeFlow({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeCubit(),
      child: const _WelcomeView(),
    );
  }
}

// ---------------- Welcome View ----------------

class _WelcomeView extends StatefulWidget {
  const _WelcomeView();

  @override
  State<_WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<_WelcomeView>
    with TickerProviderStateMixin {

  // ---------------- Controllers ----------------

  final PageController _pageController = PageController();
  late AnimationController _animationController;

  // ---------------- Variables ----------------

  static const int _totalPages = 3;

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  // ---------------- Dispose ----------------

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // ---------------- Helper Methods ----------------

  Future<void> _completeOnboarding() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('welcome', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _skipToEnd() {
    _animationController.forward(from: 0.0);
    _pageController.jumpToPage(_totalPages - 1);
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---------------- Page View ----------------
          BlocListener<WelcomeCubit, WelcomeState>(
            listener: (context, state) {
              _animationController.forward(from: 0.0);
            },
            child: PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                context.read<WelcomeCubit>().setPage(index);
              },
              children: [
                OnboardingPageContent(
                  title: 'Fresh & Organic',
                  subtitle:
                      'Get your groceries straight from farms to your doorstep.',
                  imagePath: 'assets/icons_and_images/leeficon.png',
                  bgColor: const Color(0xFF81C784),
                  onPress: _completeOnboarding,
                ),
                OnboardingPageContent(
                  title: 'Lightning Fast Delivery',
                  subtitle:
                      'Delivered in as fast as one hour, right when you need it.',
                  imagePath: 'assets/icons_and_images/deliveryIcon.png',
                  bgColor: const Color(0xFF4DB6AC),
                  onPress: _completeOnboarding,
                ),
                OnboardingPageContent(
                  title: 'Easy, Secure & Refundable',
                  subtitle:
                      'Shop with confidence. Easy returns and secure payments.',
                  imagePath: 'assets/icons_and_images/secureicon.png',
                  bgColor: const Color(0xFF7986CB),
                  showButton: true,
                  onPress: _completeOnboarding,
                ),
              ],
            ),
          ),

          // ---------------- Skip Button ----------------
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

          // ---------------- Page Indicator ----------------
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                OnboardingIndicator(
                  pageCount: _totalPages,
                  animationController: _animationController,
                ),
                25.h,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
