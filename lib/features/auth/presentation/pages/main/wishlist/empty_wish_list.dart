  import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/navigator/navigation_bar.dart';

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
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to your favorites to see them here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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