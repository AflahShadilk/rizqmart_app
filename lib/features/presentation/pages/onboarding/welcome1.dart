import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/cubits/auth/welcome_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/auth/welcome_state.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/reusable_main_button.dart';

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

class _WelcomeViewState extends State<_WelcomeView> {
  final PageController _pageController = PageController();

  static const int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('welcome', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _nextOrComplete(int currentPage) {
    if (currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipToEnd() {
    _pageController.jumpToPage(_totalPages - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                child: TextButton(
                  onPressed: _skipToEnd,
                  child: Text(
                    'Skip',
                    style: context.ts.bodyLarge?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  context.read<WelcomeCubit>().setPage(index);
                },
                children: const [
                  _OnboardingPage(
                    title: 'Fresh & Organic',
                    subtitle:
                        'Get your groceries straight from farms to your doorstep.',
                    imagePath: 'assets/icons_and_images/leeficon.png',
                  ),
                  _OnboardingPage(
                    title: 'Lightning Fast Delivery',
                    subtitle:
                        'Delivered in as fast as one hour, right when you need it.',
                    imagePath: 'assets/icons_and_images/deliveryIcon.png',
                  ),
                  _OnboardingPage(
                    title: 'Easy, Secure & Refundable',
                    subtitle:
                        'Shop with confidence. Easy returns and secure payments.',
                    imagePath: 'assets/icons_and_images/secureicon.png',
                  ),
                ],
              ),
            ),
            BlocBuilder<WelcomeCubit, WelcomeState>(
              builder: (context, state) {
                int currentPage = 0;
                if (state is WelcomeInitial) {
                  currentPage = state.currentPage;
                } else if (state is WelcomePageUpdated) {
                  currentPage = state.currentPage;
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _totalPages,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? context.cs.secondary
                                  : context.cs.onSurface.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      32.h,
                      SizedBox(
                        width: double.infinity,
                        child: MainButton(
                          label: currentPage == _totalPages - 1
                              ? 'Get Started'
                              : 'Next',
                          onPress: () => _nextOrComplete(currentPage),
                          color: context.cs.primary,
                          textColor: context.cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.ts.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.cs.onSurface,
                  ),
                ),
                16.h,
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: context.ts.bodyLarge?.copyWith(
                    color: context.cs.onSurface.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
