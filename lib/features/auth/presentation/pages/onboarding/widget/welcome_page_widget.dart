import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class OnboardingPageContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color bgColor;
  final bool showButton;
  final VoidCallback? onPress;

  const OnboardingPageContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.bgColor,
    this.showButton = false,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            width: 180,
            height: 180,
            child: Image.asset(imagePath),
          ),
          32.h,

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          16.h,

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const Spacer(),

          if (showButton)
            ElevatedButton(
              onPressed: onPress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          20.h,
        ],
      ),
    );
  }
}