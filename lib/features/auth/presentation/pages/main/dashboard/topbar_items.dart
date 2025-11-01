// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/icon_and_name.dart';

Container topBarItems(BuildContext context, TextEditingController controller,
    Function(String) onSearch) {
  final colorScheme = Theme.of(context).colorScheme;

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(0.05),
      boxShadow: [
        BoxShadow(
          color: colorScheme.onBackground.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: const IconRizq(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery to',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Your Location',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: TextField(
            controller: controller,
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
              suffixIcon: controller.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        controller.clear();
                        onSearch('');
                      },
                      child: Icon(
                        Icons.clear,
                        color: colorScheme.onSurface.withOpacity(0.4),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.greenAccent,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? colorScheme.onBackground.withOpacity(0.05)
                  : colorScheme.onBackground.withOpacity(0.03),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            style: TextStyle(
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    ),
  );
}
