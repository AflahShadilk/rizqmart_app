// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/dashboard_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/explore/explore_page.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wishlist/wish_list_page.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int selectedIndex=0;
  final List<Widget>pages=const[
    DashboardPage(),
    ExplorePage(),
    FavoritePage(),
  ];
  @override
  Widget build(BuildContext context) {
    final colorScheme=Theme.of(context).colorScheme;
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.01),
           boxShadow: [
            BoxShadow(
              blurRadius: 20,
              
              color: Colors.black.withOpacity(0.1),
            )
          ],
        ),
        child: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: GNav(
       
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.green,
              color: Colors.black,
          tabs:const[
            GButton(icon:Icons.dashboard,text: 'DashBoard',),
            GButton(icon: Icons.manage_search_outlined,text: 'Explore',),
            GButton(icon: Icons.favorite_border,text: 'Favourite',),

          ],selectedIndex: selectedIndex,
          onTabChange: (value) {
            setState(() {
              selectedIndex=value;
            });
          },
           ),
        )),
      ),
    );
  }
}