import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/reusable_text.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';


// shown after order is placed successfully
class SuccessPage extends StatelessWidget {
  final List<CartEntities> items;

  const SuccessPage({super.key, this.items = const []});


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
                        color: context.cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  
                  

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