import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/navigation/navigation_cubit.dart';

// ---------------- Bottom Navigation Bar Widget ----------------

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigationBarWidget({super.key, required this.selectedIndex});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: GNav(
            rippleColor: context.cs.onSurface.withValues(alpha: 0.08),
            hoverColor: context.cs.onSurface.withValues(alpha: 0.05),
            gap: 4,
            activeColor: context.cs.surface,
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            duration: const Duration(milliseconds: 300),
            tabBackgroundColor: context.cs.primary,
            color: context.cs.onSurface,
            tabs: const [
              GButton(icon: Icons.dashboard, text: 'Home'),
              GButton(icon: Icons.search, text: 'Explore'),
              GButton(icon: Icons.favorite_border, text: 'Wishlist'),
              GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
            ],
            selectedIndex: selectedIndex,
            onTabChange: (value) {
              context.read<NavigationCubit>().updateIndex(value);
            },
          ),
        ),
      ),
    );
  }
}
