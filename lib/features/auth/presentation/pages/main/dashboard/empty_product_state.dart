// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

Widget buildEmpty(BuildContext context, bool _isSearching, dynamic _searchController,void Function() onPress) {
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
            
              color: colorScheme.primary.withOpacity(0.1),
            ),
            child: Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 60,
                color: colorScheme.primary.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Products Found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colorScheme.onBackground,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSearching
                ? 'No products match "${_searchController.text}"'
                : 'No products available at the moment',
            style: TextStyle(
              color: colorScheme.onBackground.withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (_isSearching)
            ElevatedButton(
              onPressed: onPress,
              child: const Text('Clear Search'),
            ),
        ],
      ),
    );
  }