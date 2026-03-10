import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/navigation/navigation_cubit.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/navigator/widgets/bottom_navigation_bar_widget.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/navigator/widgets/page_container.dart';

// ---------------- Navigation Bar Page ----------------

/// A bottom navigation bar widget that handles switching between the main app sections (Home, Explore, Wishlist, Cart).
class NavigationBarPage extends StatelessWidget {
  const NavigationBarPage({super.key});

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: PageContainer(selectedIndex: selectedIndex),
            bottomNavigationBar: BottomNavigationBarWidget(selectedIndex: selectedIndex),
          );
        },
      ),
    );
  }
}