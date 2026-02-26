  import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/navigator/navigation_bar.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

/// Displays a friendly placeholder view when the user has no saved items in their favorites.
Widget buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: AppColors.grey400,
          ),
          16.h,
          Text(
            'No Favorites Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          8.h,
          Text(
            'Add products to your favorites to see them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          24.h,
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>NavigationBarPage()));
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }