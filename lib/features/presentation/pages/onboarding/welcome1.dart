import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/presentation/cubits/auth/welcome_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/auth/welcome_state.dart';

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

  void _skipToEnd() {
    _pageController.jumpToPage(_totalPages - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              context.read<WelcomeCubit>().setPage(index);
            },
            children: const [
              _OnboardingPage(
                title: 'Fresh & Organic',
                subtitle: 'Get your groceries straight from farms to your doorstep.',
                imagePath: 'assets/icons_and_images/leeficon.png',
              ),
              _OnboardingPage(
                title: 'Lightning Fast Delivery',
                subtitle: 'Delivered in as fast as one hour, right when you need it.',
                imagePath: 'assets/icons_and_images/deliveryIcon.png',
              ),
              _OnboardingPage(
                title: 'Easy, Secure & Refundable',
                subtitle: 'Shop with confidence. Easy returns and secure payments.',
                imagePath: 'assets/icons_and_images/secureicon.png',
              ),
            ],
          ),
          
          // Bottom Controls (Dots & Button)
          BlocBuilder<WelcomeCubit, WelcomeState>(
            builder: (context, state) {
              int currentPage = 0;
              if (state is WelcomeInitial) {
                currentPage = state.currentPage;
              } else if (state is WelcomePageUpdated) {
                currentPage = state.currentPage;
              }

              return Positioned(
                bottom: 40,
                left: 24,
                right: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Dots
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
                                ? AppColors.primaryBlue
                                : AppColors.dividerGray,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Button (Only on last slide)
                    if (currentPage == _totalPages - 1)
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _completeOnboarding,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 56), // Reserve space so dots don't jump
                  ],
                ),
              );
            },
          ),

          // Skip Button (Top Right)
          BlocBuilder<WelcomeCubit, WelcomeState>(
            builder: (context, state) {
              int currentPage = 0;
              if (state is WelcomeInitial) {
                currentPage = state.currentPage;
              } else if (state is WelcomePageUpdated) {
                currentPage = state.currentPage;
              }

              if (currentPage == _totalPages - 1) {
                return const SizedBox.shrink();
              }

              return Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                right: 16,
                child: TextButton(
                  onPressed: _skipToEnd,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.manrope(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
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
    return Column(
      children: [
        // Top ~60% Image
        Expanded(
          flex: 6,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Bottom ~40% White Panel
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800, // ExtraBold
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1, // one-line gray subtitle
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
