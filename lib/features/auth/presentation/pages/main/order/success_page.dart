// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/navigator/navigation_bar.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/reusable_text.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Lottie.asset(
                  'assets/lottie/Success.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              30.h,
              Center(
                child: ReusableText(
                  texts: 'Your Order has been\n          Accepted',
                  titleSize: context.ts.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              16.h,
              Center(
                child: ReusableText(
                  texts:
                      'Your items has been placed and is on\n        its way to being processed',
                  titleSize: context.ts.bodyMedium?.copyWith(
                    color: context.cs.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: MainButton(
                  label: 'Track Order',
                  onPress: () {},
                  color: context.cs.primary,
                  textColor: context.cs.surface,
                ),
              ),
              25.h,
              Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigationBarPage()));
                      },
                      child: Text(
                        'Back to Home',
                        style: context.ts.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
