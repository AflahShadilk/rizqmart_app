

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/reusable_text.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/product_details/widgets/add_review_dialog.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/review/review_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/responsive_wrapper.dart';


/// A success confirmation screen shown immediately after an order is successfully placed.
class SuccessPage extends StatelessWidget {
  final List<CartEntities> items;
  const SuccessPage({super.key, this.items = const []});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(child: Scaffold(
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
                if (items.isNotEmpty) ...[
                  40.h,
                  Text(
                    "Rate your items:",
                    style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  20.h,
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            image: (item.variantDetails.isNotEmpty &&
                                    item.variantDetails[0]['imageUrl'] != null &&
                                    (item.variantDetails[0]['imageUrl'] as List).isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(
                                        (item.variantDetails[0]['imageUrl'] as List)[0]),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        title: Text(item.name, style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text("Qty: ${item.count}"),
                        trailing: OutlinedButton(
  onPressed: () {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      showDialog(
        context: context,
        builder: (context) => AddReviewDialog(
          productId: item.id,
          userId: user.uid,
          userName: user.displayName ?? 'User',
          userImage: user.photoURL,
          variantName: item.variantDetails.isNotEmpty
              ? item.variantDetails[0]['variantName'] as String?
              : null,
          onSubmit: (review) {
            context.read<ReviewBloc>().add(AddReviewEvent(review: review));
          },
        ),
      );
    }
  },
  child: Text("Rate"),
),
                      );
                    },
                  ),
                ],
                60.h,
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
                        )))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}