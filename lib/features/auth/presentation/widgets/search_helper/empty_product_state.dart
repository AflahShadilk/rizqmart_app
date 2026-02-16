

import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

Widget buildEmpty(BuildContext context, bool isSearching, dynamic searchController,void Function() onPress) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            
              color: colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
          ),
          24.h,
          Text(
            'No Products Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
          ),
          8.h,
          Text(
            isSearching
                ? 'No products match "${searchController.text}"'
                : 'No products available at the moment',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          24.h,
          if (isSearching)
            ElevatedButton(
              onPressed: onPress,
              child: const Text('Clear Search'),
            ),
        ],
      ),
    );
  }