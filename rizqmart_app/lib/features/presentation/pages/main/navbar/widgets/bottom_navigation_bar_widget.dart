import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/cubits/navigation/navigation_cubit.dart';

// ---------------- Bottom Navigation Bar Widget ----------------

class BottomNavigationBarWidget extends StatelessWidget {
  final int selectedIndex;

  const BottomNavigationBarWidget({super.key, required this.selectedIndex});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withValues(alpha: 0.15),
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: context.cs.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: context.cs.onSurface.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: GNav(
                    rippleColor: context.cs.onSurface.withValues(alpha: 0.08),
                    hoverColor: context.cs.onSurface.withValues(alpha: 0.05),
                    gap: 8,
                    activeColor: context.cs.onPrimary,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    duration: const Duration(milliseconds: 300),
                    tabBackgroundColor: context.cs.primary,
                    color: context.cs.onSurface.withValues(alpha: 0.7),
                    tabs: const [
                      GButton(icon: Icons.dashboard_rounded, text: 'Home'),
                      GButton(icon: Icons.search_rounded, text: 'Explore'),
                      GButton(icon: Icons.favorite_border_rounded, text: 'Wishlist'),
                      GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
                    ],
                    selectedIndex: selectedIndex,
                    onTabChange: (value) {
                      context.read<NavigationCubit>().updateIndex(value);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
