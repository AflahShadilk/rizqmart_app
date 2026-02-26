

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/features/auth/presentation/pages/onboarding/widget/welcome_page_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/auth/welcome_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/auth/welcome_state.dart';

/// A flow widget that manages the onboarding welcome pages and animations for new users before they log in.
class WelcomeFlow extends StatelessWidget {
  const WelcomeFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WelcomeCubit(),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatefulWidget {
  const _WelcomeView();

  @override
  State<_WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<_WelcomeView> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
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
      Navigator.pushReplacementNamed(context, AppRoutes.login);
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
          ),
          
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
          
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                
                BlocBuilder<WelcomeCubit, WelcomeState>(
                  builder: (context, state) {
                    final currentPage = (state is WelcomePageUpdated) ? state.currentPage : 0;
                    return Row(
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
                            width: currentPage == index ? 28 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
