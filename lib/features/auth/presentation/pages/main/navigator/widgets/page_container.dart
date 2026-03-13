import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/cart/cart_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/dashboard_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/explore/explore_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/wish_list_page.dart';
class PageContainer extends StatelessWidget {
  final int selectedIndex;

  const PageContainer({super.key, required this.selectedIndex});
@override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const DashboardPage();
      case 1:
        return const ExplorePage();
      case 2:
        return FavoritePage();
      case 3:
        return CartPage();
      default:
        return const DashboardPage();
    }
  }
}
