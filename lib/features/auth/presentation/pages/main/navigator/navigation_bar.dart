// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/navigation/navigation_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/cart/cart_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/dashboard_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/explore/explore_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/profile_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/wish_list_page.dart';

class NavigationBarPage extends StatelessWidget {
  const NavigationBarPage({super.key});

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return const ExplorePage();
      case 2:
        return FavoritePage();
      case 3:
        return CartPage();
      case 4:
        return const ProfilePage();
      default:
        return const DashboardPage();
    }
  }

  Widget _buildBottomNavBar(BuildContext context, int selectedIndex) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: GNav(
            rippleColor: AppColors.grey300,
            hoverColor: AppColors.grey100,
            gap: 4,
            activeColor: AppColors.white,
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            duration: const Duration(milliseconds: 300),
            tabBackgroundColor: context.cs.primary,
            color: context.cs.onBackground,
            tabs: const [
              GButton(icon: Icons.dashboard, text: 'Home'),
              GButton(icon: Icons.search, text: 'Explore'),
              GButton(icon: Icons.favorite_border, text: 'Wishlist'),
              GButton(icon: Icons.shopping_cart_outlined, text: 'Cart'),
              GButton(icon: Icons.person_2_outlined, text: 'Profile'),
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: _buildPage(selectedIndex),
            bottomNavigationBar: _buildBottomNavBar(context, selectedIndex),
          );
        },
      ),
    );
  }
}