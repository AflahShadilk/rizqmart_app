import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/widgets/common/reusable_text.dart';
import 'package:rizqmart/features/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';

// ---------------- Success Page ----------------

/// A success confirmation screen shown immediately after an order is successfully placed.
class SuccessPage extends StatelessWidget {
  // ---------------- Variables ----------------
  final List<CartEntities> items;

  // ---------------- Constructor ----------------
  const SuccessPage({super.key, this.items = const []});

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      child: Scaffold(
        backgroundColor: context.cs.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  100.h,
                  
                  // ---------------- Success Animation ----------------
                  Center(
                    child: Lottie.asset(
                      'assets/lottie/Success.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                  30.h,
                  
                  // ---------------- Success Title ----------------
                  Center(
                    child: ReusableText(
                      texts: 'Your Order has been\n          Accepted',
                      titleSize: context.ts.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  16.h,
                  
                  // ---------------- Success Description ----------------
                  Center(
                    child: ReusableText(
                      texts:
                          'Your items has been placed and is on\n        its way to being processed',
                      titleSize: context.ts.bodyMedium?.copyWith(
                        color: context.cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  
                  
                  // ---------------- Action Buttons ----------------
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: MainButton(
                      label: 'Track Order',
                      onPress: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.orders,
                            (route) => route.settings.name == AppRoutes.navigationBar);
                      },
                      color: context.cs.primary,
                      textColor: context.cs.surface,
                    ),
                  ),
                  25.h,
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.navigationBar);
                      },
                      child: Text(
                        'Back to Home',
                        style: context.ts.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
